-- Migration 004: Data Retention Policy Updates
-- Run this in Supabase SQL Editor: https://supabase.com/dashboard/project/xidmgkcqltvknvtuoeoh/sql
-- Created: 2026-01-18

-- =============================================================================
-- NOTE: This migration documents the SQL changes needed in the Data Retention
-- n8n workflow (ID: hYDSPAe1oNN1Sgrs). The actual workflow update is done via MCP.
-- =============================================================================

-- CURRENT retention query (deletes ALL orders older than 90 days):
-- DELETE FROM public.orders WHERE created_at < NOW() - INTERVAL '90 days';

-- NEW retention query (preserves payment records):
-- Use this SQL in the Data Retention Cleaning workflow
/*
DELETE FROM public.orders
WHERE created_at < NOW() - INTERVAL '90 days'
  AND (
    -- Only delete if no payment was processed
    payment_status IS NULL
    OR payment_status = 'pending'
    OR payment_status = 'failed'
  )
  AND stripe_payment_intent_id IS NULL
  AND stripe_charge_id IS NULL;
*/

-- =============================================================================
-- ARCHIVAL APPROACH (Alternative - keeps payment data indefinitely)
-- =============================================================================

-- Add archived flag to orders table
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS archived_at TIMESTAMPTZ;

-- Index for archive queries
CREATE INDEX IF NOT EXISTS idx_orders_archived ON public.orders(archived_at)
WHERE archived_at IS NOT NULL;

-- Instead of DELETE, use UPDATE to archive:
/*
UPDATE public.orders
SET archived_at = NOW()
WHERE created_at < NOW() - INTERVAL '90 days'
  AND archived_at IS NULL;
*/

-- =============================================================================
-- AUDIT LOG RETENTION (Keep 1 year for compliance)
-- =============================================================================

-- This can be run periodically to clean old audit logs (optional)
-- DELETE FROM public.audit_log WHERE occurred_at < NOW() - INTERVAL '365 days';

-- Add index for retention queries
CREATE INDEX IF NOT EXISTS idx_audit_log_retention ON public.audit_log(occurred_at)
WHERE occurred_at < NOW() - INTERVAL '365 days';

-- =============================================================================
-- VERIFICATION QUERIES
-- =============================================================================

-- Count orders by payment status
SELECT
    payment_status,
    COUNT(*) as count,
    MIN(created_at) as oldest,
    MAX(created_at) as newest
FROM public.orders
GROUP BY payment_status
ORDER BY count DESC;

-- Count orders that WOULD be deleted vs preserved
SELECT
    CASE
        WHEN payment_status IN ('succeeded', 'refunded', 'partially_refunded')
            OR stripe_payment_intent_id IS NOT NULL
            OR stripe_charge_id IS NOT NULL
        THEN 'PRESERVED (has payment)'
        ELSE 'DELETABLE (no payment)'
    END as retention_status,
    COUNT(*) as count
FROM public.orders
WHERE created_at < NOW() - INTERVAL '90 days'
GROUP BY 1;
