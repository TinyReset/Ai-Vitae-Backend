-- Migration 001: Payment Tracking Fields for Refund Support
-- Run this in Supabase SQL Editor: https://supabase.com/dashboard/project/xidmgkcqltvknvtuoeoh/sql
-- Created: 2026-01-18

-- =============================================================================
-- PHASE 1: Add Payment Tracking Columns to Orders Table
-- =============================================================================

-- Stripe payment identifiers (needed for refunds)
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS stripe_payment_intent_id VARCHAR(255);
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS stripe_charge_id VARCHAR(255);
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS stripe_customer_id VARCHAR(255);

-- Payment status tracking
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS payment_status VARCHAR(50) DEFAULT 'pending';
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS payment_amount_cents INTEGER;
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS payment_currency VARCHAR(3) DEFAULT 'USD';
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS payment_date TIMESTAMPTZ;

-- Refund tracking
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS refund_id VARCHAR(255);
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS refund_date TIMESTAMPTZ;
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS refund_reason TEXT;

-- Add indexes for payment lookups
CREATE INDEX IF NOT EXISTS idx_orders_payment_intent ON public.orders(stripe_payment_intent_id);
CREATE INDEX IF NOT EXISTS idx_orders_charge ON public.orders(stripe_charge_id);
CREATE INDEX IF NOT EXISTS idx_orders_payment_status ON public.orders(payment_status);

-- Add comment for documentation
COMMENT ON COLUMN public.orders.stripe_payment_intent_id IS 'Stripe PaymentIntent ID (pi_xxx) - primary identifier for refunds';
COMMENT ON COLUMN public.orders.stripe_charge_id IS 'Stripe Charge ID (ch_xxx) - alternate refund identifier';
COMMENT ON COLUMN public.orders.stripe_customer_id IS 'Stripe Customer ID (cus_xxx) - for customer lookup';
COMMENT ON COLUMN public.orders.payment_status IS 'Payment lifecycle: pending, succeeded, failed, refunded, partially_refunded';
COMMENT ON COLUMN public.orders.refund_id IS 'Stripe Refund ID (re_xxx) when refund processed';

-- Verify columns were added
SELECT column_name, data_type, column_default
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'orders'
  AND column_name LIKE 'stripe_%' OR column_name LIKE 'payment_%' OR column_name LIKE 'refund_%'
ORDER BY ordinal_position;
