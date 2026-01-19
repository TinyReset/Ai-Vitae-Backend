# Workflow Update: Payment Intent Logging

## Overview

After running the database migrations, the main workflow needs to be updated to capture Stripe payment identifiers when processing orders.

## Current State

The workflow currently captures `stripe_session_id` from the incoming webhook payload. The Stripe Checkout flow provides:

- `session.id` (checkout.session.completed) - Currently captured
- `session.payment_intent` - Needs to be captured
- `session.customer` - Needs to be captured

## Required Workflow Changes

### Option A: Webhook Payload Already Includes Payment Intent

If the webhook sender (Stripe) already includes `payment_intent` in the payload:

**Node to Update:** `Upsert Order` (ID: `5cf79354-5c21-4a7d-843d-046cb56025bc`)

**Add to INSERT columns:**
```sql
stripe_payment_intent_id,
stripe_customer_id,
payment_status,
payment_amount_cents,
payment_currency,
payment_date
```

**Add to VALUES:**
```sql
{{ $json.payment_intent }},
{{ $json.customer }},
'succeeded',
{{ $json.amount_total }},
{{ $json.currency }},
NOW()
```

**MCP Operation (example):**
```json
{
  "type": "updateNode",
  "nodeName": "Upsert Order",
  "updates": {
    "parameters": {
      "query": "INSERT INTO public.orders (id, email, package, stripe_session_id, stripe_payment_intent_id, stripe_customer_id, payment_status, payment_amount_cents, payment_currency, payment_date, created_at, status) VALUES (={{ $json.orderId }}, ={{ $json.email }}, ={{ $json.package }}, ={{ $json.sessionId }}, ={{ $json.payment_intent }}, ={{ $json.customer }}, 'succeeded', ={{ $json.amount_total }}, ={{ $json.currency }}, NOW(), NOW(), 'pending') ON CONFLICT (id) DO UPDATE SET email = EXCLUDED.email, stripe_session_id = EXCLUDED.stripe_session_id, stripe_payment_intent_id = EXCLUDED.stripe_payment_intent_id, stripe_customer_id = EXCLUDED.stripe_customer_id, payment_status = EXCLUDED.payment_status, payment_amount_cents = EXCLUDED.payment_amount_cents, payment_currency = EXCLUDED.payment_currency, payment_date = EXCLUDED.payment_date, updated_at = NOW()"
    }
  }
}
```

### Option B: Retrieve Payment Intent from Stripe API

If the webhook payload only includes `session_id`, add a Stripe API call:

1. Add HTTP Request node after "Build ctx"
2. Call Stripe API: `GET https://api.stripe.com/v1/checkout/sessions/{session_id}?expand[]=payment_intent`
3. Extract `payment_intent.id` from response
4. Pass to Upsert Order

This is more complex but ensures payment data is always captured.

## Verification Steps

After updating the workflow:

1. Create a test order through Stripe Checkout
2. Verify `stripe_payment_intent_id` is populated in the `orders` table
3. Verify `payment_status` is set correctly
4. Check `audit_log` table captured the INSERT

## Next Steps

1. **Check incoming webhook payload structure** - Determine if `payment_intent` is already included
2. **Update Upsert Order SQL** - Add new payment columns to INSERT/UPDATE
3. **Test with real Stripe checkout** - Verify end-to-end flow
4. **Validate via MCP** - Run `n8n_validate_workflow` after changes

## Note on Implementation

This document outlines the approach. The actual SQL in the `Upsert Order` node needs to be reviewed to construct the correct MCP update operation with the exact current SQL structure + new columns.

To get the current SQL, use:
```
n8n_get_workflow(id="40hfyY9Px6peWs3wWFkEY", mode="full")
```
Then search for the "Upsert Order" node's `parameters.query` value.
