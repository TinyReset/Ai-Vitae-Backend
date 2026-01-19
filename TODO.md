# Ai-Vitae TODO List

## Quick Start for New Sessions

**Workflow ID:** `40hfyY9Px6peWs3wWFkEY`
**Current Status:** All batches complete - Ready for production testing
**Nodes:** 144 | **Validation:** 5 errors (false positives), 94 warnings (low-priority)

### Current State
- **Database:** Payment tracking & audit logging active (migrations executed 2026-01-19)
- **Main Workflow:** Updated with payment capture nodes
- **Supporting Workflows:** All validated and production-ready

### What's Next
1. **Production Testing:** Run end-to-end tests (see Pre-Deployment Checklist below)
2. **Optional:** Verify Stripe webhook includes `payment_intent` field

### To Verify Audit Logging
After your next order, run in Supabase SQL Editor:
```sql
SELECT * FROM public.audit_log ORDER BY occurred_at DESC LIMIT 5;
```

### Key Commands
```
# Validate workflow
n8n_validate_workflow(id="40hfyY9Px6peWs3wWFkEY", options={profile: "runtime"})

# Get workflow structure
n8n_get_workflow(id="40hfyY9Px6peWs3wWFkEY", mode="structure")

# Apply partial updates
n8n_update_partial_workflow(id="40hfyY9Px6peWs3wWFkEY", operations=[...])
```

---

## Last Session: 2026-01-19

### Session Summary (Batch 5 - Database Security Audit COMPLETE)
Executed all database migrations and updated workflows for payment tracking.
- [x] Executed `RUN_ALL_MIGRATIONS_FIXED.sql` in Supabase SQL Editor
- [x] Verified 11 new payment columns in `orders` table
- [x] Verified 3 triggers created (audit_orders, audit_customer_data, protect_payment_records)
- [x] Verified `audit_log` table created with RLS
- [x] Main workflow updated with payment capture nodes (now 144 nodes)

---

## Status Legend
- [ ] Not started
- [~] In progress
- [x] Complete
- [!] Blocked

---

## Batch 1: Main Workflow Optimization [COMPLETE]

- [x] Remove AI Orchestrator layer
- [x] Remove email redundancy
- [x] Fix security node positioning
- [x] Consolidate file processing
- [x] Consolidate normalize nodes
- [x] Simplify Google Docs flow
- [x] Enhance tier-specific prompts
- [x] Verify addon logic
- [x] Create validation report
- [x] Generate final workflow JSON

---

## Batch 2: Workflow Validation & Error Fixes (COMPLETE)

### Completed Tasks
- [x] Validate live workflow via MCP connection
- [x] Fix 15 IF nodes missing `onError: 'continueErrorOutput'`
- [x] Identify and document 5 validator false positives
- [x] Reduce warnings from 229 to 214
- [x] Fix optional chaining `?.` warnings (17 nodes fixed)
  - Strategy: Replace `$json.ctx?.field` with `($json.ctx || {}).field`
  - Python script: `fix_chaining.py` for transformation logic
  - Applied via MCP partial updates in two batches (9 Set nodes + 8 other nodes)
  - HTTP Request2 required manual IIFE rewrite for complex expression
- [x] Re-validate workflow after optional chaining fixes
  - Warnings reduced from 189 to 154 (35 fewer warnings)
  - All optional chaining syntax removed from expression nodes

---

## Batch 3: Optional Improvements [COMPLETE]

### TypeVersion Upgrades [COMPLETE]
- [x] Upgrade IF nodes from 2.2 → 2.3 (13 nodes)
- [x] Upgrade OpenAI nodes from 1.8 → 2.1 (6 nodes)
- [x] Upgrade HTTP Request nodes from 4.2 → 4.3 (8 nodes)
- [x] Upgrade RespondToWebhook nodes from 1.4 → 1.5 (6 nodes)
- [x] Upgrade Switch nodes from 3.2 → 3.4 (2 nodes)
- [x] Upgrade Extract from File nodes from 1 → 1.1 (2 nodes)

### Error Handling [COMPLETE]
- [x] Add `onError: continueRegularOutput` to OpenAI nodes (6 nodes)
- [x] Add `onError: continueRegularOutput` to Anthropic nodes (6 nodes)
- [x] Add `retryOnFail: true` to Database nodes (13 nodes)
- [x] Add `onError: continueRegularOutput` to HTTP Request nodes (8 nodes)
- [x] Add `onError: continueRegularOutput` to S3 nodes (4 nodes)
- [x] Add `onError: continueRegularOutput` to Google Sheets/Drive (3 nodes)

### Remaining Low-Priority Tasks
- [ ] Convert expressions to resource locator format (50% confidence warnings)
- [ ] Add outputKey to Switch rules (cosmetic)
- [ ] Consider breaking workflow into sub-workflows

---

## Batch 5: Database Security Audit [COMPLETE]

**Session:** 2026-01-18 → 2026-01-19
**Supabase Project:** `xidmgkcqltvknvtuoeoh`
**Status:** All migrations executed, payment tracking active

### Phase 1: Schema Discovery [COMPLETE]

**Tables Found (5):**
| Table | RLS Enabled | Columns | Purpose |
|-------|-------------|---------|---------|
| `orders` | ✅ Yes | 30 (was 19) | Main order records + payment tracking |
| `documents` | ✅ Yes | 5 | Generated CV/cover letter storage keys |
| `email_jobs` | ✅ Yes | 13 | Email delivery queue |
| `order_addons` | ✅ Yes | 5 | Add-on purchases |
| `customer_data` | ✅ Yes | 13 | Customer contact information |
| `audit_log` | ✅ Yes | 12 | **NEW** - Audit trail for sensitive data |

