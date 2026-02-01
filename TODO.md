# Ai-Vitae TODO List

## ⚠️ CRITICAL: Workflow Source of Truth

**NEVER use local JSON workflow files - they are OUTDATED.**
- The **ONLY** valid workflow is the live n8n workflow via MCP connection
- **ALL** workflow reads: `n8n_get_workflow(id="40hfyY9Px6peWs3wWFkEY", mode="structure")`
- **ALL** workflow changes: `n8n_update_partial_workflow(id="40hfyY9Px6peWs3wWFkEY", operations=[...])`
- Local `.json` files are snapshots for reference only - DO NOT modify or rely on them

---

## Quick Start for New Sessions

**Workflow ID:** `40hfyY9Px6peWs3wWFkEY`
**Repositories:**
- Backend: https://github.com/TinyReset/Ai-Vitae-Backend
- Frontend: https://github.com/TinyReset/CVBuidler
**Current Status:** Batch 16 COMPLETE, Batch 17 PLANNED (524 fix — ready to implement)
**Nodes:** 145

### Current State
- **Database:** Payment tracking & audit logging active
- **Main Workflow:** Response time ~10ms (optimized), multiple nodes disabled
- **Frontend:** Fixed and deployed
- **Supporting Workflows:** All validated and production-ready
- **Supabase Storage:** Configured with credentials (xidmgkcqltvknvtuoeoh.supabase.co)
- **CV PDF Document:** ✅ Rewritten CV text flows to Google Docs via Stash Context + $node reference (Batch 16)
- **Cover Letter Document:** ✅ Included cover letters create PDF, upload to S3, merge into response (Batch 15)
- **Email Delivery:** ✅ "If Email Sent Ok" fixed — routes to Mark Sent, status updated to "sent" (Batch 16)
- **All 4 Tiers:** ✅ PASSED (Starter #2842, Standard #2835, Premium #2827, Executive #2837)
- **524 Cloudflare Timeout:** Plan approved — two-workflow split (see PLAN.md Batch 17)

### What's Next
1. ~~TEST ALL 4 TIERS~~ ✅ ALL PASSED
2. ~~FIX EMAIL DELIVERY~~ ✅ FIXED
3. **BATCH 17: 524 CLOUDFLARE TIMEOUT FIX** — Plan approved, ready to implement
   - Create new intake workflow (~6 nodes) at `/careeredge/submit`
   - Modify existing workflow: webhook path → `/careeredge/process`, responseMode → `"onReceived"`
   - Disable Respond 202 + Ack Payload in existing workflow
   - Test: expect 202 in <1s (not 524)
4. **ADDON TESTING** - Extra Cover Letter, LinkedIn Optimization, Editable Word, One Day Delivery
5. **FUTURE:** Re-enable Rate Limiter & Idempotency Check after Respond 202
6. **FUTURE:** Investigate frontend confirmation page slowness (not n8n - webhook responds in ~10ms)

### Key Commands
```
# Check recent executions
n8n_executions(action="list", workflowId="40hfyY9Px6peWs3wWFkEY", limit=5)

# Check execution errors
n8n_executions(action="get", id="EXECUTION_ID", mode="error")

# Get workflow structure
n8n_get_workflow(id="40hfyY9Px6peWs3wWFkEY", mode="structure")

# Apply partial updates
n8n_update_partial_workflow(id="40hfyY9Px6peWs3wWFkEY", operations=[...])
```

---

## Last Session: 2026-02-01 (Session 10)

### Session Summary (524 Timeout Plan Designed)
Designed the two-workflow split plan to fix the 524 Cloudflare timeout. Investigated the webhook response flow — confirmed that n8n Cloud's gateway holds the HTTP connection until execution completes, ignoring the Respond to Webhook node mid-execution. Evaluated three approaches (onReceived, two-workflow split, hybrid polling). Selected two-workflow split because it preserves all validation error responses. Plan approved, ready to implement in next session.

**Completed This Session:**
- [x] Investigated 524 root cause: n8n Cloud gateway holds connection until execution completes
- [x] Designed two-workflow split architecture (intake + processing)
- [x] Plan approved — see PLAN.md Batch 17 for full details
- [x] Updated PLAN.md and TODO.md for next session

**Still Pending:**
- [ ] **Batch 17: Implement 524 fix** — create intake workflow, modify existing workflow
- [ ] Addon testing (Extra Cover Letter, LinkedIn, Editable Word, One Day Delivery)
- [ ] Investigate frontend confirmation page slowness (not n8n — webhook responds in ~10ms)

### Previous Session: 2026-02-01 (Session 9)

**Batch 16 COMPLETE — ALL 4 Tiers PASSED:**
- [x] Executive tier PASSED — execution #2837 (91 nodes, 195s, zero fixes needed)
- [x] Starter tier PASSED — execution #2842 (91 nodes, 148s, required Capture Rewrite Responses API fix)
- [x] Standard tier PASSED — execution #2835 (103 nodes, 148s, CV + CL + Email)
- [x] Email Delivery "If Email Sent Ok" fixed — execution #2836, Mark Sent status="sent"
- [x] 11 total fixes across Batch 16 (8 main + 3 email delivery)

### Latest Test Results
| Execution | Tier | Status | Notes |
|-----------|------|--------|-------|
| **2843** | **Email** | **SUCCESS** | **Starter email delivery ✅** |
| **2842** | **Starter** | **SUCCESS** | **CV only, no cover letter (correct), email delivered. 91 nodes, 148s** |
| 2841 | Starter | CRASHED | n8n cloud crash (0 nodes executed, platform issue) |
| 2839 | Starter | PARTIAL | Capture Rewrite cvRewriteText empty (old Chat Completions format) |
| **2838** | **Email** | **SUCCESS** | **Executive email delivery ✅** |
| **2837** | **Executive** | **SUCCESS** | **4-step AI chain, cover letter, email delivered. 91 nodes, 195s** |
| **2836** | **Email** | **SUCCESS** | **First successful email delivery — Mark Sent (status: "sent")** |
| **2835** | **Standard** | **SUCCESS** | **CV PDF populated, cover letter, email delivered. 103 nodes, 148s** |
| 2833 | Standard | PARTIAL | CV rewrite OK but PDF empty (Stash Context didn't carry cvRewriteText) |
| 2831 | Standard | PARTIAL | Pipeline OK but Rewrite CV1 = 7 tokens (Responses API bug) |
| 2830 | Standard | ERROR | Package empty after Build ctx fix (ctx string not parsed) |
| 2829 | Standard | ERROR | Package empty at Switch → catch-all fallback |
| **2827** | **Premium** | **SUCCESS** | **CV + Cover Letter + Email. 104 nodes, 167s** |

---

## Batch 15: Premium Pipeline E2E Testing & Cover Letter Document Fix [COMPLETE]

**Session:** 2026-01-30
**Status:** 11 operations applied (10 main + 1 email delivery), 7 test iterations

### Root Cause
Cover letter text was generated by Cover Letter Rewrite1 (Premium tier) but never turned into a document. The "Extra Cover Letter" addon path was the ONLY path that created a cover letter PDF — included cover letters were silently dropped. Data was lost at multiple points through the pipeline: Stash Context didn't carry `coverLetterText`, Normalize Payload couldn't find it, Google Docs pipeline stripped all context, and Reattach Context1 had no `joinKey` for Merge by Key.

### Fixes Applied (11 nodes)
| # | Node | ID | Fix |
|---|------|----|-----|
| 1 | Capture Rewrite1 | `dd8975e5` | Added `coverLetterText` extraction (OpenAI format) |
| 2 | Capture Rewrite2 | `f05556f7` | Added `coverLetterText` extraction (Anthropic format) |
| 3 | Capture Rewrite3 | `fb682146` | Added `coverLetterText` extraction (Anthropic format) |
| 4 | Stash Context | `a2bbc558` | Added `coverLetterText` to ctx object |
| 5 | Normalize Payload | `e9e01295` | Added `$node['Capture Rewrite1/2/3']` fallbacks for coverLetterText |
| 6 | Write Cover Letter Content | `25c0ee39` | Try-catch around `$items('Cover Letter - Generate')` |
| 7 | Capture Cover Letter | `eb5dcfaa` | Added orderId/docRow fallbacks for joinKey |
| 8 | Upload CoverLetter1 | `09321213` | Added `$node['Capture Cover Letter']` for S3 key |
| 9 | Reattach Context2 | `aebbdf44` | Added `$node['Capture Cover Letter']` for joinKey/orderId |
| 10 | Reattach Context1 | `f4e185bd` | Added joinKey derivation for Merge by Key |
| 11 | Reattach Email Meta (Email WF) | `85369918` | Pull binary by `$node` name instead of `$input` |

### Known Issue — FIXED in Batch 16
- ~~**Email Delivery "If Email Sent Ok"**: Routes to FALSE despite Gmail success~~ → FIXED (Batch 16, execution #2836)

---

## Batch 14c: Shape Documents Map Fix [COMPLETE]

**Session:** 2026-01-29
**Status:** 1 operation applied

### Root Cause (from execution #2812)
Shape Documents Map code only handled `$json.docs[]` array input, but:
- **List Documents for Order** (Postgres) returns separate items with `{kind, storage_key}` — not an array
- **No-addon orders** bypass List Documents entirely (Validate - Has Schema and OrderId fails because no `schema` field exists for non-addon paths), passing `docRow` object instead
- **Supabase URL** used placeholder `<YOUR-PROJECT-REF>` instead of real URL

### Fix Applied
| Node | ID | Fix |
|------|----|-----|
| Shape Documents Map | `ae58cc77` | Rewrote to handle 4 input formats: (1) `$input.all()` multi-item with `{kind, storage_key}`, (2) `$json.docs[]` array, (3) `$json.docRow` with kind inference from storage_key, (4) flat key fields. Fixed Supabase URL to `xidmgkcqltvknvtuoeoh.supabase.co` |

---

## Batch 14b: Execution #2812 Post-Test Fixes [COMPLETE]

**Session:** 2026-01-28
**Status:** 3 operations applied

### Root Cause Analysis (from execution #2812)
Premium test after Batch 14 failed with `null subject` SQL error. Three issues:
1. **Proofread CV** still 7 input tokens — OpenAI node v2.1 defaults `resource: "text"` which uses `responses` property, NOT `messages`. Batch 14's `messages.values` fix was ignored entirely.
2. **Execute a SQL query** — `email_jobs.subject` is NOT NULL. Assemble Response doesn't produce `subject`/`body_html`. `NULLIF('','')` → NULL → constraint violation.
3. **Frontend 524 timeout** — Cloudflare timeout between Vercel and n8n cloud (transient, not fixable in n8n).

### Fixes Applied (3 operations)
| # | Node | ID | Fix |
|---|------|----|-----|
| 1 | Starter - Proofread CV | `35bf08e4` | Set `resource: "text"`, `operation: "response"`, `responses.values` with system+user, `.first().json` |
| 2 | Standard - Proofread CV | `df4bf557` | Same Responses API format fix |
| 3 | Execute a SQL query | `31ce791b` | Added subject fallback (`'Your Premium CV Package is Ready'`), body_html construction, payload with all available fields |

### Key Discovery: OpenAI Node v2.1 Dual Format
- `messages` property → shown when `resource: "conversation"`, `operation: "create"` (Chat Completions API)
- `responses` property → shown when `resource: "text"`, `operation: "response"` (Responses API, **DEFAULT**)
- Default resource is `"text"`, so nodes without explicit resource setting use Responses API
- `responses.values` requires: `type` (text/image/file), `role` (user/system/assistant), `content`

---

## Batch 14: Execution #2811 Analysis & Fixes [COMPLETE]

**Session:** 2026-01-27
**Status:** All 5 fixes applied and verified

### Root Cause Analysis (from execution #2811)
Premium test order succeeded (91 nodes executed) but pipeline was incomplete:
1. **Proofread CV nodes** used single OpenAI message (7 input tokens = empty prompt). OpenAI node requires system + user message split.
2. **cvRewriteText (final)** had `=={{` (double `=`) prepending literal `=` to output, plus an empty assignment.
3. **Assemble Response** was a terminal node — no connection to Execute a SQL query → Trigger Email Workflow.
4. **Assemble Response fields** referenced `$json.*` but input from SQL query only had DB columns, not context fields.

### Fixes Applied (5 operations, atomic)
| # | Node | ID | Fix |
|---|------|----|-----|
| 1 | Starter - Proofread CV | `35bf08e4` | Split to system msg (static) + user msg (dynamic with `=` prefix) |
| 2 | Standard - Proofread CV | `df4bf557` | Split to system msg (static) + user msg (dynamic with `=` prefix) |
| 3 | cvRewriteText (final) | `021894d0` | `=={{` → `={{`, removed empty `name:"",value:""` assignment |
| 4 | Connection | — | Added: Assemble Response → Execute a SQL query |
| 5 | Assemble Response | `f798ff3f` | Fixed `orderId ` trailing space, changed refs to `$('Context (carry)').first().json.*` and `$('Shape Documents Map').first().json.*` |

### What Batch 13 Fixed (confirmed working in #2811 and #2812)
- Cover Letter Rewrite1: ✅ 876 input tokens, real cover letter generated
- Premium CV Rewrite: ✅ 715 input tokens, full professional CV
- Capture Rewrite2 joinKey + ctx: ✅ All fields populated correctly
- Assemble Response context fields: ✅ orderId, package, candidateName, email all populated (#2812)

### Issue (Deferred): Frontend confirmation page slowness
Webhook responds in ~10ms with 202. Confirmation page slowness is a frontend issue (Next.js on Vercel), not n8n. Deferred to separate investigation.

---

## Batch 13: AI Prompt & Capture Node Fixes [COMPLETE]

**Session:** 2026-01-27
**Status:** All 10 fixes applied and verified

### Root Cause
All Cover Letter Rewrite, Proofread CV, and Format CV Layout nodes had **static prompts** with no `=` prefix and no `{{ }}` expressions. AI received vague instructions but no CV text, job description, or candidate name. Capture Rewrite nodes used `$json.*` which couldn't find data from Anthropic/OpenAI output formats.

### Fixes Applied (10 operations)
| # | Node | Fix |
|---|------|-----|
| 1 | Cover Letter Rewrite1 (Premium) | Dynamic prompt: `=` prefix + `{{ }}` with Context (carry) + Premium CV Rewrite refs |
| 2 | Cover Letter Rewrite (Standard) | Dynamic prompt with Context (carry) + Rewrite CV1 refs |
| 3 | Cover Letter Rewrite2 (Executive) | Dynamic prompt with Context (carry) + Executive CV Rewrite refs |
| 4 | Starter - Proofread CV | Dynamic prompt referencing Premium CV Rewrite (Anthropic format) |
| 5 | Standard - Proofread CV | Dynamic prompt referencing Executive CV Rewrite (Anthropic format) |
| 6 | Capture Rewrite1 | joinKey/cvRewriteText/ctx from upstream nodes, not $json |
| 7 | Capture Rewrite2 | Multi-format extraction (Anthropic + OpenAI Responses API) |
| 8 | Capture Rewrite3 | Multi-format extraction (Anthropic + OpenAI) |
| 9 | Merge by Key | Added `onError: continueRegularOutput` |
| 10 | Executive - Format CV Layout | Dynamic prompt referencing Standard - Proofread CV |

---

## Batch 12: Cover Letter Node Reconnection [COMPLETE]

**Session:** 2026-01-27
**Status:** All fixes applied and verified

### Fix Applied
Used `rewireConnection` to redirect CV Rewrite `main` outputs through Cover Letter Rewrite nodes.

### Verified Flows (from live workflow data)
| Tier | Flow | Cover Letter? |
|------|------|---------------|
| Starter | Rewrite CV → Capture Rewrite | ✅ No (correct) |
| Standard | Rewrite CV1 → **Cover Letter Rewrite** → Capture Rewrite1 | ✅ YES |
| Premium | Premium CV Rewrite → **Cover Letter Rewrite1** → Proofread → Capture Rewrite2 | ✅ YES |
| Executive | Executive CV Rewrite → **Cover Letter Rewrite2** → Proofread → Format → Capture Rewrite3 | ✅ YES |

### Node IDs (for reference)
| Node | ID |
|------|-----|
| Rewrite CV1 | `3cbc6655-1120-4b7b-92ec-a57729ebe2b1` |
| Premium - CV Rewrite (Claude Sonnet) | `aaf4fa34-eb8b-489f-a23e-c3f969957ecc` |
| Executive - CV Rewrite (Claude Opus) | `2245d030-1b11-4588-aa11-91690c394642` |
| Cover Letter Rewrite | `b6a6f5f5-f488-4c54-b399-6365b8a05496` |
| Cover Letter Rewrite1 | `dde6a403-d7f1-41c9-9d5d-7addb8cd299b` |
| Cover Letter Rewrite2 | `f115fc99-e1ea-452e-9ecc-ef09fdbee5d6` |
| Capture Rewrite1 | `dd8975e5-6935-41d2-8254-cddb252ae5b9` |
| Capture Rewrite2 | `f05556f7-e910-4f24-87d4-452b31ebb3d1` |
| Capture Rewrite3 | `fb682146-be44-49b9-b491-90ae5eecd58d` |

---

## Batch 11: Supabase Storage & Data Flow Fixes [COMPLETE]

**Session:** 2026-01-26
**Status:** All fixes applied and verified

### Issues Fixed

**1. orderId Lost After Extract from File [FIXED]**
- **Root Cause:** Extract from File nodes extract text but don't preserve ctx object
- **Symptom:** `null value in column "order_id" of relation "documents" violates not-null constraint`
- **Nodes Fixed:**
  - **joinKey1** (ID: `5d66af5a-b825-429e-8223-e1841764767b`) - Now references `$('Stash Metadata').item.json.ctx`
  - **Stash Context** (ID: `a2bbc558-8da5-440c-a7b3-035e3c7dd1c0`) - Now references `$('Context (carry)').item.json`

**2. Supabase Storage Not Configured [FIXED]**
- **Node ID:** `31a26c23-1239-428e-8b61-3990b2ae0893` (Set - Config)
- **Problem:** Missing Supabase URL and service role key
- **Fix:** Added credentials:
  - `_cfg.supabaseUrl`: `xidmgkcqltvknvtuoeoh.supabase.co`
  - `_cfg.supabaseKey`: Service role key (JWT)

**3. HTTP Request _cfg Access [FIXED]**
- **Node ID:** `154aace9-5adf-4929-8e59-0013e9e4a00b`
- **Problem:** Node couldn't access `_cfg` because Collapse To One1 didn't pass it through
- **Fix:** Updated to reference `$('Context (carry)').item.json._cfg` directly

### Previously Fixed (Batch 10)

**4. Build ctx Node Empty [FIXED]**
- **Node ID:** `e88c0ab6-3eb3-4bf2-8057-90e14d845d60`
- **Fix:** Added field mappings referencing `$('Webhook Intake')` directly

**5. Idempotency Check Too Slow [FIXED]**
- **Node ID:** `b7dad4ba-70b5-45fa-8f0f-14f6d82f66df`
- **Fix:** DISABLED node (was taking 2.2s before Respond 202)

**6. Binary Data Lost [FIXED]**
- **Node ID:** `1ccdd0ad-4dec-4ebb-80fa-78053239995e` (Stash Metadata)
- **Fix:** Converted to Code node that retrieves binary from Webhook Intake

**7. Set - Config $env Access [FIXED]**
- **Node ID:** `31a26c23-1239-428e-8b61-3990b2ae0893`
- **Fix:** Replaced `$env.*` with hardcoded values

**8. Duplicate Error Handler [FIXED]**
- **Node ID:** `0d11e236-af2b-4175-9285-9963c4a43ee5`
- **Fix:** DISABLED node

---

## Currently Disabled Nodes

| Node | Node ID | Reason | Re-enable? |
|------|---------|--------|------------|
| Rate Limiter | `b0f341bb-668e-4fcc-9dfe-5b9825cd7918` | 2.2s delay before response | Move after Respond 202 |
| Idempotency Check | `b7dad4ba-70b5-45fa-8f0f-14f6d82f66df` | 2.2s delay before response | Move after Respond 202 |
| Error Handler | `0d11e236-af2b-4175-9285-9963c4a43ee5` | Duplicates separate workflow | Remove entirely |

---

## Status Legend
- [ ] Not started
- [~] In progress
- [x] Complete
- [!] Blocked

---

## Previous Batches [ALL COMPLETE]

### Batch 1-9 Summary
All previous batches complete. See PLAN.md for details.

Key achievements:
- Workflow optimized (15 nodes removed)
- Response time reduced from 2.3s+ to ~10ms
- Payment tracking implemented
- Binary data preservation fixed
- Frontend fixes deployed

---

## Pre-Deployment Checklist (Main Workflow)

### Package Tier Tests
| Tier | Price | Includes | Test Status |
|------|-------|----------|-------------|
| Starter | €4.99 | CV rewrite only | [x] PASSED - execution #2842 (91 nodes, 148s) |
| Standard | €7.99 | CV + Cover Letter | [x] PASSED - execution #2835 (103 nodes, 148s) |
| Premium | €14.99 | CV + Cover Letter (Claude Sonnet) | [x] PASSED - execution #2827 (104 nodes, 167s) |
| Executive | €24.99 | CV + Cover Letter + Layout + Priority | [x] PASSED - execution #2837 (91 nodes, 195s) |

- [x] Starter - Upload TXT, verify GPT-4o-mini rewrite, NO cover letter (**PASSED** #2842)
- [x] Standard - Upload TXT, verify GPT-4o-mini rewrite + cover letter + email (**PASSED** #2835)
- [x] Premium - Upload TXT, verify Claude Sonnet rewrite + cover letter + email (**PASSED** #2827)
- [x] Executive - Upload TXT, verify Claude Opus rewrite + cover letter + layout (**PASSED** #2837)
- [ ] Invalid Tier - Send "deluxe", verify 400 error

### Addon Tests (EXTRA, on top of package)
- [ ] Extra Cover Letter - Verify additional cover letter PDF generated
- [ ] LinkedIn Optimization - Verify profile text generated
- [ ] Editable Word - Verify HTML → DOCX conversion
- [~] One Day Delivery - Flag inconsistency found (string vs boolean)
- [ ] All Addons Combined - Test with all 4 enabled
- [ ] No Addons - Verify workflow completes

### Integration Tests
- [x] Email Delivery - Gmail sends with attachment, Mark Sent updates status to "sent" (verified #2836, false negative FIXED)
- [x] Database Records - email_jobs id 68 created and marked "sent" (verified #2835/#2836)
- [x] Supabase Uploads - Files uploaded correctly (verified #2809)
- [x] S3 Upload - Cover letter PDF at `orders/{orderId}/cover_letter.pdf` (verified #2827)
- [ ] Google Sheets - Verify row appended

---

## Notes

### n8n Cloud Limitations
- **$env.* access blocked** - Must use hardcoded values or credentials
- **Execution limits** - Varies by plan, check for concurrent execution limits
- **503 errors** - Usually temporary, retry after a few minutes

### Key Technical Details
- **Webhook response time:** ~10ms (after disabling slow nodes)
- **Full order processing:** ~60 seconds
- **Binary data:** Must be explicitly passed from Webhook Intake to downstream nodes
- **Respond to Webhook nodes:** Do NOT pass binary data downstream

### Files Reference
| File | Purpose |
|------|---------|
| `PLAN.md` | Project context, architecture, history |
| `TODO.md` | This file - task tracking |

---

**Last Updated:** 2026-02-01
**Status:** Batch 16 COMPLETE, Batch 17 PLANNED (524 Cloudflare timeout fix — two-workflow split)
**Next Action:** Implement Batch 17 (524 fix), then addon testing
