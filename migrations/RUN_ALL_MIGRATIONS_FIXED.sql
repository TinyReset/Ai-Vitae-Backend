    -- =============================================================================
    -- MASTER MIGRATION SCRIPT - Run All Database Security Audit Changes (FIXED)
    -- =============================================================================
    -- Project: Ai-Vitae
    -- Created: 2026-01-18
    -- Fixed: Removed non-immutable function from index predicate
    -- Run in: Supabase SQL Editor
    -- URL: https://supabase.com/dashboard/project/xidmgkcqltvknvtuoeoh/sql
    --
    -- IMPORTANT: Run this script in order. Each section depends on the previous.
    -- =============================================================================

    -- =============================================================================
    -- 1. PAYMENT TRACKING COLUMNS (orders table)
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

    -- Archive flag for soft delete
    ALTER TABLE public.orders ADD COLUMN IF NOT EXISTS archived_at TIMESTAMPTZ;

    -- Indexes for payment lookups
    CREATE INDEX IF NOT EXISTS idx_orders_payment_intent ON public.orders(stripe_payment_intent_id);
    CREATE INDEX IF NOT EXISTS idx_orders_charge ON public.orders(stripe_charge_id);
    CREATE INDEX IF NOT EXISTS idx_orders_payment_status ON public.orders(payment_status);
    CREATE INDEX IF NOT EXISTS idx_orders_archived ON public.orders(archived_at) WHERE archived_at IS NOT NULL;

    -- Documentation comments
    COMMENT ON COLUMN public.orders.stripe_payment_intent_id IS 'Stripe PaymentIntent ID (pi_xxx) - primary identifier for refunds';
    COMMENT ON COLUMN public.orders.stripe_charge_id IS 'Stripe Charge ID (ch_xxx) - alternate refund identifier';
    COMMENT ON COLUMN public.orders.stripe_customer_id IS 'Stripe Customer ID (cus_xxx) - for customer lookup';
    COMMENT ON COLUMN public.orders.payment_status IS 'Payment lifecycle: pending, succeeded, failed, refunded, partially_refunded';
    COMMENT ON COLUMN public.orders.refund_id IS 'Stripe Refund ID (re_xxx) when refund processed';

    -- =============================================================================
    -- 2. AUDIT LOG TABLE
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

    -- Indexes (without non-immutable functions)
    CREATE INDEX IF NOT EXISTS idx_audit_log_table ON public.audit_log(table_name);
    CREATE INDEX IF NOT EXISTS idx_audit_log_record ON public.audit_log(record_id);
    CREATE INDEX IF NOT EXISTS idx_audit_log_occurred ON public.audit_log(occurred_at);
    CREATE INDEX IF NOT EXISTS idx_audit_log_action ON public.audit_log(action);
    CREATE INDEX IF NOT EXISTS idx_audit_log_table_time ON public.audit_log(table_name, occurred_at DESC);
    -- Note: Removed partial index with NOW() - use regular index instead
    -- Retention queries will still be efficient with idx_audit_log_occurred

    -- Enable RLS
    ALTER TABLE public.audit_log ENABLE ROW LEVEL SECURITY;

    -- RLS Policies (service role only)
    DO $$
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'audit_log' AND policyname = 'Service role can insert audit logs') THEN
            CREATE POLICY "Service role can insert audit logs" ON public.audit_log FOR INSERT TO service_role WITH CHECK (true);
        END IF;
        IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE tablename = 'audit_log' AND policyname = 'Service role can read audit logs') THEN
            CREATE POLICY "Service role can read audit logs" ON public.audit_log FOR SELECT TO service_role USING (true);
        END IF;
    END $$;

    COMMENT ON TABLE public.audit_log IS 'Tracks changes to sensitive data for compliance and debugging';

    -- =============================================================================
    -- 3. AUDIT TRIGGER FUNCTION
    -- =============================================================================

    CREATE OR REPLACE FUNCTION public.audit_trigger_function()
    RETURNS TRIGGER AS $$
    DECLARE
        old_data JSONB;
        new_data JSONB;
        changed TEXT[];
        key TEXT;
    BEGIN
        IF TG_OP = 'DELETE' THEN
            old_data := to_jsonb(OLD);
            new_data := NULL;
        ELSIF TG_OP = 'INSERT' THEN
            old_data := NULL;
            new_data := to_jsonb(NEW);
        ELSIF TG_OP = 'UPDATE' THEN
            old_data := to_jsonb(OLD);
            new_data := to_jsonb(NEW);
            FOR key IN SELECT jsonb_object_keys(new_data)
            LOOP
                IF old_data->key IS DISTINCT FROM new_data->key THEN
                    changed := array_append(changed, key);
                END IF;
            END LOOP;
        END IF;

        INSERT INTO public.audit_log (table_name, record_id, action, old_values, new_values, changed_fields, occurred_at)
        VALUES (TG_TABLE_NAME, COALESCE(NEW.id, OLD.id), TG_OP, old_data, new_data, changed, NOW());

        IF TG_OP = 'DELETE' THEN RETURN OLD; ELSE RETURN NEW; END IF;
    END;
    $$ LANGUAGE plpgsql SECURITY DEFINER;

    -- =============================================================================
    -- 4. TRIGGERS ON SENSITIVE TABLES
    -- =============================================================================

    -- Orders table audit trigger
    DROP TRIGGER IF EXISTS audit_orders_trigger ON public.orders;
    CREATE TRIGGER audit_orders_trigger
        AFTER INSERT OR UPDATE OR DELETE ON public.orders
        FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_function();

    -- Customer data audit trigger
    DROP TRIGGER IF EXISTS audit_customer_data_trigger ON public.customer_data;
    CREATE TRIGGER audit_customer_data_trigger
        AFTER INSERT OR UPDATE OR DELETE ON public.customer_data
        FOR EACH ROW EXECUTE FUNCTION public.audit_trigger_function();

    -- =============================================================================
    -- 5. PAYMENT RECORD PROTECTION
    -- =============================================================================

    CREATE OR REPLACE FUNCTION public.prevent_payment_record_deletion()
    RETURNS TRIGGER AS $$
    BEGIN
        IF OLD.payment_status IN ('succeeded', 'refunded', 'partially_refunded') THEN
            RAISE EXCEPTION 'Cannot delete order with processed payment (status: %). Archive instead.', OLD.payment_status;
        END IF;
        IF OLD.stripe_payment_intent_id IS NOT NULL OR OLD.stripe_charge_id IS NOT NULL THEN
            RAISE EXCEPTION 'Cannot delete order with Stripe payment record. Archive instead.';
        END IF;
        RETURN OLD;
    END;
    $$ LANGUAGE plpgsql;

    DROP TRIGGER IF EXISTS protect_payment_records ON public.orders;
    CREATE TRIGGER protect_payment_records
        BEFORE DELETE ON public.orders
        FOR EACH ROW EXECUTE FUNCTION public.prevent_payment_record_deletion();

    -- =============================================================================
    -- VERIFICATION
    -- =============================================================================

    -- Show new columns in orders table
    SELECT column_name, data_type, column_default
    FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'orders'
    AND column_name IN ('stripe_payment_intent_id', 'stripe_charge_id', 'stripe_customer_id',
                        'payment_status', 'payment_amount_cents', 'payment_currency', 'payment_date',
                        'refund_id', 'refund_date', 'refund_reason', 'archived_at')
    ORDER BY ordinal_position;

    -- Show triggers
    SELECT event_object_table, trigger_name, event_manipulation, action_timing
    FROM information_schema.triggers
    WHERE event_object_schema = 'public' AND event_object_table IN ('orders', 'customer_data')
    ORDER BY event_object_table, trigger_name;

    -- Show audit_log structure
    SELECT column_name, data_type FROM information_schema.columns
    WHERE table_schema = 'public' AND table_name = 'audit_log'
    ORDER BY ordinal_position;

    SELECT 'Migration complete! Payment tracking, audit logging, and protection triggers are now active.' AS status;
