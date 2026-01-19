# Ai-Vitae TODO List

## Quick Start for New Sessions

**Workflow ID:** `40hfyY9Px6peWs3wWFkEY`
**Current Status:** Batch 5 COMPLETE - Migrations ready for manual execution
**Validation:** 5 errors (false positives), 94 warnings (low-priority)

### ⚠️ ACTION REQUIRED: Run Database Migrations

**Migration scripts are ready.** Execute them in Supabase SQL Editor:

**URL:** https://supabase.com/dashboard/project/xidmgkcqltvknvtuoeoh/sql

**Steps:**
1. Open `migrations/RUN_ALL_MIGRATIONS.sql`
2. Copy contents to Supabase SQL Editor
3. Click "Run"
4. Verify output shows new columns and triggers

### What's Been Done This Session
- [x] Created 5 migration scripts for payment tracking & audit logging
- [x] Updated Data Retention workflow to preserve payment records
- [x] Documented main workflow update requirements

### What's Next (Manual Steps)
1. **Run migrations** in Supabase SQL Editor
2. **Update Stripe webhook** to include `payment_intent` in payload
3. **Update main workflow** - Add payment columns to `Upsert Order` node
   - See: `migrations/005_workflow_payment_logging.md`

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

## Last Session: 2026-01-18

### Session Summary (Batch 5 - Database Security Audit)
Created comprehensive database migration scripts and updated Data Retention workflow.
- Created 5 migration scripts for payment tracking & audit logging
- Updated Data Retention workflow via MCP to preserve payment records
- Documented requirements for main workflow payment logging
- Supabase MCP requires OAuth (manual SQL execution needed)

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

## Batch 3: Optional Improvements [IN PROGRESS]

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

## Batch 5: Database Security Audit [MIGRATIONS READY]

**Session:** 2026-01-18
**Supabase Project:** `xidmgkcqltvknvtuoeoh`
**Status:** Migration scripts created, pending manual execution

### Phase 1: Schema Discovery [COMPLETE]

**Tables Found (5):**
| Table | RLS Enabled | Columns | Purpose |
|-------|-------------|---------|---------|
| `orders` | ✅ Yes | 19 | Main order records |
| `documents` | ✅ Yes | 5 | Generated CV/cover letter storage keys |
| `email_jobs` | ✅ Yes | 13 | Email delivery queue |
| `order_addons` | ✅ Yes | 5 | Add-on purchases |
| `customer_data` | ✅ Yes | 13 | Customer contact information |

### Phase 2: PII Identification [COMPLETE]

**PII Fields Found (7):**
- `orders.email`, `orders.customer_email`, `orders.candidate_name`
- `customer_data.email`, `customer_data.full_name`, `customer_data.phone`
- `email_jobs.recipient`

**Note:** Supabase provides encryption at rest. Column-level encryption is optional.

### Phase 3: Migration Scripts [COMPLETE]

**Files Created:**
| File | Description |
|------|-------------|
| `migrations/001_payment_tracking.sql` | 10 payment columns + indexes |
| `migrations/002_audit_log.sql` | Audit log table with RLS |
| `migrations/003_audit_triggers.sql` | Triggers for orders & customer_data |
| `migrations/004_retention_policy_update.sql` | Retention policy docs |
| `migrations/005_workflow_payment_logging.md` | Workflow update guide |
| `migrations/RUN_ALL_MIGRATIONS.sql` | **Master script - run this** |

### Phase 4: Workflow Updates [COMPLETE]

- [x] Data Retention workflow updated via MCP (preserves payment records)
- [x] Main workflow update documented (requires manual implementation)

### Verification Checklist

- [x] All PII fields identified and documented
- [x] RLS enabled on all tables
- [x] Migration scripts created
- [x] Data Retention workflow preserves payment records
- [ ] **PENDING:** Run migrations in Supabase
- [ ] **PENDING:** Update main workflow `Upsert Order` node

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

## Database Schema Reference (from discovery)

### orders (19 columns)
```
id, created_at, updated_at, status, package, addons, candidate_name, email,
priority, source, ext_id, has_linkedin, has_extra_cover_letter,
needs_editable_word, is_one_day_delivery, sla_due_at, stripe_session_id,
completed_at, customer_email
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

---

**Last Updated:** 2026-01-18
**Status:** Batch 5 COMPLETE - Migrations ready, awaiting manual execution
**Next Action:** Run `migrations/RUN_ALL_MIGRATIONS.sql` in Supabase SQL Editor
