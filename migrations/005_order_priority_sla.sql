-- Migration 005: Order Priority & SLA Columns (One-Day Delivery Support)
-- Run this in Supabase SQL Editor: https://supabase.com/dashboard/project/xidmgkcqltvknvtuoeoh/sql
-- Created: 2026-02-16

-- =============================================================================
-- Add priority, SLA, and due_date columns to orders table
-- Used by the "One Day Delivery" addon to flag expedited orders
-- =============================================================================

ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS priority BOOLEAN DEFAULT false;
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS sla VARCHAR(20) DEFAULT 'standard';
ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS due_date TIMESTAMPTZ;

-- Index for querying priority/overdue orders
CREATE INDEX IF NOT EXISTS idx_orders_priority ON public.orders(priority) WHERE priority = true;
CREATE INDEX IF NOT EXISTS idx_orders_due_date ON public.orders(due_date) WHERE due_date IS NOT NULL;

-- Verify
SELECT column_name, data_type, column_default
FROM information_schema.columns
WHERE table_schema = 'public' AND table_name = 'orders'
  AND column_name IN ('priority', 'sla', 'due_date')
ORDER BY column_name;