### Phase 2: Migrations Executed [COMPLETE]

**New Columns in `orders` table (11):**
- `stripe_payment_intent_id`, `stripe_charge_id`, `stripe_customer_id`
- `payment_status`, `payment_amount_cents`, `payment_currency`, `payment_date`
- `refund_id`, `refund_date`, `refund_reason`
- `archived_at`

**New Triggers (3):**
- `audit_orders_trigger` - Logs INSERT/UPDATE/DELETE on orders
- `audit_customer_data_trigger` - Logs INSERT/UPDATE/DELETE on customer_data
- `protect_payment_records` - Prevents deletion of orders with payment data

### Phase 3: Workflow Updates [COMPLETE]

- [x] Data Retention workflow updated via MCP (preserves payment records)
- [x] Main workflow updated via MCP (added payment capture nodes)

### Verification Checklist

- [x] All PII fields identified and documented
- [x] RLS enabled on all tables
- [x] Migration scripts created
- [x] Migrations executed in Supabase
- [x] 11 new columns verified in `orders` table
- [x] 3 triggers verified active
- [x] `audit_log` table created
- [x] Data Retention workflow preserves payment records
- [x] Main workflow captures payment fields

---

## Pre-Deployment Checklist (Main Workflow)

### Package Tier Tests
- [ ] Starter - Upload PDF, verify GPT-4o-mini rewrite
- [ ] Standard - Upload DOCX, verify GPT-4o-mini rewrite
- [ ] Premium - Upload DOC, verify Claude Sonnet rewrite
- [ ] Executive - Upload TXT, verify Claude Opus rewrite
- [ ] Invalid Tier - Send "deluxe", verify 400 error

### Addon Tests
- [ ] Extra Cover Letter - Verify PDF generated and uploaded
- [ ] LinkedIn Optimization - Verify profile text generated
- [ ] Editable Word - Verify HTML → DOCX conversion
- [ ] One Day Delivery - Verify priority flag set
- [ ] All Addons Combined - Test with all 4 enabled
- [ ] No Addons - Verify workflow completes

### Security Tests
- [ ] Rate Limiting - 11 requests in 60s, verify block
- [ ] Duplicate Order - Same orderID twice, verify rejection
- [ ] Malformed Payload - Invalid JSON, verify 400 error
- [ ] Missing Fields - Omit required fields, verify error

### Integration Tests
- [ ] Email Delivery - Verify trigger workflow works
- [ ] Error Handling - Verify Error Handler calls Email Delivery
- [ ] Database Records - Verify tables populated
- [ ] S3 Uploads - Verify files uploaded correctly
- [ ] Google Sheets - Verify row appended

---

## Notes

### Validator False Positives (Ignore These)
| Node | Error | Why It's OK |
|------|-------|-------------|
| Normalise & Validate | "Cannot return primitive" | Returns `[{json, binary}]` array |
| Sanitize JD | "Cannot return primitive" | Returns `[{json, binary}]` array |
| Guard Node1 | "Cannot return primitive" | Uses runOnceForEachItem mode |
| Compute Token Cost | "Cannot return primitive" | Returns `items.map()` array |
| CloudConvert | "Unknown node type" | Community node - works fine |

### Key Technical Details
- **n8n expressions** don't support `?.` optional chaining - use `($json.x || {}).y` instead
- **Code nodes** run in Node.js - they DO support `?.` optional chaining
- **Workflow ID** may change if workflow is deleted/recreated - update PLAN.md and TODO.md
- **MCP connection** required for remote workflow management

### Files Reference
| File | Purpose |
|------|---------|
| `PLAN.md` | Project context, architecture, history |
| `TODO.md` | This file - task tracking |
| `fix_chaining.py` | Python script to fix `?.` in expressions |
| `mcp_fix_operations.json` | MCP operations for optional chaining fixes |

---

## Database Schema Reference (updated 2026-01-19)

### orders (30 columns)
```
-- Original (19)
id, created_at, updated_at, status, package, addons, candidate_name, email,
priority, source, ext_id, has_linkedin, has_extra_cover_letter,
needs_editable_word, is_one_day_delivery, sla_due_at, stripe_session_id,
completed_at, customer_email

-- Payment tracking (11 new)
stripe_payment_intent_id, stripe_charge_id, stripe_customer_id,
payment_status, payment_amount_cents, payment_currency, payment_date,
refund_id, refund_date, refund_reason, archived_at
```

### customer_data (13 columns)
```
id, order_id, full_name, current_position, target_position, work_experience,
skills, cv_file_url, phone, linkedin_url, created_at, updated_at, email
```

### email_jobs (13 columns)
```
id, created_at, order_id, recipient, subject, body_html, payload, status,
attempts, last_error, updated_at, next_attempt_at, last_attempt_at
```

### documents (5 columns)
```
id, order_id, kind, storage_key, created_at
```

### order_addons (5 columns)
```
order_id, code, price_cents, selected, created_at
```

### audit_log (12 columns) - NEW
```
id, table_name, record_id, action, old_values, new_values, changed_fields,
user_id, ip_address, user_agent, workflow_id, occurred_at
```

---

**Last Updated:** 2026-01-19
**Status:** All batches complete - Ready for production testing
**Next Action:** Run end-to-end tests with all package tiers and addons
