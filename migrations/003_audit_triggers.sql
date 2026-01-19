-- Migration 003: Audit Triggers for Sensitive Tables
-- Run this in Supabase SQL Editor: https://supabase.com/dashboard/project/xidmgkcqltvknvtuoeoh/sql
-- Created: 2026-01-18

-- =============================================================================
-- PHASE 3: Create Trigger Function for Audit Logging
-- =============================================================================

CREATE OR REPLACE FUNCTION public.audit_trigger_function()
RETURNS TRIGGER AS $$
DECLARE
    old_data JSONB;
    new_data JSONB;
    changed TEXT[];
    key TEXT;
BEGIN
    -- Build old/new data based on operation type
    IF TG_OP = 'DELETE' THEN
        old_data := to_jsonb(OLD);
        new_data := NULL;
    ELSIF TG_OP = 'INSERT' THEN
        old_data := NULL;
        new_data := to_jsonb(NEW);
    ELSIF TG_OP = 'UPDATE' THEN
        old_data := to_jsonb(OLD);
        new_data := to_jsonb(NEW);

        -- Calculate which fields changed
        FOR key IN SELECT jsonb_object_keys(new_data)
        LOOP
            IF old_data->key IS DISTINCT FROM new_data->key THEN
                changed := array_append(changed, key);
            END IF;
        END LOOP;
    END IF;

    -- Insert audit record
    INSERT INTO public.audit_log (
        table_name,
        record_id,
        action,
        old_values,
        new_values,
        changed_fields,
        occurred_at
    ) VALUES (
        TG_TABLE_NAME,
        COALESCE(NEW.id, OLD.id),
        TG_OP,
        old_data,
        new_data,
        changed,
        NOW()
    );

    -- Return appropriate record
    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =============================================================================
-- PHASE 4: Add Triggers to Sensitive Tables
-- =============================================================================

-- Audit trigger for orders table (contains payment info, PII)
DROP TRIGGER IF EXISTS audit_orders_trigger ON public.orders;
CREATE TRIGGER audit_orders_trigger
    AFTER INSERT OR UPDATE OR DELETE ON public.orders
    FOR EACH ROW
    EXECUTE FUNCTION public.audit_trigger_function();

-- Audit trigger for customer_data table (contains PII)
DROP TRIGGER IF EXISTS audit_customer_data_trigger ON public.customer_data;
CREATE TRIGGER audit_customer_data_trigger
    AFTER INSERT OR UPDATE OR DELETE ON public.customer_data
    FOR EACH ROW
    EXECUTE FUNCTION public.audit_trigger_function();

-- =============================================================================
-- PHASE 5: Prevent Accidental Deletion of Payment Records
-- =============================================================================

CREATE OR REPLACE FUNCTION public.prevent_payment_record_deletion()
RETURNS TRIGGER AS $$
BEGIN
    -- Block deletion if payment has been processed
    IF OLD.payment_status IN ('succeeded', 'refunded', 'partially_refunded') THEN
        RAISE EXCEPTION 'Cannot delete order with processed payment (status: %). Archive instead.', OLD.payment_status;
    END IF;

    -- Block deletion if Stripe identifiers exist
    IF OLD.stripe_payment_intent_id IS NOT NULL OR OLD.stripe_charge_id IS NOT NULL THEN
        RAISE EXCEPTION 'Cannot delete order with Stripe payment record. Archive instead.';
    END IF;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- Add protection trigger
DROP TRIGGER IF EXISTS protect_payment_records ON public.orders;
CREATE TRIGGER protect_payment_records
    BEFORE DELETE ON public.orders
    FOR EACH ROW
    EXECUTE FUNCTION public.prevent_payment_record_deletion();

-- =============================================================================
-- VERIFICATION
-- =============================================================================

-- List all triggers on orders and customer_data
SELECT
    event_object_table AS table_name,
    trigger_name,
    event_manipulation AS trigger_event,
    action_timing AS timing
FROM information_schema.triggers
WHERE event_object_schema = 'public'
  AND event_object_table IN ('orders', 'customer_data')
ORDER BY event_object_table, trigger_name;
