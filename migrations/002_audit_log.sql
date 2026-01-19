-- Migration 002: Audit Log Table for Compliance
-- Run this in Supabase SQL Editor: https://supabase.com/dashboard/project/xidmgkcqltvknvtuoeoh/sql
-- Created: 2026-01-18

-- =============================================================================
-- PHASE 2: Create Audit Log Table
-- =============================================================================

CREATE TABLE IF NOT EXISTS public.audit_log (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    table_name VARCHAR(100) NOT NULL,
    record_id UUID,
    action VARCHAR(20) NOT NULL CHECK (action IN ('INSERT', 'UPDATE', 'DELETE')),
    old_values JSONB,
    new_values JSONB,
    changed_fields TEXT[],
    user_id VARCHAR(255),
    ip_address INET,
    user_agent TEXT,
    workflow_id VARCHAR(255),
    occurred_at TIMESTAMPTZ DEFAULT NOW()
);

-- Add indexes for common query patterns
CREATE INDEX IF NOT EXISTS idx_audit_log_table ON public.audit_log(table_name);
CREATE INDEX IF NOT EXISTS idx_audit_log_record ON public.audit_log(record_id);
CREATE INDEX IF NOT EXISTS idx_audit_log_occurred ON public.audit_log(occurred_at);
CREATE INDEX IF NOT EXISTS idx_audit_log_action ON public.audit_log(action);

-- Composite index for table+time queries (common for compliance reports)
CREATE INDEX IF NOT EXISTS idx_audit_log_table_time ON public.audit_log(table_name, occurred_at DESC);

-- Enable RLS on audit_log (matches other tables)
ALTER TABLE public.audit_log ENABLE ROW LEVEL SECURITY;

-- Policy: Only service role can write to audit log (n8n uses service role)
CREATE POLICY IF NOT EXISTS "Service role can insert audit logs"
    ON public.audit_log
    FOR INSERT
    TO service_role
    WITH CHECK (true);

-- Policy: Only service role can read audit logs
CREATE POLICY IF NOT EXISTS "Service role can read audit logs"
    ON public.audit_log
    FOR SELECT
    TO service_role
    USING (true);

-- Add table comment
COMMENT ON TABLE public.audit_log IS 'Tracks changes to sensitive data for compliance and debugging';

-- Verify table was created
SELECT
    c.column_name,
    c.data_type,
    c.column_default,
    c.is_nullable
FROM information_schema.columns c
WHERE c.table_schema = 'public'
  AND c.table_name = 'audit_log'
ORDER BY c.ordinal_position;
