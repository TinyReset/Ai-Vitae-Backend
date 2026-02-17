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
**Current Status:** Session 29 — ALL 4 ADDONS VERIFIED. Editable Word addon replaced CloudConvert with Google Docs API. All tiers + all addons fully operational.
**Main Workflow Nodes:** 147
**Intake Workflow ID:** `I9MS3uIjhD4kNlbP` (5 nodes)
**Email Workflow ID:** `IS4rAklMjfCiQnV5` (22 nodes — restructured with Has LinkedIn? IF + Send CV+CL Gmail + Download Editable DOCX)

### Current State
- **Database:** Payment tracking & audit logging active
- **Main Workflow:** Processing-only worker (responseMode: onReceived), 147 nodes
- **Intake Workflow:** 5-node webhook at `careeredge/submit`, returns 202 in <0.5s
- **Frontend:** Fixed and deployed
- **Supporting Workflows:** All validated and production-ready
- **Supabase Storage:** Configured with credentials (xidmgkcqltvknvtuoeoh.supabase.co)
- **CV PDF Document:** ✅ Rewritten CV text flows to Google Docs via Stash Context + $node reference (Batch 16)
- **Cover Letter Document:** ✅ Cover letters upload to Supabase `cvstore` bucket, email downloads correctly (Batch 21)
- **Cover Letter Email Attachment:** ✅ BOTH CV + Cover Letter PDFs arrive in email (Batch 22, execution #2901)
- **Email Delivery:** ✅ "If Email Sent Ok" fixed — routes to Mark Sent, status updated to "sent" (Batch 16)
- **All 4 Tiers:** ✅ PASSED (Starter #2842/#2929, Standard #2835, Premium #2827, Executive #2837/#2932)
- **CV Formatting:** ✅ FIXED — All AI prompts updated: ALL CAPS headers, no Markdown (Batch 23, 11 nodes)
- **LinkedIn Optimization Addon:** ✅ PASSED — Execution #2938 (99/99 nodes, 249s) + #2951 (111/111 nodes, 247s). Full pipeline through Mark Order Done verified.
- **Data Context Fixes (Session 24):** ✅ FIXED — Restore Context (LinkedIn) + Shape Documents Map cascading fallbacks. orderId now preserved through entire pipeline.
- **Wait + Retry for Email Trigger:** ✅ VERIFIED — 10s Wait node + 3 retries (5s gap). Execution #2955: Trigger Email Workflow succeeded in 189ms (was 503 in #2951). Email #2956 sent with both PDFs attached.
- **524 Cloudflare Timeout:** ✅ FIXED — intake returns 202 in <0.5s, processing runs async (Batch 17)
- **Batch 18 Fixes:** ✅ Package field forwarding, Switch catch-all fallback, S3 path orderId casing, price-to-tier recovery
- **Real Frontend E2E:** ✅ FIRST FULL SUCCESS — Intake #2861 → Processing #2862 → Email #2863 (all SUCCESS)

### What's Next
1. ~~TEST ALL 4 TIERS~~ ✅ ALL PASSED
2. ~~FIX EMAIL DELIVERY~~ ✅ FIXED
3. ~~BATCH 17: 524 CLOUDFLARE TIMEOUT FIX~~ ✅ DEPLOYED
4. ~~BATCH 18: REAL FRONTEND TEST FIXES~~ ✅ APPLIED & VERIFIED
5. ~~RE-TEST REAL ORDER~~ ✅ FIRST FULL E2E SUCCESS (#2861→#2862→#2863)
6. ~~FIX CV PROMPT~~ ✅ FIXED & VERIFIED — Contact info + tools now preserved (execution #2870, quality 8.5/10)
7. ~~FIX COVER LETTER ADDON FLOW~~ ✅ GENERATION WORKING — All 4 main workflow fixes verified (execution #2876)
8. ~~FIX EMAIL WORKFLOW - COVER LETTER ATTACHMENT~~ ✅ FIXED — Replaced AWS S3 with HTTP Request, connections corrected
9. ~~FIX COVER LETTER STORAGE KEY~~ ✅ FIXED — Path corrected (Batch 21)
   - Upload Cover Letter to Supabase: uploads to `cvstore` bucket (only bucket that exists)
   - Postgres - Add Doc(cover)1: storage key is `cvstore/orders/{orderId}/cover_letter.pdf` (includes bucket)
10. ~~TEST EMAIL WITH BOTH ATTACHMENTS~~ ✅ PASSED — Execution #2899→#2900→#2901
   - Starter + extracoverletter addon: CV PDF (48.6KB) + Cover Letter PDF (36.9KB) both attached
   - Gmail thread `19c2f1e5b42538db`, job_id 81 marked "sent"
11. ~~FIX CV FORMATTING~~ ✅ FIXED — All 11 AI prompts updated (Batch 23)
    - ALL CAPS section headers instead of Markdown ** bold
    - Explicit "no Markdown" instructions in all CV rewrite, proofread, format, and cover letter nodes
    - Nodes updated: Rewrite CV, Rewrite CV1, Premium CV Rewrite, Executive CV Rewrite, Starter Proofread, Standard Proofread, Executive Format Layout, Cover Letter Rewrite (x3), Cover Letter Generate
12. ~~TEST CV FORMATTING~~ ✅ PASSED — Starter #2929 + Executive #2932 (Batch 26, ALL CAPS headers confirmed)
13. ~~FIX LINKEDIN OPTIMIZATION ADDON~~ ✅ FIXED — Batch 24 (8 operations applied)
14. ~~FIX AI NODE modelId~~ ✅ FIXED — Batch 26 (12 AI nodes, explicit modelId required by n8n Cloud)
15. ~~FIX FILE TYPE ROUTING~~ ✅ FIXED — Batch 26 (FALSE branch rewired to Extract from File1)
16. ~~TEST LINKEDIN ADDON~~ ✅ PASSED — Execution #2938 (99/99 nodes, 249s, Executive + LinkedIn)
17. ~~FIX DATA CONTEXT LOSS~~ ✅ FIXED — Session 24: Restore Context (LinkedIn) + Shape Documents Map cascading fallbacks
18. ~~FIX EMAIL TRIGGER 503~~ ✅ DEPLOYED — Wait Before Email (10s) + retry (3x, 5s). Pending test.
19. ~~VERIFY EMAIL DELIVERY~~ ✅ VERIFIED — Execution #2954→#2955→#2956. Wait Before Email (10s) → Trigger (189ms, no 503) → Email sent. Gmail thread `19c5313f33850434`. CV (47.3KB) + CL (38.6KB) attached. Mark Sent ✅.
20. ~~LINKEDIN PDF EMAIL ATTACHMENT~~ ✅ FIXED — Session 26: 7 duplicate "0" connections cleaned, email "0"→"main" fixed. Executive+LinkedIn #2958→#2959 PASSED (3 attachments).
21. ~~EMAIL WORKFLOW RESTRUCTURE~~ ✅ COMPLETE — Session 28: Added `Has LinkedIn?` IF + `Send CV+CL` Gmail node. 3 paths: Send CV Only / Send CV+CL / Send Full (CV+CL+LI). All 3 verified.
22. ~~ONE DAY DELIVERY ADDON~~ ✅ PASSED — Session 28: Migration 005 (priority/sla/due_date columns). #2985: `priority=true`, `sla='1-day'`, `due_date=+24h`. DB confirmed.
23. ~~EDITABLE WORD ADDON~~ ✅ PASSED — Session 29: CloudConvert replaced with Google Docs API. Starter+DOCX #2988 (2 attachments) + Executive+All #2991 (4 attachments) both verified.
24. **PRODUCTION HARDENING** ← NEXT — Intermittent n8n Cloud crashes (0 nodes, "Unknown error", ~42s). Requires toggle off/on to recover. Investigate root cause + add resilience.
25. **FUTURE:** Re-enable Rate Limiter & Idempotency Check (in intake workflow)
26. **FUTURE:** Scalability improvements (see PLAN.md "Future: Scalability Plan")
27. **FUTURE:** Split main workflow into sub-workflows for stability (147 nodes is heavy for n8n Cloud)

### Key Commands
```
# Check recent executions (all 3 workflows)
n8n_executions(action="list", workflowId="I9MS3uIjhD4kNlbP", limit=3)   # Intake
n8n_executions(action="list", workflowId="40hfyY9Px6peWs3wWFkEY", limit=3)  # Processing
n8n_executions(action="list", workflowId="IS4rAklMjfCiQnV5", limit=3)   # Email

# Check execution errors
n8n_executions(action="get", id="EXECUTION_ID", mode="error")

# Get workflow structure
n8n_get_workflow(id="40hfyY9Px6peWs3wWFkEY", mode="structure")  # Main
n8n_get_workflow(id="IS4rAklMjfCiQnV5", mode="full")           # Email (small)

# Apply partial updates
n8n_update_partial_workflow(id="40hfyY9Px6peWs3wWFkEY", operations=[...])  # Main
n8n_update_partial_workflow(id="IS4rAklMjfCiQnV5", operations=[...])       # Email
```

---

## Last Session: 2026-02-17 (Session 29)

### Session 29 Summary — Editable Word Addon COMPLETE (CloudConvert → Google Docs API)

#### Problem
CloudConvert community node was disabled since Batch 25 (not installed on n8n Cloud). The Editable Word addon chain (Build HTML → CloudConvert create → CloudConvert download) never successfully executed.

#### Solution
Replaced CloudConvert with Google Docs API (same proven pattern as LinkedIn PDF chain):
- **Main workflow (147 nodes):** Removed 2 CloudConvert nodes, added 4 new nodes (Create CV Doc, Write CV Content, Download CV DOCX, Restore Context DOCX), updated 3 existing nodes
- **Email workflow (22 nodes):** Added Download Editable DOCX node, updated Reattach Email Meta + all 3 Gmail nodes to conditionally attach editableDocx
- Fixed all "0" type connections via direct n8n REST API (MCP addConnection bug)

#### Test Results — Both PASSED
| Test | Executions | Attachments | Gmail |
|------|-----------|-------------|-------|
| Starter + Editable Word | #2987→#2988→#2989 | CV PDF (49.2KB) + DOCX (8.02KB) | `19c6ba810501da88` |
| Executive + LinkedIn + Editable Word + One Day | #2990→#2991→#2992 | CV (48.4KB) + CL (37.7KB) + LinkedIn (47.9KB) + DOCX (8.04KB) | `19c6ca0dcd06539e` |

#### All 4 Addons Now Verified
| Addon | Status | Key Execution |
|-------|--------|---------------|
| Extra Cover Letter | ✅ | #2901 |
| LinkedIn Optimization | ✅ | #2938, #2965, #2992 |
| Editable Word | ✅ | #2989, #2992 |
| One Day Delivery | ✅ | #2985, #2992 |

---

## Previous Session: 2026-02-16 (Session 28)

### Session 28 Summary — Email Restructure + One Day Delivery + All Tiers Verified

#### Email Workflow Restructured (19→21 nodes)
- **Problem:** `Send CV Only` Gmail node crashed on Starter orders because `linkedinPdf` binary didn't exist
- **Fix:** Added `Has LinkedIn?` IF node + `Send CV+CL` Gmail node for 3 conditional paths
- Used `n8n_update_full_workflow` (partial updates unreliable for email workflow)

#### Migration 005: Order Priority & SLA
- Added `priority` (BOOLEAN), `sla` (VARCHAR), `due_date` (TIMESTAMPTZ) to `public.orders`
- First attempt (#2982) failed with "column sla does not exist" — migration fixed it

#### Intermittent n8n Cloud Crashes
- Main workflow crashed 3 times with "Unknown error", 0 nodes (executions #2962, #2968, #2974)
- User discovered MCP access was deactivated for workflows — re-granted access
- Toggle off/on resolves temporarily; root cause is n8n Cloud infrastructure

#### Test Results — All Paths Verified
| Execution | Package | Email Path | Status |
|-----------|---------|------------|--------|
| #2964→#2965 | Executive+LinkedIn | Send Full (CV+CL+LI) | ✅ PASSED |
| #2976→#2977 | Starter | Send CV Only | ✅ PASSED |
| #2979→#2980 | Premium | Send CV+CL | ✅ PASSED |
| #2985→#2986 | Premium+LinkedIn+OneDay | Send Full + DB priority | ✅ PASSED |

---

## Previous Session: 2026-02-12 (Session 24)

### Session 24 Summary — Full Pipeline PASS + Email Trigger Fix

**Test:** Executive + LinkedIn addon from real frontend
**Execution #2951:** 111/111 nodes, 247s, **SUCCESS** — First full pipeline completion for LinkedIn addon

#### Data Context Fixes (3 progressive iterations from prior session + verified this session)

The core issue was data context loss at two points in the pipeline:
1. **Stash Context** only saves 3 fields → `schema` and `linkedinKey` dropped
2. **List Documents for Order** (Postgres) returns only `kind`+`storage_key` → all upstream context (orderId, ctx) lost

**Fix 1: Restore Context (LinkedIn)** — Added `linkedinKey` from `$('Capture LinkedIn')` and `schema` from `$('Context (carry)')`
**Fix 2: Shape Documents Map** — Added cascading upstream reference: `$('One Day Delivery')` → `$('Editable Word')` → `$('Restore Context (LinkedIn)')` + explicit `orderId` and `schema` after spreads

#### Pipeline Results (#2951)
| Node | Status | Result |
|------|--------|--------|
| Restore Context (LinkedIn) | ✅ | orderId, ctx, linkedinKey, schema all restored |
| Validate - Has Schema and OrderId | ✅ TRUE | Was FALSE in #2945 (fixed) |
| List Documents for Order | ✅ | 4 documents found |
| Shape Documents Map | ✅ | orderId NOW PRESENT (was missing in #2947, #2949) |
| Validate - Has OrderId | ✅ TRUE | Was FALSE in #2947, #2949 (fixed) |
| Mark Order Done | ✅ | Order marked done |
| Google Sheets | ✅ | Row appended |
| Assemble Response | ✅ | Full response with URLs + keys |
| Trigger Email Workflow | ❌ 503 | n8n Cloud resource exhaustion |

#### Email Trigger 503 Fix Deployed
- **Wait Before Email** node added: 10-second delay before email trigger (gives n8n Cloud time to free resources)
- **Trigger Email Workflow** retry enabled: `retryOnFail: true`, `maxTries: 3`, `waitBetweenTries: 5000ms`
- Connection chain: `Execute a SQL query → Wait Before Email → Trigger Email Workflow`
- Main workflow now 138 nodes

#### Execution #2953: Platform crash (0 nodes, "Unknown error") — same n8n Cloud issue as #2940/#2943

**Status:** Wait+retry deployed. Needs one more test to verify email delivery.

---

## Previous Session: 2026-02-10 (Session 22+23)

### Session 23 Summary — LinkedIn Addon Test PASSED

**Test:** Executive + LinkedIn addon from real frontend
**Execution #2938:** 99/99 nodes, 249s, **SUCCESS**

Three fixes applied earlier in session (from failed #2935):
1. **LI Build Sections1** — Added missing `role` field to `responses.values` (was `{type: "system"}`, now `{role: "system", type: "text"}`)
2. **Capture LinkedIn** — Changed orderId expression to `$('LinkedIn Optimization1').first().json.orderId` (after AI node, `$json` only has response)
3. **Postgres - Add Doc(linkedin)** — Added `onError: continueRegularOutput`, disabled retryOnFail

**LinkedIn Path Results:**
| Node | Status | Key Data |
|------|--------|----------|
| LI Build Sections1 | ✅ | 1,060 input tokens (was 3 in #2935), 709 output tokens, gpt-4o |
| Capture LinkedIn | ✅ | orderId populated, joinKey, linkedinKey, ctx all present |
| Validate & Clean2 | ✅ | liNeedsRepair: false, binary `linkedin.json` created |
| Upload LinkedIn to Supabase | ✅ | Key + Id returned |
| Postgres - Add Doc(linkedin) | ✅ | `{success: true}` |

**LinkedIn JSON Quality:** headline, about, 2 experiences, 20 skills, 20 keywords, 4 featured suggestions, 5 settings checklist items — all validated, no placeholders.

### Session 22 Summary (Batch 25+26 — WorkflowHasIssuesError Fix + modelId + File Type Routing)

**Problem 1 (Batch 25):** WorkflowHasIssuesError blocking ALL execution.
- CloudConvert community node uninstalled on n8n Cloud → runtime error
- LinkedIn connection types "0" instead of "main" → broken connections
- **Fix:** CloudConvert disabled, LinkedIn connections fixed

**Problem 2 (Batch 26):** AI nodes all had red triangles — "parameter 'Model' is required".
- n8n Cloud updated validation to REQUIRE explicit `modelId` (previously defaulted silently)
- 11 of 12 AI nodes had no modelId set
- **Fix:** Set modelId on all 12 AI nodes using resourceLocator format

**Problem 3 (Batch 26):** File Type Routing FALSE branch disconnected.
- **Fix:** Used `rewireConnection` to change FALSE → joinKey1 to FALSE → Extract from File1

**Problem 4:** Google Docs OAuth2 token expired.
- **Fix:** User re-authenticated credentials in n8n UI

**Test Results:**
| Execution | Package | Nodes | Status | Duration |
|-----------|---------|-------|--------|----------|
| #2929 | Starter | 90/90 | **SUCCESS** | 137s |
| #2932 | Executive | 104/104 | **SUCCESS** | 166s |
| #2938 | Executive + LinkedIn | 99/99 | **SUCCESS** | 249s |

---

## Previous Session: 2026-02-09 (Session 21)

### Session Summary (Batch 24 — LinkedIn Optimization Addon Fix)

**Problem:** LinkedIn addon completely broken — 6 issues.
**Fixes Applied:** 8 operations + 1 followup. See PLAN.md Batch 24 section for details.
**Status:** All fixes applied. Ready for test order with `addons: ["linkedinoptimize"]`.

---

## Previous Session: 2026-02-08 (Session 20)

### Session Summary (Batch 23 — CV Formatting Fix)

**Problem:** AI outputs Markdown syntax (`**` for bold headers) which Google Docs renders as literal text in PDFs. CVs show `**PROFESSIONAL SUMMARY**` instead of clean headers.

**Root Cause:**
- Starter prompt: "Use clear section headings" — AI defaults to Markdown
- Standard prompt: explicitly says "Bold section headers" — triggers `**bold**`
- Premium/Executive prompts: no formatting instructions — Claude defaults to Markdown
- Proofread/Format nodes: no anti-Markdown instructions — pass through unchanged
- Cover letter nodes: same issue

**Fixes Applied (11 nodes across main workflow):**

| # | Node | ID | Fix |
|---|------|----|-----|
| 1 | Rewrite CV (Starter) | `d9e754f1` | Added FORMATTING section: ALL CAPS headers, explicit no-Markdown |
| 2 | Rewrite CV1 (Standard) | `3cbc6655` | Replaced "Bold section headers" → ALL CAPS + no-Markdown |
| 3 | Premium CV Rewrite (Sonnet) | `aaf4fa34` | Added FORMATTING section: ALL CAPS headers, no-Markdown |
| 4 | Executive CV Rewrite (Opus) | `2245d030` | Added FORMATTING section: ALL CAPS headers, no-Markdown |
| 5 | Starter - Proofread CV | `35bf08e4` | Added "Preserve ALL CAPS headers, no Markdown" |
| 6 | Standard - Proofread CV | `df4bf557` | Added "Preserve ALL CAPS headers, no Markdown" |
| 7 | Executive - Format CV Layout | `e16e2f32` | Added ALL CAPS + no-Markdown rules |
| 8 | Cover Letter Rewrite (Standard) | `b6a6f5f5` | Added no-Markdown formatting rules |
| 9 | Cover Letter Rewrite1 (Premium) | `dde6a403` | Added no-Markdown formatting rules |
| 10 | Cover Letter Rewrite2 (Executive) | `f115fc99` | Added no-Markdown formatting rules |
| 11 | Cover Letter - Generate (Addon) | `ec45e397` | Added no-Markdown formatting rules |

**Batch 23 Part 2 — Markdown Safety Net + Editable Word Addon Fixes:**

Execution #2906 (Executive + editableword) ran today and revealed:
1. AI models re-introduce Markdown despite prompt instructions (Standard Proofread GPT-4o-mini + Executive Format Layout Claude Opus)
2. Editable Word addon path has 3 bugs blocking email delivery

**Additional Fixes Applied (9 more operations):**

| # | Node | Fix |
|---|------|-----|
| 12 | cvRewriteText (Code) `41e2e5c9` | Added Markdown stripping: removes #, **, ---, *, ` before creating binary |
| 13 | Starter - Proofread CV `35bf08e4` | Strengthened: "CRITICAL FORMATTING RULES" + zero markup |
| 14 | Standard - Proofread CV `df4bf557` | Strengthened: "CRITICAL FORMATTING RULES" + zero markup |
| 15 | Executive - Format CV Layout `e16e2f32` | Strengthened: "Do NOT use ANY Markdown" + "keep EXACT same text" |
| 16 | Build HTML `e566e748` | Fixed: reads `$json.ctx.rewrittenCVText` (was `$json.cvRewriteText` = empty) + Markdown strip |
| 17-18 | HTTP Request2 → Upload DOCX | Fixed connection type: "0" → "main" |
| 19-20 | Upload DOCX → Postgres - Add Doc1 | Fixed connection type: "0" → "main" |

**Still Needs Manual Fix:**
- **HTTP Request1 (CloudConvert)**: 401 Unauthenticated — API key needs renewal in n8n credentials UI
- This blocks Editable Word addon (HTML → DOCX conversion)

**Execution #2906 Analysis:**
| Item | Status | Notes |
|------|--------|-------|
| Executive CV Rewrite (Opus) | ✅ CLEAN | ALL CAPS headers, no Markdown |
| Standard Proofread (GPT-4o-mini) | ❌ Added `**` | Re-introduced Markdown despite instructions |
| Format Layout (Opus) | ❌ Added `#`, `##` | Re-introduced headings Markdown |
| Cover Letter (Opus) | ✅ CLEAN | No Markdown, professional format |
| Build HTML | ❌ Empty body | `$json.cvRewriteText` was undefined (FIXED) |
| HTTP Request1 | ❌ 401 | CloudConvert API key expired/missing |
| Email sent | ❌ | Pipeline stopped at DOCX conversion |

---

## Previous Session: 2026-02-05 (Session 19)

### Session Summary (Batch 22 — Cover Letter Email Test PASSED + Addon Testing)

**Test Order:** Starter + extracoverletter addon | John Murphy | gerard.mulrey@gmail.com
**Executions:** Intake #2899 → Processing #2900 → Email #2901 (ALL SUCCESS)

| Step | Execution | Status | Duration | Key Result |
|------|-----------|--------|----------|------------|
| Intake | #2899 | SUCCESS | 108s | 202 returned, forwarded to processing |
| Processing | #2900 | SUCCESS | 158s | CV rewrite (GPT-4o, 10.6s) + Cover letter (GPT-4o, 13s) + Supabase upload |
| Email | #2901 | SUCCESS | 2.1s | BOTH PDFs attached: CV (48.6KB) + Cover Letter (36.9KB), Mark Sent ✅ |

**Batch 21 fixes VERIFIED:** Cover letter storage path + email download URL both working correctly.

---

## Previous Session: 2026-02-05 (Session 18)

### Session Summary (Batch 21 COMPLETE — Cover Letter Storage Path + Email Download Fix)

**Problem Chain Discovered:**

| Execution | Error | Root Cause |
|-----------|-------|------------|
| #2889 | Cover letter 404 | Storage key had wrong bucket path |
| #2894 | "Bucket not found" | `careeredge-orders` doesn't exist (only `cvstore`) |
| #2897 | Processing ✅ | Upload fixed with cvstore bucket |
| #2898 | Cover letter 404 | Email workflow `$json.docs.cover_letter` was undefined |

**Root Cause Analysis:**
- **Supabase:** Only `cvstore` bucket exists (CV and cover letter both use it)
- **Storage key:** Must include bucket: `cvstore/orders/{orderId}/cover_letter.pdf`
- **Email download:** After "Download Rewritten CV" runs, `$json` contains HTTP response (not original payload), so `$json.docs.cover_letter` is undefined

**Fixes Applied:**

**Main Workflow (`40hfyY9Px6peWs3wWFkEY`):**
| Node | Fix |
|------|-----|
| Upload Cover Letter to Supabase | URL uses `cvstore` bucket |
| Postgres - Add Doc(cover)1 | Storage key: `cvstore/orders/{orderId}/cover_letter.pdf` |

**Email Workflow (`IS4rAklMjfCiQnV5`):**
| Node | Fix |
|------|-----|
| Download Cover Letter | URL changed from `$json.docs.cover_letter` to `$node['Prepare Email Payload'].json.docs.cover_letter` |

**Correct Flow:**
- Upload to: `cvstore/orders/{orderId}/cover_letter.pdf`
- Store key: `cvstore/orders/{orderId}/cover_letter.pdf`
- Email downloads: `/storage/v1/object/cvstore/orders/{orderId}/cover_letter.pdf` ✅

**Ready for Testing:**
- Submit Starter + Extra Cover Letter addon order
- Verify BOTH CV PDF and Cover Letter PDF arrive in email

---

## Previous Session: 2026-02-04 (Session 17)

### Session Summary (Batch 20 COMPLETE — Cover Letter Upload Rewired to Supabase)

**Main Workflow Fix Applied (`40hfyY9Px6peWs3wWFkEY`):**

| Fix | Status | Details |
|-----|--------|---------|
| Removed AWS S3 node | ✅ | "Upload CoverLetter1" removed (was uploading to wrong location) |
| Added Supabase HTTP node | ✅ | "Upload Cover Letter to Supabase" already existed, now connected |
| Connection rewired | ✅ | Move Binary Data → Upload Cover Letter to Supabase → Reattach Context2 |
| Stale connections cleaned | ✅ | Removed orphaned "0" type connections |

**Node Count:** 138 → 137 (removed Upload CoverLetter1)

**What Was Fixed:**
- Cover letter PDFs were uploading to AWS S3 (`careeredge-orders.s3.eu-west-1.amazonaws.com`)
- Email workflow downloads from Supabase (`xidmgkcqltvknvtuoeoh.supabase.co`)
- This mismatch caused 404 errors when email workflow tried to fetch cover letter
- Now cover letter uploads directly to Supabase via HTTP Request (matching CV upload pattern)

---

## Previous Session: 2026-02-03 (Session 16)

### Session Summary (Batch 20 — Email Workflow Fixed + CV Formatting Issue Identified)

**Email Workflow Fixes Applied (`IS4rAklMjfCiQnV5`):**

| Fix | Status | Details |
|-----|--------|---------|
| Replaced AWS S3 node | ✅ | "Download a file" → "Download Cover Letter" (HTTP Request) |
| Supabase URL configured | ✅ | `{{ $json.docs.cover_letter }}` with auth headers |
| Binary output | ✅ | Stores as `coverLetterPdf` |
| Gmail attachments | ✅ | Now attaches both `rewrittenCV` AND `coverLetterPdf` |
| Reattach Email Meta | ✅ | Merges binaries from both download nodes |
| Connection type fix | ✅ | Changed from "0" to "main" (first test #2880 failed due to this) |

**Test Results:**
| Execution | Status | Notes |
|-----------|--------|-------|
| #2879 | Processing ✅ | Cover letter + CV generated, email triggered |
| #2880 | Email ❌ | Only 7 nodes ran - connections used type "0" instead of "main" |
| (pending) | — | Re-test needed after connection fix |

**CV Formatting Issue Identified:**
- User feedback: CV has `**` markers around headers (unprofessional)
- Root cause: AI outputs Markdown syntax, Google Docs renders as literal text
- Fix needed: Update CV rewrite prompts to output plain text with:
  - ALL CAPS section headers (no Markdown)
  - Clear line breaks between sections
  - Professional formatting without ** or * symbols

**503 Errors During Session:**
- n8n Cloud returned 503 while workflows were processing
- This is expected behavior (instance busy)
- See PLAN.md "Future: Scalability Plan" for production solutions

---

## Previous Session: 2026-02-03 (Session 15)

### Session Summary (Batch 19 VERIFIED — Cover Letter Addon Generation Working)

**Test Order:** Starter + extracoverletter addon
**Executions:** Intake #2875 → Processing #2876 → Email #2877

**Cover Letter Addon — GENERATION VERIFIED ✅**
| Node | Status | Time |
|------|--------|------|
| Extra Cover Letter (IF) | ✅ `hasExtraCoverLetter: true` | 0ms |
| Cover Letter - Generate | ✅ GPT-4o generated 321 tokens | 9.4s |
| Create Cover Letter Doc | ✅ Google Docs created | 1.4s |
| Write Cover Letter Content | ✅ Text written | 1.0s |
| Download Cover Letter PDF | ✅ PDF downloaded | 1.1s |
| Upload CoverLetter1 | ✅ S3/Supabase upload | 0.8s |
| Trigger Email Workflow | ✅ Email triggered | 0.1s |

**Email Delivery — PARTIAL ⚠️**
| Item | Status | Notes |
|------|--------|-------|
| CV PDF attached | ✅ 48.5KB | Downloaded from Supabase, attached as `rewrittenCV` |
| Cover letter attached | ❌ | "Download a file" node error: `Cannot read properties of undefined` |
| Email sent | ✅ | Gmail thread `19c24c1f50741a1f`, DB status="sent" |
| Mark Sent | ✅ | job_id 75 updated |

**Root Cause — Email Workflow "Download a file" Node:**
- Node type: `n8n-nodes-base.awsS3` (ID: `7f9104bd`)
- Problem: Configured for AWS S3 but we use **Supabase Storage**
- Error: `Cannot read properties of undefined (reading 'split')`
- The cover letter PDF exists at Supabase URL but AWS S3 node can't access it

**Fix Needed (Email Workflow `IS4rAklMjfCiQnV5`):**
1. Replace "Download a file" (AWS S3) with HTTP Request node (like "Download Rewritten CV")
2. Configure to download from `$json.docs.cover_letter` Supabase URL
3. Store as binary `coverLetterPdf`
4. Update Gmail "Send a message" to attach both `rewrittenCV` and `coverLetterPdf`

**503 Error During Session:**
- n8n Cloud returned 503 while processing #2876 (154s execution)
- This is expected behavior when instance is busy
- See "Future: Scalability Plan" in PLAN.md for production solutions

---

## Previous Session: 2026-02-03 (Session 14)

### Session Summary (Batch 19 — CV Prompt Fix Verified + Cover Letter Addon Fixes)

**CV Rewrite Prompt Fix — VERIFIED WORKING (execution #2870):**
- Contact information preserved: Full name, email, phone, LinkedIn at top of CV ✅
- Specific tools preserved: Ahrefs, Moz, HubSpot, Marketo, Google Analytics all retained ✅
- ATS keywords included from job description ✅
- **Quality Rating: 8.5/10** (up from 6.5/10)

**Cover Letter Addon Flow — 4 FIXES APPLIED (pending test):**

| # | Node | ID | Issue | Fix |
|---|------|----|-------|-----|
| 1 | Prepare Document Row | `84c74363` | ctx object (with addons array) was dropped | Added `ctx` passthrough assignment |
| 2 | Cover Letter - Generate | `ec45e397` | Empty `responses.values: [{}]` — no prompt sent | Added system + user prompts with Responses API format |
| 3 | Capture Cover Letter | `eb5dcfaa` | Looking for Chat Completions format | Updated to extract from `output[0].content[0].text` |
| 4 | Write Cover Letter Content | `25c0ee39` | Looking for Chat Completions format | Updated to check Responses API format first |

**Test Results:**
| Execution | Status | Notes |
|-----------|--------|-------|
| #2870 | **CV SUCCESS** | CV rewrite 8.5/10, but cover letter addon didn't trigger (ctx passthrough bug) |
| #2873 | **CL PARTIAL** | Cover letter flow DID trigger (ctx fix worked), but Write CL failed (empty text - prompt fix needed) |

**Root Cause Chain Discovered:**
1. `addons: ["extracoverletter"]` was in `ctx` at "Collapse To One" ✅
2. "Prepare Document Row" dropped `ctx` — only output `docRow` and `orderId`
3. "Normalize Payload" couldn't find addons → `hasExtraCoverLetter: false`
4. "Extra Cover Letter" IF routed to FALSE branch → cover letter skipped
5. After ctx fix, cover letter flow triggered but "Cover Letter - Generate" had empty prompt
6. GPT returned "It looks like your message is incomplete" (7 input tokens)
7. "Capture Cover Letter" captured empty text → "Write Cover Letter Content" failed

**Fixes Applied — Ready to Test:**
All 4 nodes updated. Next test order should generate cover letter successfully.

---

## Previous Session: 2026-02-03 (Session 13)

### Session Summary (Batch 18 VERIFIED — First Full E2E Success from Real Frontend)
Verified Batch 18 fixes with a real frontend Starter order. **FIRST FULLY SUCCESSFUL END-TO-END RUN.** Intake #2861 → Processing #2862 → Email #2863 all completed successfully. CV rewritten by GPT-4o-mini in 10.4s, PDF created via Google Docs, uploaded to S3/Supabase, email delivered with 44.4KB PDF attachment.

**Order Tested:** `dc2db822-2389-4014-90ed-f73f85867b43` | Starter | John Murphy | gerard.mulrey@gmail.com

**Test Results — ALL PASS:**
- [x] Intake #2861: 202 returned, Forward to Processing fired (expected 30s timeout, processing still received)
- [x] Processing #2862: 90 nodes executed, 142.9s duration, `status: success`
- [x] All Batch 18 fixes verified: `packageTier: "starter"`, `packageMissing: false`, S3 paths correct (no null)
- [x] Switch routed to output 0 (Starter), `pkgStarter: true`
- [x] Rewrite CV: GPT-4o-mini, 10.4s, completed successfully
- [x] Google Docs: Created + wrote content + downloaded as PDF (44.4KB)
- [x] S3 uploads: Original CV + Rewritten PDF both uploaded successfully
- [x] Email #2863: Gmail sent (thread `19c1f51de68b8774`), CV PDF attached, DB status="sent"

**CV Rewrite Quality Rating: 6.5/10**
| Criterion | Score | Notes |
|-----------|-------|-------|
| Structure | 8/10 | Skills moved above Experience (modern best practice) |
| Job Targeting | 6/10 | Some JD keywords, missed "conversion funnels", "SEM" |
| Tone | 7/10 | Professional, could be more assertive for Manager role |
| Language | 7/10 | Improved action verbs, some generic phrasing |
| ATS/SEO | 5/10 | Lost specific tools (Ahrefs, Moz, HubSpot, Marketo) |
| Content | 7/10 | Added 2 new bullets, modest enhancement |

**Issues Found:**
- [x] **CV contact info stripped** — FIXED: Added "CONTACT INFORMATION (CRITICAL - MUST PRESERVE)" to system prompt
- [x] **Specific tools dropped** — FIXED: Added "SKILLS & TOOLS (ATS OPTIMIZATION)" to system prompt
- [ ] **"Download a file" node error** in email workflow: `Cannot read properties of undefined` (non-blocking, legacy node)
- [ ] **Token cost tracking broken** — `tokenCostEur: 0` even though rewrite clearly used tokens
- [ ] **PDF-Text node 401** — pdf.co API key issue (non-blocking, txt files use alternate path)

**Still Pending:**
- [ ] Re-test with new prompt to verify contact info and tools are preserved
- [ ] Addon testing (Extra Cover Letter, LinkedIn, Editable Word, One Day Delivery)
- [ ] Clean up broken "Download a file" node in email workflow

---

## Previous Session: 2026-02-02 (Session 12)

### Session Summary (Batch 18 — Real Frontend Test Analysis & 4 Fixes)
First real frontend order test (execution #2856/#2857). Intake returned 202 quickly but processing pipeline silently stopped at the Switch node — no CV rewrite, no email sent. Root cause: the `package` field was lost during intake-to-processing forwarding (field name mismatch). Three additional bugs discovered and fixed.

**Order Tested:** `03863fdd-3a82-42be-b24d-c93ed8939dc0` | Starter | John Murphy | gerard.mulrey@gmail.com

**Completed This Session:**
- [x] Fix 1 (CRITICAL): Intake Forward reads `$json.body.package || $json.body.packageTier` (was only reading `packageTier` which frontend doesn't send)
- [x] Fix 2 (CRITICAL): Switch output 4 (catch-all) wired to Rewrite CV (was a dead end — silent failure)
- [x] Fix 3 (HIGH): Build Keys uses `$json.order_id || $json.orderId` (snake_case after DB merge was causing `orders/null/` S3 paths)
- [x] Fix 4 (MEDIUM): Normalise & Validate price-to-tier fallback: 499→starter, 799→standard, 1499→premium, 2499→executive

**Key Discoveries:**
- Frontend sends `package: "starter"` but intake Forward mapped `$json.body.packageTier` (undefined) → empty string
- n8n Switch routing to an unconnected output = `status: success` (silent failure, no error)
- After Supabase merge, `orderId` (camelCase) becomes `null` — only `order_id` (snake_case) survives
- Forward to Processing HTTP request times out at 30s but retries ~3x (110s total), processing workflow still receives and runs

### Previous Session: 2026-02-02 (Session 11)

### Session Summary (Batch 17 COMPLETE — 524 Cloudflare Timeout Fix Implemented)
Implemented the two-workflow split to fix 524 Cloudflare timeout. Created new intake workflow (`I9MS3uIjhD4kNlbP`) with 5 nodes that validates input, returns 202 in <0.5s, and forwards to the processing workflow asynchronously. Modified main workflow: changed webhook path to `careeredge/process`, set responseMode to `onReceived`, and REMOVED all 8 respondToWebhook nodes (n8n rejects ANY respondToWebhook nodes when using `onReceived`, even disabled ones). Reconnected Ack Payload → Stash Metadata. Main workflow went from 145 to 137 nodes.

**Completed This Session:**
- [x] Modified main workflow: webhook path → `careeredge/process`, responseMode → `onReceived`
- [x] Created intake workflow (`I9MS3uIjhD4kNlbP`): 5 nodes, POST `careeredge/submit`
- [x] Removed 8 respondToWebhook nodes from main workflow (required for `onReceived` mode)
- [x] Reconnected Ack Payload → Stash Metadata (replaced removed Respond 202 link)
- [x] Fixed webhookId registration (API-created webhook nodes need explicit webhookId)
- [x] Fixed binary field name: n8n names multipart file fields with index (`cv` → `cv0`)
- [x] Tested: 400 validation in 219ms, 202 acceptance in <0.5s, processing pipeline verified

**Key Discoveries:**
- n8n webhook nodes created via API need explicit `webhookId` for proper registration
- n8n multipart file fields get an index appended: `cv` becomes `cv0`
- n8n `checkResponseModeConfiguration` rejects ANY respondToWebhook node types with `onReceived`, even disabled ones — must be fully removed

**Still Pending:**
- [ ] **Real frontend order test** — submit from actual frontend to verify full pipeline
- [ ] Addon testing (Extra Cover Letter, LinkedIn, Editable Word, One Day Delivery)
- [ ] Investigate frontend confirmation page slowness (not n8n — webhook responds in ~10ms)

### Previous Session: 2026-02-01 (Session 10)

#### Session Summary (524 Timeout Plan Designed)
Designed the two-workflow split plan to fix the 524 Cloudflare timeout. Plan approved, ready to implement.

### Previous Session: 2026-02-01 (Session 9)

**Batch 16 COMPLETE — ALL 4 Tiers PASSED:**
- [x] Executive tier PASSED — execution #2837 (91 nodes, 195s, zero fixes needed)
- [x] Starter tier PASSED — execution #2842 (91 nodes, 148s, required Capture Rewrite Responses API fix)
- [x] Standard tier PASSED — execution #2835 (103 nodes, 148s, CV + CL + Email)
- [x] Email Delivery "If Email Sent Ok" fixed — execution #2836, Mark Sent status="sent"
- [x] 11 total fixes across Batch 16 (8 main + 3 email delivery)

### Latest Test Results
| Execution | Workflow | Status | Notes |
|-----------|----------|--------|-------|
| **2992** | **Email** | **SUCCESS** | **Executive+LI+DOCX+OneDay: 4 attachments (CV+CL+LI+DOCX), Gmail `19c6ca0dcd06539e`, Mark Sent ✅** |
| **2991** | **Processing** | **SUCCESS** | **Executive+LI+DOCX+OneDay: 127 nodes, 264s. All addon chains executed ✅** |
| **2990** | **Intake** | **SUCCESS** | **Executive+LinkedIn+EditableWord+OneDay submitted, 202 returned** |
| **2989** | **Email** | **SUCCESS** | **Starter+DOCX: 2 attachments (CV PDF + DOCX), Gmail `19c6ba810501da88`, Mark Sent ✅** |
| **2988** | **Processing** | **SUCCESS** | **Starter+EditableWord: 98 nodes, 180s. Google Docs DOCX chain ✅** |
| **2987** | **Intake** | **SUCCESS** | **Starter+EditableWord submitted, 202 returned** |
| **2956** | **Email** | **SUCCESS** | **Gmail sent, CV (47.3KB) + CL (38.6KB) attached, Mark Sent ✅. Thread `19c5313f33850434`** |
| **2955** | **Processing** | **SUCCESS** | **Executive + LinkedIn: 112 nodes, 259s. Wait Before Email (10s) → Trigger (189ms, no 503) ✅** |
| **2954** | **Intake** | **SUCCESS** | **Executive + LinkedIn submitted, 202 returned** |
| **2951** | **Processing** | **SUCCESS** | **Executive + LinkedIn: 111/111 nodes, 247s, FULL PIPELINE through Mark Order Done + Sheets + SQL ✅. Email 503 (Wait+retry deployed)** |
| **2938** | **Processing** | **SUCCESS** | **Executive + LinkedIn: 99/99 nodes, 249s, LinkedIn JSON generated + uploaded + DB inserted ✅** |
| **2932** | **Processing** | **SUCCESS** | **Executive: 104/104 nodes, 166s, Claude Opus CV + CL + full pipeline ✅** |
| **2929** | **Processing** | **SUCCESS** | **Starter: 90/90 nodes, 137s, GPT-4o-mini CV rewrite + email ✅** |
| **2901** | **Email** | **SUCCESS** | **BOTH CV (48.6KB) + Cover Letter (36.9KB) attached, Gmail sent, Mark Sent ✅** |
| **2900** | **Processing** | **SUCCESS** | **Starter + CL addon, 158s, CV rewrite + cover letter generated + uploaded ✅** |
| **2899** | **Intake** | **SUCCESS** | **Starter + extracoverletter, 202 returned, forwarded to processing ✅** |
| 2898 | Email | PARTIAL | CV attached ✅, Cover letter 404 (URL empty — $json reference bug). Fixed. |
| 2897 | Processing | SUCCESS | Cover letter upload to cvstore bucket ✅. 137 nodes, 150s |
| 2896 | Intake | SUCCESS | Starter + extracoverletter addon accepted, 202 returned |
| 2894 | Processing | ERROR | "Bucket not found" — careeredge-orders doesn't exist (reverted to cvstore) |
| 2893 | Intake | SUCCESS | Test order submitted |
| **2870** | **Processing** | **SUCCESS** | **CV rewrite 8.5/10 — contact info + tools preserved** |
| **2863** | **Email** | **SUCCESS** | **Gmail sent, CV PDF (44.4KB) attached, status="sent" ✅** |
| **2862** | **Processing** | **SUCCESS** | **FIRST FULL E2E: 90 nodes, 142.9s, CV rewritten, PDF created ✅** |
| **2861** | **Intake** | **SUCCESS** | **Frontend order accepted, 202 returned** |
| **2842** | **Processing** | **SUCCESS** | **Starter tier: CV only, no cover letter (correct). 91 nodes, 148s** |
| **2837** | **Processing** | **SUCCESS** | **Executive tier: 4-step AI chain, cover letter. 91 nodes, 195s** |
| **2835** | **Standard** | **SUCCESS** | **CV PDF populated, cover letter, email delivered. 103 nodes, 148s** |
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
| Rate Limiter | `b0f341bb-668e-4fcc-9dfe-5b9825cd7918` | 2.2s delay before response | Move to intake workflow |
| Idempotency Check | `b7dad4ba-70b5-45fa-8f0f-14f6d82f66df` | 2.2s delay before response | Move to intake workflow |
| Error Handler | `0d11e236-af2b-4175-9285-9963c4a43ee5` | Duplicates separate workflow | Remove entirely |
| Ack Payload | `ffc0e75a` | No longer needed (responseMode: onReceived) | No |

### Removed Nodes (Batch 17)
8 respondToWebhook nodes removed from main workflow — required because n8n rejects ANY respondToWebhook nodes when webhook uses `responseMode: "onReceived"`:

| Node | ID | Was Used For |
|------|----|-------------|
| Respond 202 | `42ef179a` | Original 202 response (now handled by intake workflow) |
| Respond to Webhook 400 | `a8b20102` | Error response (now handled by intake workflow) |
| Error Message - No CV | `45d2a4bc` | Missing CV error |
| CV too Large | `a89ebc36` | File size error |
| CV Infected | `83590b2d` | Malware scan error |
| Error Message | `add57c9d` | Generic error |
| JD Required | `c55a8073` | Missing job description error |
| Error - Unknown Package Tier | `7fa1eddc` | Invalid tier error |

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
| Starter | €4.99 | CV rewrite only | [x] PASSED - #2842 (91 nodes) + #2929 (90 nodes, 137s) |
| Standard | €7.99 | CV + Cover Letter | [x] PASSED - execution #2835 (103 nodes, 148s) |
| Premium | €14.99 | CV + Cover Letter (Claude Sonnet) | [x] PASSED - execution #2827 (104 nodes, 167s) |
| Executive | €24.99 | CV + Cover Letter + Layout + Priority | [x] PASSED - #2837 (91 nodes) + #2932 (104 nodes, 166s) |

- [x] Starter - Upload TXT, verify GPT-4o-mini rewrite, NO cover letter (**PASSED** #2842)
- [x] Standard - Upload TXT, verify GPT-4o-mini rewrite + cover letter + email (**PASSED** #2835)
- [x] Premium - Upload TXT, verify Claude Sonnet rewrite + cover letter + email (**PASSED** #2827)
- [x] Executive - Upload TXT, verify Claude Opus rewrite + cover letter + layout (**PASSED** #2837)
- [ ] Invalid Tier - Send "deluxe", verify 400 error

### Addon Tests (EXTRA, on top of package)
- [x] Extra Cover Letter - PASSED (execution #2899→#2901, PDF attached to email)
- [x] LinkedIn Optimization - PASSED (#2938, #2965, #2986 — JSON + PDF generated, email attached)
- [x] Editable Word - PASSED (#2988, #2991 — CloudConvert replaced with Google Docs API, DOCX attached to email)
- [x] One Day Delivery - PASSED (#2985 — priority=true, sla='1-day', due_date=+24h in DB)
- [x] All Working Addons Combined - PASSED (#2991 — Executive + LinkedIn + Editable Word + One Day, 4 attachments)
- [x] No Addons - Verified (Starter #2929, #2976 — no addons, SUCCESS)

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

**Last Updated:** 2026-02-17
**Status:** Session 29 — ALL 4 ADDONS VERIFIED. Editable Word addon replaced CloudConvert with Google Docs API. Full combo test (Executive + LinkedIn + Editable Word + One Day) PASSED with 4 email attachments.
**Next Action:** Production hardening (intermittent n8n Cloud crashes) + frontend investigation
