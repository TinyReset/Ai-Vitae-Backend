# Ai-Vitae Project Plan

## ⚠️ CRITICAL: Workflow Source of Truth

**NEVER use local JSON workflow files - they are OUTDATED.**
- The **ONLY** valid workflow is the live n8n workflow via MCP connection
- **ALL** workflow reads: `n8n_get_workflow(id="40hfyY9Px6peWs3wWFkEY", mode="structure")`
- **ALL** workflow changes: `n8n_update_partial_workflow(id="40hfyY9Px6peWs3wWFkEY", operations=[...])`
- Local `.json` files are snapshots for reference only - DO NOT modify or rely on them

---

## Project Overview

**Ai-Vitae** is a CV/resume rewriting service built on n8n with tiered AI processing.

**Repository:** https://github.com/TinyReset/Ai-Vitae-Backend

### Current Status (as of 2026-02-17)
- **Main Workflow:** Ai-Vitae Workflow - Processing-only worker (async)
- **Workflow ID:** `40hfyY9Px6peWs3wWFkEY`
- **Nodes:** 147
- **Intake Workflow:** Ai-Vitae Intake (524 Fix)
- **Intake Workflow ID:** `I9MS3uIjhD4kNlbP` (5 nodes, ACTIVE)
- **Email Workflow ID:** `IS4rAklMjfCiQnV5` (22 nodes, ACTIVE — restructured Session 28, DOCX attachment added Session 29)
- **Batch 1-18:** Complete — ALL 4 tiers PASSED, Email Delivery FIXED, 524 Timeout FIXED, Real Frontend E2E PASSED
- **Batch 19:** COMPLETE — Cover letter addon generation verified (execution #2876)
- **Batch 20:** COMPLETE — AWS S3 node removed, Supabase HTTP upload connected
- **Batch 21:** COMPLETE — Cover letter storage path + email download URL fixed
- **Batch 23:** COMPLETE — CV formatting fix: 11 AI prompt nodes updated (ALL CAPS headers, no Markdown)
- **Batch 24:** COMPLETE — LinkedIn Optimization addon fixed: prompt, capture, validation, Supabase upload (8 ops)
- **Starter pipeline:** PASSED (execution #2842 — 91 nodes, 148s, CV only)
- **Standard pipeline:** PASSED (execution #2835 — 103 nodes, 148s, CV + Cover Letter + Email)
- **Premium pipeline:** PASSED (execution #2827 — 104 nodes, 167s)
- **Executive pipeline:** PASSED (execution #2837 — 91 nodes, 195s, CV + CL + Layout + Priority)
- **524 Fix:** IMPLEMENTED — intake returns 202 in <0.5s, processing runs async (execution #2854)
- **CV Prompt Fix:** VERIFIED — Contact info + tools preserved (execution #2870, quality 8.5/10)
- **Cover Letter Addon:** Storage + Email download FIXED — Uploads to `cvstore` bucket, email downloads correctly
- **Cover Letter Email Test:** PASSED — BOTH CV (48.6KB) + Cover Letter (36.9KB) attached to email (#2901)
- **CV Formatting:** FIXED — All 11 AI prompts updated: ALL CAPS headers, no Markdown (Batch 23)
- **LinkedIn Addon:** FIXED — AI prompt, capture, validation, S3→Supabase upload, Postgres key (Batch 24, 8 ops)
- **Batch 25:** COMPLETE — CloudConvert disabled (fixed WorkflowHasIssuesError #2908), LinkedIn connection types fixed ("0"→"main")
- **Batch 26:** COMPLETE — modelId set on all 12 AI nodes, File Type Routing FALSE→Extract from File1 fixed, Google Docs OAuth2 re-authenticated
- **Starter re-test:** PASSED (execution #2929 — 90 nodes, 137s, full end-to-end)
- **Executive re-test:** PASSED (execution #2932 — 104 nodes, 166s, full end-to-end including cover letter)
- **LinkedIn addon test:** PASSED (execution #2938 — 99 nodes, 249s, Executive + LinkedIn, all 5 LinkedIn nodes succeeded)
- **LinkedIn fixes (Session 23):** LI Build Sections1 role field, Capture LinkedIn orderId reference, Postgres error handling
- **Session 24:** Full pipeline PASS (#2951, 111/111 nodes). Data context fixes (Restore Context + Shape Documents Map). Wait+retry for email trigger 503.
- **Session 26:** LinkedIn PDF email attachment. Cleaned 7 duplicate "0" connections, fixed email "0"→"main". Executive+LinkedIn #2958→#2959 PASSED (3 attachments).
- **Session 28:** Email workflow restructured (19→21 nodes): `Has LinkedIn?` IF + `Send CV+CL` Gmail node for conditional attachments. Migration 005 adds `priority`/`sla`/`due_date` to orders table. All tiers + addons verified:
  - Starter #2976→#2977 PASSED (Send CV Only)
  - Premium #2979→#2980 PASSED (Send CV+CL)
  - Premium+LinkedIn+OneDay #2985→#2986 PASSED (Send Full + priority/SLA DB update)
- **Session 29:** Editable Word addon — CloudConvert replaced with Google Docs API. Main workflow: 6 new/updated nodes (Format CV for Doc, Create CV Doc, Write CV Content, Download CV DOCX, Upload DOCX to Supabase, Restore Context DOCX). Email workflow: Download Editable DOCX node + all 3 Gmail nodes updated with editableDocx attachment. Both tests PASSED:
  - Starter+EditableWord #2987→#2988→#2989: 2 attachments (CV PDF 49.2KB + DOCX 8.02KB). Gmail `19c6ba810501da88`.
  - Executive+LinkedIn+EditableWord+OneDay #2990→#2991→#2992: 4 attachments (CV 48.4KB + CL 37.7KB + LinkedIn 47.9KB + DOCX 8.04KB). Gmail `19c6ca0dcd06539e`.
- **Next:** Production hardening (intermittent n8n Cloud crashes)

### Repositories
| Repo | URL | Purpose |
|------|-----|---------|
| Backend | https://github.com/TinyReset/Ai-Vitae-Backend | n8n workflow docs, migrations, scripts |
| Frontend | https://github.com/TinyReset/CVBuidler | Next.js website (Vercel deployed) |

---

## Architecture Summary

### Package Tiers
| Tier | Price | AI Model | Includes |
|------|-------|----------|----------|
| Starter | €4.99 | GPT-4o-mini | CV rewrite only |
| Standard | €7.99 | GPT-4o-mini | CV rewrite + Cover Letter |
| Premium | €14.99 | Claude Sonnet 4 | CV rewrite + Cover Letter (advanced AI) |
| Executive | €24.99 | Claude Opus 4.1 | CV + Cover Letter + Layout guidance + Priority |

**Note:** Cover letter is INCLUDED in Standard, Premium, and Executive packages (not an add-on).

### Add-ons (Extra, on top of any package)
1. **Extra Cover Letter** - Additional GPT-4o generated cover letter PDF
2. **LinkedIn Optimization** - Optimized LinkedIn profile text
3. **Editable Word** - Google Docs → DOCX download (replaced CloudConvert)
4. **One Day Delivery** - Priority processing with 24h SLA

### Supporting Workflows
| Workflow | ID | Status |
|----------|-----|--------|
| Intake (524 Fix) | `I9MS3uIjhD4kNlbP` | ✅ Active (5 nodes, POST /careeredge/submit) |
| Email Delivery | `IS4rAklMjfCiQnV5` | ✅ Validated |
| Error & Alert Monitor | `dpobArFb9d8F6RZp` | ✅ Validated |
| Data Retention Cleaning | `hYDSPAe1oNN1Sgrs` | ✅ Validated |

---

## Session 29: Editable Word Addon — CloudConvert → Google Docs API (2026-02-17)

### Goal
Replace the never-working CloudConvert chain (disabled since Batch 25) with Google Docs API for the Editable Word addon. The Google Docs pattern was already proven working for LinkedIn PDF generation.

### Main Workflow Changes (147 nodes, was 145 — removed 2 CloudConvert, added 4 new)

#### Nodes Removed
| Node | ID | Was |
|------|-----|-----|
| HTTP Request1 (CloudConvert create) | `60adc94c` | POST to `api.cloudconvert.com/v2/jobs` |
| HTTP Request2 (CloudConvert download) | `09840076` | GET CloudConvert export URL |

#### Nodes Added/Updated
| Node | ID | Type | Purpose |
|------|-----|------|---------|
| Format CV for Doc | `e566e748` | Code | Renamed from "Build HTML". Strips markdown, outputs clean `formattedCVText` |
| Create CV Doc | `create-cv-doc` | Google Docs v2 | Creates doc in Ai-Vitae CVs drive folder. Creds: `4vk8gMiMgE4tUsQY` |
| Write CV Content | `write-cv-content` | Google Docs v2 | Inserts text at end of body |
| Download CV DOCX | `download-cv-docx` | Google Drive v3 | Downloads as DOCX (`application/vnd.openxmlformats-officedocument.wordprocessingml.document`). Creds: `ioNgSTT7FJkSUINC` |
| Restore Context (DOCX) | `restore-ctx-docx` | Code | Cascading fallback: `$('Format CV for Doc')` → `$('Context (carry)')` → `$json` |
| Upload DOCX to Supabase | `upload-docx-supabase-v2` | HTTP Request | Updated binary field `cvDocx` → `data`, orderId from `$('Format CV for Doc')` |
| Postgres - Add Doc1 | `52084cf4` | Postgres | Updated orderId expression to `$('Format CV for Doc').first().json.orderId` |

#### Connection Chain
```
Editable Word (TRUE) → Format CV for Doc → Create CV Doc → Write CV Content
  → Download CV DOCX → Upload DOCX to Supabase → Postgres - Add Doc1
  → Restore Context (DOCX) → One Day Delivery
Editable Word (FALSE) → One Day Delivery
```

### Email Workflow Changes (22 nodes, was 21 — added 1)

| Node | ID | Change |
|------|-----|--------|
| Prepare Email Payload | — | Added `cv_rewrite_docx` link to email body |
| Download Editable DOCX | `download-docx-email` | New HTTP Request — downloads DOCX from Supabase, output: `editableDocx` |
| Reattach Email Meta | — | Merges DOCX binary, sets `hasEditableWord` flag |
| Send CV Only | — | Added `editableDocx` to attachments list |
| Send CV+CL | — | Added `editableDocx` to attachments list |
| Send Full (CV+CL+LI) | — | Added `editableDocx` to attachments list |

Gmail nodes silently ignore missing binary properties, so adding `editableDocx` to all 3 send nodes works without extra IF branches.

### Connection Fix
All `addConnection` operations via MCP created connections with type "0" instead of "main" (known bug). Fixed via direct n8n REST API (`PUT /api/v1/workflows/{id}`) using Python urllib.

### Test Results
| Test | Executions | Status | Attachments |
|------|-----------|--------|-------------|
| Starter + Editable Word | #2987→#2988→#2989 | **PASSED** | CV PDF (49.2KB) + DOCX (8.02KB) |
| Executive + LinkedIn + Editable Word + One Day | #2990→#2991→#2992 | **PASSED** | CV (48.4KB) + CL (37.7KB) + LinkedIn (47.9KB) + DOCX (8.04KB) |

### Key Details
- Google Docs OAuth2 credentials: `4vk8gMiMgE4tUsQY`
- Google Drive OAuth2 credentials: `ioNgSTT7FJkSUINC`
- Drive folder: `1vpKP_zlqScqx8Ms9fWhGWqCs0f7jxS4H` (Ai-Vitae CVs)
- DOCX export format: `application/vnd.openxmlformats-officedocument.wordprocessingml.document`
- Supabase path: `cvstore/orders/{orderId}/cv_rewritten.docx`
- DB document kind: `cv_rewrite_docx`

---

## Session 24: Data Context Fixes + Email Trigger Wait+Retry (2026-02-12)

### Goal
Fix data context loss causing Validate - Has OrderId to route FALSE (blocking Mark Order Done + email trigger). Then fix recurring 503 on Trigger Email Workflow.

### Problem 1: Schema Missing → Validate - Has Schema and OrderId FALSE
- `schema` field set by `Build Keys` but dropped at `Stash Context` (only saves 3 fields: joinKey, ctx, cvRewriteText)
- `linkedinKey` also dropped at same point

### Fix 1: Restore Context (LinkedIn) updated
- Node ID: `restore-ctx-linkedin`
- Added: `linkedinKey` from `$('Capture LinkedIn')`, `schema` from `$('Context (carry)')`
- Result: Validate - Has Schema and OrderId now routes to TRUE (#2947)

### Problem 2: orderId Missing → Validate - Has OrderId FALSE
- List Documents for Order (Postgres) returns only `kind` + `storage_key` columns
- All upstream context (orderId, ctx, schema) replaced by DB rows
- Shape Documents Map couldn't recover orderId from upstream references

### Fix 2: Shape Documents Map cascading fallbacks
- Node ID: `ae58cc77`
- Added cascading upstream reference: `$('One Day Delivery')` → `$('Editable Word')` → `$('Restore Context (LinkedIn)')`
- Explicitly sets `orderId` and `schema` after spreads as safety net
- Previous attempt `$('Validate - Has Schema and OrderId')` silently failed in Code node (likely IF node multi-output reference issue)
- Result: orderId now present, Validate - Has OrderId routes to TRUE (#2951)

### Problem 3: Trigger Email Workflow 503
- n8n Cloud resource exhaustion after 111 nodes / 4 min processing
- Email workflow webhook returns 503 Service Unavailable

### Fix 3: Wait node + retry logic
- **Added node:** `Wait Before Email` (id: `wait-before-email`, type: `n8n-nodes-base.wait` v1.1)
  - 10-second delay (resume: timeInterval)
  - Position: [21488, 352]
- **Updated node:** `Trigger Email Workflow` (id: `1cb904e7`)
  - `retryOnFail: true`, `maxTries: 3`, `waitBetweenTries: 5000ms`
- **Connection chain:** `Execute a SQL query → Wait Before Email → Trigger Email Workflow`
- Total resilience window: ~25 seconds

### Test Results
| Execution | Status | Nodes | Key Result |
|-----------|--------|-------|------------|
| #2945 | SUCCESS | 110/110 | Validate - Has Schema FALSE (schema missing) |
| #2947 | SUCCESS | 110/110 | Schema fixed ✅, but orderId missing at Shape Documents Map |
| #2949 | SUCCESS | 110/110 | $('Validate...') ref silently failed, orderId still missing |
| **#2951** | **SUCCESS** | **111/111** | **Full pipeline PASS. orderId present. Mark Order Done ✅. Email 503.** |
| #2953 | CRASHED | 0/0 | Platform crash (n8n Cloud issue, not code-related) |

### Key Discoveries
- **n8n Code node `$()` references to IF nodes:** May silently fail when referencing multi-output IF nodes. Use non-IF upstream nodes instead.
- **Cascading fallback pattern:** `try { $('A') } catch { try { $('B') } catch { $('C') } }` is reliable for context recovery.
- **Wait node for 503 resilience:** Giving n8n Cloud 10s after heavy processing prevents resource exhaustion 503 on self-calls.

---

## LinkedIn Addon Fixes + Test (Session 23, COMPLETE)

### Session: 2026-02-10

**Goal:** Fix LinkedIn addon failures from execution #2935, re-test.

#### Problems Found (Execution #2935 — Executive + LinkedIn, ERROR)
1. **LI Build Sections1**: `responses.values` entries had `type: "system"/"user"` but MISSING `role` field. Only 3 input tokens sent (empty prompt). AI returned nonsense.
2. **Capture LinkedIn**: After OpenAI node, `$json` only contains AI response — all `$json.orderId` fallbacks returned empty.
3. **Postgres - Add Doc(linkedin)**: UUID cast error from empty orderId + retryOnFail causing 3 wasted retries (~57s).

#### Fixes Applied (3 operations)
| # | Node | ID | Fix |
|---|------|----|-----|
| 1 | LI Build Sections1 | `498c3852` | Added `role` field to responses.values: `{role: "system", type: "text", content: "..."}` |
| 2 | Capture LinkedIn | `37622966` | Changed orderId to `$('LinkedIn Optimization1').first().json.orderId` (upstream IF node passes all data) |
| 3 | Postgres - Add Doc(linkedin) | `8960e374` | Added `onError: continueRegularOutput`, set `retryOnFail: false` |

#### Key Discovery: OpenAI Responses API `responses.values` Format
```json
// WRONG (missing role → 3 input tokens, empty prompt)
{"type": "system", "content": "..."}

// CORRECT (role + type required)
{"role": "system", "type": "text", "content": "..."}
```

#### Test Results
| Execution | Package | Nodes | Status | Duration |
|-----------|---------|-------|--------|----------|
| #2935 | Executive + LinkedIn | — | ERROR | 230s |
| **#2938** | **Executive + LinkedIn** | **99/99** | **SUCCESS** | **249s** |

#### LinkedIn Path Verification (Execution #2938)
| Node | Status | Key Data |
|------|--------|----------|
| LinkedIn Optimization1 (IF) | ✅ | Routed to TRUE (linkedin addon detected) |
| LI Build Sections1 | ✅ | 1,060 input tokens, 709 output tokens, gpt-4o |
| Capture LinkedIn | ✅ | orderId, joinKey, linkedinKey, ctx all populated |
| Validate & Clean2 | ✅ | liNeedsRepair: false, binary linkedin.json created |
| Upload LinkedIn to Supabase | ✅ | Key + Id returned |
| Postgres - Add Doc(linkedin) | ✅ | {success: true} |

---

## Batch 26: modelId Fix + File Type Routing Fix (COMPLETE)

### Session: 2026-02-10

**Goal:** Fix WorkflowHasIssuesError caused by missing modelId on AI nodes, then fix .txt file routing.

#### Problem 1: AI nodes missing modelId
- n8n Cloud updated validation to REQUIRE explicit `modelId` on OpenAI/Anthropic nodes
- Previously defaulted silently; now shows red triangle "parameter 'Model' is required"
- 11 of 12 AI nodes had no modelId set (only LI Build Sections1 had gpt-4o)
- This was the root cause of WorkflowHasIssuesError blocking ALL execution

#### Fix: Set modelId on all 12 AI nodes
| # | Node | Model |
|---|------|-------|
| 1 | Rewrite CV | gpt-4o-mini |
| 2 | Rewrite CV1 | gpt-4o |
| 3 | Starter - Proofread CV | gpt-4o |
| 4 | Standard - Proofread CV | gpt-4o |
| 5 | Cover Letter - Generate | gpt-4o |
| 6 | Premium - CV Rewrite (Claude Sonnet) | claude-sonnet-4-20250514 |
| 7 | Executive - CV Rewrite (Claude Opus) | claude-opus-4-1-20250805 |
| 8 | Executive - Format CV Layout | claude-opus-4-1-20250805 |
| 9 | Cover Letter Rewrite | claude-sonnet-4-20250514 |
| 10 | Cover Letter Rewrite1 | claude-sonnet-4-20250514 |
| 11 | Cover Letter Rewrite2 | claude-opus-4-1-20250805 |
| 12 | LI Build Sections1 | gpt-4o (already set) |

Format: `{"__rl": true, "value": "model-id", "mode": "list", "cachedResultName": "Display Name"}`
Update format: `{updates: {"parameters.modelId": {...}}}` (NOT `{parameters: {modelId: ...}}`)

#### Problem 2: File Type Routing FALSE branch disconnected
- .txt files route to FALSE branch of File Type Routing IF node
- FALSE branch connected to joinKey1 (skipping Extract from File1 → no cvText)
- Guard Node1 failed: "Missing cvText"
- Historical executions #2906/#2900 confirmed BOTH branches should go to Extract from File1
- `addConnection` blocked by duplicate detection (TRUE already connects to same target)

#### Fix: rewireConnection
- Used `rewireConnection` operation: FALSE branch from joinKey1 → Extract from File1
- This modifies the existing connection instead of adding a new one, bypassing duplicate detection

#### Problem 3: Google Docs OAuth2 expired
- Token revoked/expired — user re-authenticated in n8n UI

#### Test Results
| Execution | Package | Nodes | Status | Duration | Key Verification |
|-----------|---------|-------|--------|----------|-----------------|
| #2926 | Starter | 58 | ERROR | 125s | Google Docs OAuth2 expired (pipeline worked up to that point) |
| #2929 | Starter | 90/90 | **SUCCESS** | 137s | Full end-to-end: CV rewrite + Docs + Upload + Email |
| #2932 | Executive | 104/104 | **SUCCESS** | 166s | Full pipeline: Opus CV + CL + Docs + Upload + Email |

#### Key Discoveries
- `modelId` is now REQUIRED by n8n Cloud (was silently defaulted before)
- `rewireConnection` is the solution when both IF branches need to go to the same target node
- `addConnection` blocks "duplicate" connections to same target even from different output indices

---

## Batch 25: CloudConvert Disable + Connection Fixes (COMPLETE)

### Session: 2026-02-09

**Goal:** Fix WorkflowHasIssuesError blocking all execution.

#### Problems Fixed
1. **CloudConvert community node** not installed on n8n Cloud → runtime error blocking ALL nodes
2. **LinkedIn connection types** using "0" instead of "main" → broken connections
3. **IF node routing issues** from earlier batch changes

#### Fixes Applied
| # | Fix | Details |
|---|-----|---------|
| 1 | Disabled CloudConvert node | Community node not available on n8n Cloud |
| 2 | Fixed Validate & Clean2 connections | Changed type "0" → "main" |
| 3 | Fixed Upload LinkedIn to Supabase connections | Changed type "0" → "main" |

**Note:** WorkflowHasIssuesError persisted after these fixes — root cause was missing modelId (fixed in Batch 26).

---

## Batch 21: Cover Letter Storage Path & Email Download Fix (COMPLETE)

### Session: 2026-02-05

**Goal:** Fix cover letter not attaching to email due to storage path mismatches.

#### Problem Chain Discovered
1. **Execution #2889:** Cover letter 404 error — storage_key had `cvstore/` prefix but was being appended to wrong bucket
2. **Execution #2894:** "Bucket not found" — `careeredge-orders` bucket doesn't exist in Supabase (only `cvstore`)
3. **Execution #2898:** Cover letter download 404 — `$json.docs.cover_letter` was undefined (HTTP response replaced original payload)

#### Root Cause Analysis
- **Supabase bucket:** Only `cvstore` bucket exists (CV uploads use it, cover letter should too)
- **Storage key format:** Must include bucket name: `cvstore/orders/{orderId}/cover_letter.pdf`
- **Email download URL:** Uses `$json.docs.cover_letter` but after "Download Rewritten CV" runs, `$json` contains HTTP response, not original payload

#### Fixes Applied

**Main Workflow (`40hfyY9Px6peWs3wWFkEY`):**
| Node | Fix |
|------|-----|
| Upload Cover Letter to Supabase | URL uses `cvstore` bucket (the only existing bucket) |
| Postgres - Add Doc(cover)1 | Storage key: `cvstore/orders/{orderId}/cover_letter.pdf` (includes bucket) |

**Email Workflow (`IS4rAklMjfCiQnV5`):**
| Node | Fix |
|------|-----|
| Download Cover Letter | URL changed from `$json.docs.cover_letter` to `$node['Prepare Email Payload'].json.docs.cover_letter` |

#### Test Results
| Execution | Status | Notes |
|-----------|--------|-------|
| #2894 | Processing ❌ | "Bucket not found" — tried careeredge-orders which doesn't exist |
| #2897 | Processing ✅ | Cover letter upload successful with cvstore bucket |
| #2898 | Email PARTIAL | CV attached ✅, Cover letter 404 (URL empty due to $json reference issue) |

**Status:** All fixes applied. Ready for final test to verify both attachments arrive.

---

## Batch 20: Cover Letter Upload Rewiring (COMPLETE)

### Session: 2026-02-04

**Goal:** Rewire cover letter upload from AWS S3 to Supabase HTTP (matching CV upload pattern).

#### Problem
- Cover letter was uploading to AWS S3 but email workflow downloads from Supabase
- "Upload CoverLetter1" was an AWS S3 node
- "Upload Cover Letter to Supabase" HTTP node existed but wasn't connected

#### Fix Applied: Main Workflow (`40hfyY9Px6peWs3wWFkEY`)
| Change | Details |
|--------|---------|
| Removed "Upload CoverLetter1" | AWS S3 node deleted (node count 138 → 137) |
| Connected Supabase upload | Move Binary Data → Upload Cover Letter to Supabase → Reattach Context2 |
| Cleaned stale connections | Removed orphaned "0" type connections |

**Status:** COMPLETE — Led to Batch 21 when bucket mismatch was discovered.

---

## Batch 24: LinkedIn Optimization Addon Fix (COMPLETE)

### Session: 2026-02-09

**Goal:** Fix completely broken LinkedIn addon — 6 issues across 5 nodes preventing any LinkedIn profile generation.

#### Problems Found
1. **LI Build Sections1** (`498c3852`): `responses.values: [{}]` — empty prompt, AI gets no input
2. **Capture LinkedIn** (`37622966`): Only re-checks addon flag, doesn't extract AI response text
3. **Validate & Clean2** (`72281b57`): Early `return` means validation never runs; also `$json.linkedin_profile` doesn't exist
4. **Upload LinkedIn** (`c906320f`): AWS S3 node, but all downloads use Supabase — file inaccessible
5. **No anti-Markdown rules** in prompt (covered by Issue 1 fix)
6. **Postgres storage key** (`8960e374`): Fallback `orders/{id}/linkedin.txt` (no bucket prefix, wrong extension)

#### Fixes Applied (8 operations + 1 followup)

| # | Type | Node | Fix |
|---|------|------|-----|
| 0 | updateNode | LI Build Sections1 (`498c3852`) | System+user prompts: LinkedIn strategist, JSON schema, character limits, no-Markdown |
| 1 | updateNode | Capture LinkedIn (`37622966`) | Extract linkedinProfileText, orderId, joinKey, linkedinKey, ctx from Responses API |
| 2 | updateNode | Validate & Clean2 (`72281b57`) | Full rewrite: parse JSON, validate placeholders/limits, create binary AFTER validation |
| 3 | removeNode | Upload LinkedIn (`c906320f`) | Removed AWS S3 node |
| 4 | addNode | Upload LinkedIn to Supabase (`upload-li-supabase`) | HTTP POST to Supabase, same pattern as cover letter upload |
| 5 | addConnection | Validate & Clean2 → Upload LinkedIn to Supabase | Wired |
| 6 | addConnection | Upload LinkedIn to Supabase → Postgres - Add Doc(linkedin) | Wired |
| 7 | updateNode | Postgres - Add Doc(linkedin) (`8960e374`) | Storage key: `cvstore/orders/{id}/linkedin.json` |
| 8 | updateNode | Capture LinkedIn (followup) | Fixed `?.` → ternary (n8n doesn't support optional chaining) |

#### LinkedIn Path Flow (after fix)
```
LinkedIn Optimization1 [TRUE] → LI Build Sections1 (GPT-4o, system+user prompts)
  → Capture LinkedIn (extract text, orderId, linkedinKey, ctx)
  → Validate & Clean2 (parse JSON, validate, create binary)
  → Upload LinkedIn to Supabase (HTTP POST cvstore/orders/{id}/linkedin.json)
  → Postgres - Add Doc(linkedin) (INSERT cvstore/orders/{id}/linkedin.json)
  → Editable Word [next addon check]
```

#### Validation Results
- 10 errors — ALL pre-existing (not LinkedIn-related)
- 0 new errors introduced
- Warnings reduced: 97 → 94 (fixed 3 optional chaining warnings in Capture LinkedIn)

**Status:** All fixes applied. Ready for test order with `addons: ["linkedinoptimize"]`.

---

## Batch 23: CV Formatting Fix (COMPLETE)

### Session: 2026-02-08

**Goal:** Fix AI prompts that output Markdown syntax (`**` for bold headers) which Google Docs renders as literal text in PDFs.

#### Problem
- AI outputs Markdown syntax (`**` for bold headers)
- Google Docs renders `**` as literal text, not formatting
- Result: CVs show `**PROFESSIONAL SUMMARY**` instead of clean headers
- User feedback: Unprofessional appearance

#### Root Cause
- Starter prompt: "Use clear section headings" — AI defaults to Markdown
- Standard prompt: explicitly says "Bold section headers" — triggers `**bold**`
- Premium/Executive prompts: no formatting instructions — AI defaults to Markdown
- Proofread/Format/Cover Letter nodes: no anti-Markdown instructions

#### Fixes Applied (11 nodes)

**CV Rewrite Nodes:**
| # | Node | ID | Fix |
|---|------|----|-----|
| 1 | Rewrite CV (Starter) | `d9e754f1` | ALL CAPS headers, explicit no-Markdown |
| 2 | Rewrite CV1 (Standard) | `3cbc6655` | "Bold section headers" → ALL CAPS + no-Markdown |
| 3 | Premium CV Rewrite (Sonnet) | `aaf4fa34` | Added FORMATTING section |
| 4 | Executive CV Rewrite (Opus) | `2245d030` | Added FORMATTING section |

**Proofread/Format Nodes:**
| # | Node | ID | Fix |
|---|------|----|-----|
| 5 | Starter - Proofread CV | `35bf08e4` | "Preserve ALL CAPS, no Markdown" |
| 6 | Standard - Proofread CV | `df4bf557` | "Preserve ALL CAPS, no Markdown" |
| 7 | Executive - Format CV Layout | `e16e2f32` | ALL CAPS + no-Markdown rules |

**Cover Letter Nodes:**
| # | Node | ID | Fix |
|---|------|----|-----|
| 8 | Cover Letter Rewrite (Standard) | `b6a6f5f5` | no-Markdown rules |
| 9 | Cover Letter Rewrite1 (Premium) | `dde6a403` | no-Markdown rules |
| 10 | Cover Letter Rewrite2 (Executive) | `f115fc99` | no-Markdown rules |
| 11 | Cover Letter - Generate (Addon) | `ec45e397` | no-Markdown rules |

**Status:** All fixes applied. Ready for testing.

---

## Batch 19: CV Prompt Fix & Cover Letter Addon Fixes (COMPLETE)

### Session: 2026-02-03

**Goal:** Fix CV rewrite prompt to preserve contact information and specific tools. Fix cover letter addon flow that was silently failing.

#### Problem 1: CV Rewrite Missing Contact Info & Tools
- Previous CV rewrites stripped contact information (name, email, phone, LinkedIn)
- Specific tools like Ahrefs, Moz, HubSpot, Marketo were being dropped
- Quality rating was 6.5/10

#### Fix Applied: CV Rewrite Prompt Enhancement
- Added "CONTACT INFORMATION (CRITICAL - MUST PRESERVE)" section to system prompt
- Added "SKILLS & TOOLS (ATS OPTIMIZATION)" section to system prompt
- Updated user message to include preservation instructions
- **Result:** Quality improved to 8.5/10 (verified in execution #2870)

#### Problem 2: Cover Letter Addon Not Triggering
- Orders with `extracoverletter` addon were not generating cover letters
- Root cause: ctx object (containing addons array) was dropped at "Prepare Document Row" node
- "Normalize Payload" couldn't find addons → `hasExtraCoverLetter: false` → cover letter skipped

#### Problem 3: Cover Letter Generate Node Empty Prompt
- After ctx fix, cover letter flow triggered but "Cover Letter - Generate" had empty `responses.values: [{}]`
- GPT returned "It looks like your message is incomplete" (7 input tokens)
- Same Responses API issue as CV Rewrite had earlier

#### Fixes Applied (4 nodes)
| # | Node | ID | Fix |
|---|------|----|-----|
| 1 | Prepare Document Row | `84c74363` | Added `ctx` passthrough (was only outputting docRow, orderId) |
| 2 | Cover Letter - Generate | `ec45e397` | Added system + user prompts with Responses API format |
| 3 | Capture Cover Letter | `eb5dcfaa` | Updated to extract from `output[0].content[0].text` (Responses API) |
| 4 | Write Cover Letter Content | `25c0ee39` | Updated to check Responses API format (`output[0].content[0].text`) |

#### Test Results
| Execution | Status | Notes |
|-----------|--------|-------|
| #2870 | CV ✅ CL ❌ | CV 8.5/10, cover letter skipped (ctx passthrough bug) |
| #2873 | CV ✅ CL ❌ | Cover letter flow triggered (ctx fix worked), but Write CL failed (empty text) |

**Status:** All fixes applied. Next test should complete full cover letter flow.

---

## Batch 15: Premium Pipeline End-to-End Testing & Cover Letter Document Fix (COMPLETE)

### Session: 2026-01-30

**Goal:** Test Premium package order end-to-end; fix cover letter document not being saved for included packages; verify email delivery.

#### Problem
Premium package includes a cover letter (generated by Cover Letter Rewrite1), but the cover letter document was never created as a PDF, uploaded to S3, or tracked in the database. The "Extra Cover Letter" addon path was the ONLY code path that created a cover letter document — included cover letters were silently dropped.

Additionally, the Email Delivery workflow crashed with a binary attachment error because `Reattach Email Meta` lost binary data through the merge chain.

#### Root Cause Chain (7 test iterations: executions #2818-#2827)
1. **Stash Context** reconstructed `ctx` without `coverLetterText` — field lost
2. **Normalize Payload** couldn't find `coverLetterText` from any source — Extra Cover Letter IF always FALSE
3. **Write Cover Letter Content** called `$items('Cover Letter - Generate', 0)` which throws when node was skipped
4. **Capture Cover Letter** `joinKey` expression couldn't find `orderId` from available sources
5. **Google Docs pipeline** (Create → Write → Download → Move) strips all context — only passes doc metadata
6. **Upload CoverLetter1** and **Reattach Context2** couldn't find `orderId` after Google Docs pipeline
7. **Reattach Context1** had no `joinKey` field — Merge by Key output 0 items (nothing to merge on)

#### Fixes Applied (11 nodes across 2 workflows)

**Main Workflow (`40hfyY9Px6peWs3wWFkEY`):**
| # | Node | ID | Fix |
|---|------|----|-----|
| 1 | Capture Rewrite1 | `dd8975e5` | Added `coverLetterText` extraction (OpenAI format) |
| 2 | Capture Rewrite2 | `f05556f7` | Added `coverLetterText` extraction (Anthropic format) |
| 3 | Capture Rewrite3 | `fb682146` | Added `coverLetterText` extraction (Anthropic format) |
| 4 | Stash Context | `a2bbc558` | Added `coverLetterText` to ctx object construction |
| 5 | Normalize Payload | `e9e01295` | Added `$node['Capture Rewrite1/2/3']` fallback references for `coverLetterText` |
| 6 | Write Cover Letter Content | `25c0ee39` | Wrapped `$items('Cover Letter - Generate')` in try-catch; try Capture Cover Letter first |
| 7 | Capture Cover Letter | `eb5dcfaa` | Added `$json.orderId`, `$json.docRow.orderId`, `$items("Extra Cover Letter")` fallbacks for joinKey |
| 8 | Upload CoverLetter1 | `09321213` | Added `$node['Capture Cover Letter'].json.joinKey` reference for S3 key |
| 9 | Reattach Context2 | `aebbdf44` | Added `$node['Capture Cover Letter']` references for joinKey/orderId |
| 10 | Reattach Context1 | `f4e185bd` | Added `joinKey` field derivation from orderId/docRow.orderId/ctx.orderId |

**Email Delivery Workflow (`IS4rAklMjfCiQnV5`):**
| # | Node | ID | Fix |
|---|------|----|-----|
| 11 | Reattach Email Meta | `85369918` | Pull binary from `$node["Download Rewritten CV"]` and `$node["Download a file"]` by name instead of `$input` |

#### Cover Letter Document Architecture (new path)
```
Extra Cover Letter [TRUE] → Need CL Generation? → [FALSE: has text] → Capture Cover Letter
  → Create Cover Letter Doc → Write Cover Letter Content → Download Cover Letter PDF
  → Move Binary Data → Upload CoverLetter1 → Reattach Context2 → Merge by Key [input 1]

Reattach Context1 [with joinKey] → Merge by Key [input 0]
Merge by Key (combine by joinKey) → Set joinKey → Shape Documents Map → Assemble Response
  → Execute a SQL query → Trigger Email Workflow
```

#### Test Results
| Execution | Status | Issues Found |
|-----------|--------|--------------|
| 2818 | ERROR | Non-UUID orderId filtered by "If UUID" node |
| 2820 | PARTIAL | coverLetterText empty at Extra Cover Letter (Stash Context + Normalize Payload) |
| 2822 | ERROR | "Node 'Cover Letter - Generate' hasn't been executed" (Write Cover Letter Content) |
| 2824 | PARTIAL | S3 key `orders//cover_letter.pdf` (missing orderId), Merge by Key 0 items |
| 2825 | PARTIAL | S3 key still missing orderId (Google Docs strips context) |
| 2826 | PARTIAL | S3 key fixed, Reattach Context2 fixed, but Reattach Context1 missing joinKey |
| **2827** | **SUCCESS** | **Full pipeline: CV + Cover Letter + Email. 104 nodes, 167s** |

#### Known Issue — FIXED
- ~~**Email Delivery "If Email Sent Ok"** routes to FALSE despite Gmail success~~ → FIXED (fix #9, execution #2836)

---

## Batch 16: Cross-Tier Testing & CV PDF + Email Delivery Fixes (COMPLETE)

### Sessions: 2026-01-31 to 2026-02-01

**Goal:** Test all 4 package tiers end-to-end. Fix CV PDF empty content. Fix Email Delivery false negative. Fix Capture Rewrite (Starter) Responses API extraction.

#### Problems Found & Fixed

**Problem 1: Package tier not reaching Switch node**
- `Build ctx` mapped `ctx.package` from `$json.package` but webhook sends `packageTier`
- `Switch` catch-all condition used `={{ true }}` (boolean) with `typeValidation: "strict"` → type error
- `Normalise & Validate` didn't parse the stringified `ctx` JSON to recover package value

**Problem 2: CV Rewrite nodes using wrong API format**
- Rewrite CV (Starter) and Rewrite CV1 (Standard) used `messages` property (Chat Completions)
- OpenAI node v2.1 defaults to Responses API → `messages` ignored → 7 input tokens (empty)
- Same bug fixed for Proofread CV nodes in Batch 14b, but Rewrite nodes were missed

**Problem 3: CV PDF document empty ("CV rewrite was empty (upstream error)")**
- `Stash Context` extracted `rewrittenCVText` using Chat Completions format (`$json.message.content`)
- After Responses API conversion, output is `$json.output[0].content[0].text` — not matched
- `Capture Rewrite1` correctly extracts `cvRewriteText` as top-level field, but Stash Context didn't check it
- `Google Docs - Write Content` used `$json.cvRewriteText` but Google Docs create replaces `$json` with drive metadata

**Problem 4: Email Delivery "If Email Sent Ok" false negative**
- Condition: `=={{ $json.statusCode ? $json.statusCode < 400 : ($json.success ?? true) }}`
- `==` prefix (instead of `=`) puts literal `=` before `{{ }}`, converting boolean to string `"=true"`
- With `typeValidation: "strict"`, string is not boolean → always FALSE
- `Mark Sent` and `Retry or Dead Letter` used `$json.jobId` but Gmail replaces `$json` with `{ id, threadId, labelIds }`

#### Fixes Applied (11 nodes across 2 workflows)

**Main Workflow (`40hfyY9Px6peWs3wWFkEY`):**
| # | Node | ID | Fix |
|---|------|----|-----|
| 1 | Build ctx | `e88c0ab6` | Added `packageTier` lookup from webhook body |
| 2 | Switch | `0366e8b2` | Fixed catch-all from `={{ true }}` (boolean) to `={{ 'true' }}` (string) |
| 3 | Normalise & Validate | `3010f2fd` | Added ctx JSON string parsing fallback for package, name, email, etc. |
| 4 | Rewrite CV (Starter) | `d9e754f1` | Converted `messages` → `responses.values` (Responses API format) |
| 5 | Rewrite CV1 (Standard) | `3cbc6655` | Converted `messages` → `responses.values` (Responses API format) |
| 6 | Stash Context | `a2bbc558` | Added `$json.cvRewriteText` + Responses API `output[0].content[0].text` fallback |
| 7 | Google Docs - Write Content | `5354860c` | Added `$node['Stash Context']` reference (Google Docs create strips $json) |
| 8 | Capture Rewrite (Starter) | `39e44a7b` | Rewrote to use Responses API format (`$json.output[0].content[0].text`) + `$('Context (carry)')` refs |

**Email Delivery Workflow (`IS4rAklMjfCiQnV5`):**
| # | Node | ID | Fix |
|---|------|----|-----|
| 9 | If Email Sent Ok | `ff589bf3` | Changed `=={{ ... }}` → `={{ !!$json.id }}` (Gmail returns id on success) |
| 10 | Mark Sent | `3b6ca0de` | Parameterized query, `$node['Reattach Email Meta'].json.jobId` |
| 11 | Retry or Dead Letter | `24bf7569` | Parameterized query, upstream node reference for jobId |

#### Test Results
| Execution | Tier | Status | Notes |
|-----------|------|--------|-------|
| 2829 | Standard | ERROR | Package empty at Switch → catch-all (Build ctx + Switch bugs) |
| 2830 | Standard | ERROR | Package empty after Build ctx fix (Normalise & Validate ctx parsing) |
| 2831 | Standard | PARTIAL | Pipeline OK but Rewrite CV1 = 7 tokens (Responses API bug) |
| 2833 | Standard | PARTIAL | CV rewrite 858→616 tokens ✅ but PDF empty (Stash Context bug) |
| **2835** | **Standard** | **SUCCESS** | **CV PDF populated, email delivered, Mark Sent ✅. 103 nodes, 148s** |
| 2836 | Email | **SUCCESS** | **First successful email delivery — If Email Sent Ok → TRUE → Mark Sent (status: "sent")** |
| **2837** | **Executive** | **SUCCESS** | **4-step AI chain (Opus→CL→Proofread→Layout), email delivered. 91 nodes, 195s** |
| 2838 | Email | **SUCCESS** | Executive email delivery ✅ |
| 2839 | Starter | PARTIAL | Rewrite CV ✅ but Capture Rewrite cvRewriteText empty (old Chat Completions extraction) |
| 2841 | Starter | CRASHED | n8n cloud crash (0 nodes executed, Unknown error — platform issue) |
| **2842** | **Starter** | **SUCCESS** | **CV only, no cover letter (correct), email delivered. 91 nodes, 148s** |
| 2843 | Email | **SUCCESS** | Starter email delivery ✅ |

#### Quality Assessment by Tier
| Tier | CV Rating | CL Rating | Model | Duration | Notes |
|------|-----------|-----------|-------|----------|-------|
| Starter (€4.99) | 7/10 | N/A | GPT-4o-mini | 148s | Good structure, keyword targeting. Missing languages section, no contact header. |
| Standard (€7.99) | 7/10 | 8/10 | GPT-4o-mini + Claude Sonnet 4 | 148s | Job-tailored summary, strong verbs. Cover letter professional with quantified achievements. |
| Premium (€14.99) | 8/10 | 8/10 | Claude Sonnet 4 | 167s | Nuanced phrasing, better context awareness. |
| Executive (€24.99) | 9/10 | 9/10 | Claude Opus 4.1 | 195s | Sophisticated language, strategic positioning, layout guidance. |

---

## Batch 14c: Shape Documents Map Fix (COMPLETE)

### Session: 2026-01-29

**Goal:** Fix Shape Documents Map producing empty keys/urls/documents despite valid document data in upstream nodes.

#### Root Cause
Shape Documents Map code only handled `$json.docs[]` array input, but actual inputs are:
- **List Documents for Order** (Postgres): returns separate items with `{kind, storage_key}` — NOT a `docs[]` array
- **No-addon path**: Validate - Has Schema and OrderId fails (no `schema` field), bypasses List Documents, passes `docRow` object directly
- **URL generation**: Used placeholder `<YOUR-PROJECT-REF>` instead of real Supabase URL

#### Fix Applied (1 operation)
| Node | ID | Fix |
|------|----|-----|
| Shape Documents Map | `ae58cc77` | Rewrote to handle 4 input formats: (1) `$input.all()` items with `{kind, storage_key}`, (2) `$json.docs[]` array, (3) `$json.docRow` with kind inference from storage_key path, (4) flat key fields. Hardcoded Supabase URL `xidmgkcqltvknvtuoeoh.supabase.co` |

---

## Batch 14b: Execution #2812 Post-Test Fixes (COMPLETE)

### Session: 2026-01-28

**Goal:** Fix issues discovered in Premium test execution #2812: Proofread CV still 7 input tokens (wrong API format), SQL NOT NULL constraint on subject/body_html.

#### Root Cause Analysis
1. **Proofread CV**: OpenAI node v2.1 defaults `resource: "text"` (Responses API) which uses `responses` property. Batch 14's `messages.values` fix was completely ignored — the node never looked at `messages`.
2. **Execute a SQL query**: `email_jobs` table requires NOT NULL `subject` and `body_html`. Assemble Response doesn't produce these fields. `NULLIF('','')` → NULL → constraint violation.
3. **Frontend 524**: Cloudflare timeout between Vercel and n8n cloud. Transient network issue, not n8n-fixable.

#### Fixes Applied (3 operations)
| # | Node | ID | Fix |
|---|------|----|-----|
| 1 | Starter - Proofread CV | `35bf08e4` | Set `resource: "text"`, `operation: "response"`, `responses.values` with type/role/content, `.first().json` |
| 2 | Standard - Proofread CV | `df4bf557` | Same Responses API format fix |
| 3 | Execute a SQL query | `31ce791b` | Added subject fallback construction, body_html template, full payload object |

#### Key Discovery: OpenAI Node v2.1 Dual API Format
- `messages` property → `resource: "conversation"`, `operation: "create"` (Chat Completions API)
- `responses` property → `resource: "text"`, `operation: "response"` (Responses API, **DEFAULT**)
- Nodes without explicit `resource` use Responses API by default

---

## Batch 14: Execution #2811 Analysis & Fixes (COMPLETE)

### Session: 2026-01-27

**Goal:** Fix issues discovered in Premium test execution #2811: Proofread CV empty prompts (OpenAI 2-message requirement), cvRewriteText double `=`, disconnected Assemble Response → email flow, empty Assemble Response fields.

#### Fixes Applied (5 operations, atomic)
| # | Node | Fix |
|---|------|-----|
| 1 | Starter - Proofread CV (`35bf08e4`) | Split single message to system + user messages for OpenAI node |
| 2 | Standard - Proofread CV (`df4bf557`) | Split single message to system + user messages for OpenAI node |
| 3 | cvRewriteText (final) (`021894d0`) | Fixed `=={{` → `={{`, removed empty `name:"",value:""` assignment |
| 4 | Connection (new) | Added: Assemble Response → Execute a SQL query (was disconnected) |
| 5 | Assemble Response (`f798ff3f`) | Fixed `orderId ` trailing space, refs to `$('Context (carry)').first().json.*` + `$('Shape Documents Map').first().json.*` |

#### Deferred: Frontend confirmation page slowness
Webhook responds in ~10ms with 202. Slowness is in the Next.js frontend on Vercel, not n8n. Requires separate investigation in CVBuilder repo.

---

## Batch 13: AI Prompt & Capture Node Fixes (COMPLETE)

### Session: 2026-01-27

**Goal:** Fix static prompts in Cover Letter, Proofread, and Format nodes. Fix Capture Rewrite nodes to handle Anthropic/OpenAI output formats. Add Merge by Key error handling.

#### Problem (from test execution #2810)
All Cover Letter Rewrite, Proofread CV, and Format CV Layout nodes had **static prompts** - no `=` prefix, no `{{ }}` expressions. The AI received vague instructions but no actual CV text, job description, or candidate name. Capture Rewrite nodes used `$json.*` which couldn't extract data from Anthropic or OpenAI Responses API output formats.

#### Fixes Applied (10 operations)
1. **Cover Letter Rewrite1** (Premium) - Dynamic prompt with Context (carry) + Premium CV Rewrite refs
2. **Cover Letter Rewrite** (Standard) - Dynamic prompt with Context (carry) + Rewrite CV1 refs
3. **Cover Letter Rewrite2** (Executive) - Dynamic prompt with Context (carry) + Executive CV Rewrite refs
4. **Starter - Proofread CV** - Dynamic prompt referencing Premium CV Rewrite (Anthropic format)
5. **Standard - Proofread CV** - Dynamic prompt referencing Executive CV Rewrite (Anthropic format)
6. **Capture Rewrite1** - joinKey/cvRewriteText/ctx from upstream nodes directly
7. **Capture Rewrite2** - Multi-format AI output extraction (Anthropic + OpenAI Responses)
8. **Capture Rewrite3** - Multi-format AI output extraction
9. **Merge by Key** - Added `onError: continueRegularOutput` for empty input handling
10. **Executive - Format CV Layout** - Dynamic prompt referencing Standard - Proofread CV output

#### Nodes Modified
| Node | ID | Change |
|------|-----|--------|
| Cover Letter Rewrite1 | `dde6a403-d7f1-41c9-9d5d-7addb8cd299b` | Dynamic prompt with `=` + `{{ }}` |
| Cover Letter Rewrite | `b6a6f5f5-f488-4c54-b399-6365b8a05496` | Dynamic prompt with `=` + `{{ }}` |
| Cover Letter Rewrite2 | `f115fc99-e1ea-452e-9ecc-ef09fdbee5d6` | Dynamic prompt with `=` + `{{ }}` |
| Starter - Proofread CV | `35bf08e4-1293-4a3b-9db6-4651aa8fa324` | Dynamic prompt referencing upstream |
| Standard - Proofread CV | `df4bf557-d290-4c3d-9ccf-e0aead973556` | Dynamic prompt referencing upstream |
| Capture Rewrite1 | `dd8975e5-6935-41d2-8254-cddb252ae5b9` | Upstream node references for all 3 fields |
| Capture Rewrite2 | `f05556f7-e910-4f24-87d4-452b31ebb3d1` | Multi-format output extraction |
| Capture Rewrite3 | `fb682146-be44-49b9-b491-90ae5eecd58d` | Multi-format output extraction |
| Merge by Key | `434cc86a-d552-4f72-b194-0d29ed3d0f74` | `onError: continueRegularOutput` |
| Executive - Format CV Layout | `e16e2f32-067d-46d8-9182-a5e794bd4e99` | Dynamic prompt referencing upstream |

---

## Batch 12: Cover Letter Node Reconnection (COMPLETE)

### Session: 2026-01-27

**Goal:** Reconnect Cover Letter Rewrite nodes to Standard, Premium, and Executive tier flows.

#### Problem (from test order #2809)
Cover Letter Rewrite nodes were **ORPHANED** - no input connections. CV Rewrite nodes bypassed cover letter generation entirely.

#### Fix Applied
Used `rewireConnection` operations to redirect CV Rewrite `main` outputs through Cover Letter Rewrite nodes:

| Tier | Before (Broken) | After (Fixed) |
|------|-----------------|---------------|
| Standard | Rewrite CV1 → Capture Rewrite1 | Rewrite CV1 → **Cover Letter Rewrite** → Capture Rewrite1 |
| Premium | Premium CV Rewrite → Capture Rewrite2 | Premium CV Rewrite → **Cover Letter Rewrite1** → Proofread → Capture Rewrite2 |
| Executive | Executive CV Rewrite → Capture Rewrite3 | Executive CV Rewrite → **Cover Letter Rewrite2** → Proofread → Format → Capture Rewrite3 |

#### Verified Flows (from live workflow data)
- **Starter:** Switch → Rewrite CV → Capture Rewrite → cvRewriteText (final) (no cover letter - correct)
- **Standard:** Switch → Rewrite CV1 → Cover Letter Rewrite → Capture Rewrite1 → cvRewriteText (final)
- **Premium:** Switch → Premium CV Rewrite → Cover Letter Rewrite1 → Starter - Proofread CV → Capture Rewrite2 → cvRewriteText (final)
- **Executive:** Switch → Executive CV Rewrite → Cover Letter Rewrite2 → Standard - Proofread CV → Executive - Format CV Layout → Capture Rewrite3 → cvRewriteText (final)

#### Operations Applied
1. `rewireConnection`: Rewrite CV1 main output from Capture Rewrite1 → Cover Letter Rewrite
2. `rewireConnection`: Premium CV Rewrite main output from Capture Rewrite2 → Cover Letter Rewrite1
3. `rewireConnection`: Executive CV Rewrite main output from Capture Rewrite3 → Cover Letter Rewrite2
4. `removeConnection`: Cleaned up 3 erroneous "0" type connections from initial attempt

---

## Batch 11: Supabase Storage & Data Flow Fixes (COMPLETE)

### Session: 2026-01-26

**Goal:** Fix orderId data flow and configure Supabase Storage for file uploads.

#### Issues Diagnosed & Fixed

**1. orderId Lost After Extract from File [FIXED]**
- **Symptom:** `null value in column "order_id" of relation "documents" violates not-null constraint`
- **Root Cause:** Extract from File nodes extract text but don't preserve ctx object
- **Fix:** Updated joinKey1 and Stash Context to reference upstream nodes directly

**2. Supabase Storage Not Configured [FIXED]**
- **Symptom:** `getaddrinfo ENOTFOUND replace_with_supabase_project_ref.supabase.co`
- **Root Cause:** Missing Supabase URL and service role key in Set - Config
- **Fix:** Added credentials: `xidmgkcqltvknvtuoeoh.supabase.co` + service role JWT

**3. HTTP Request _cfg Access [FIXED]**
- **Symptom:** HTTP Request couldn't access `_cfg.supabaseUrl`
- **Root Cause:** Collapse To One1 node doesn't pass `_cfg` through
- **Fix:** Updated HTTP Request to reference `$('Context (carry)').item.json._cfg` directly

#### Nodes Modified
| Node | Change | Node ID |
|------|--------|---------|
| joinKey1 | References `$('Stash Metadata').item.json.ctx` directly | `5d66af5a-b825-429e-8223-e1841764767b` |
| Stash Context | References `$('Context (carry)').item.json` directly | `a2bbc558-8da5-440c-a7b3-035e3c7dd1c0` |
| Set - Config | Added `_cfg.supabaseUrl` and `_cfg.supabaseKey` | `31a26c23-1239-428e-8b61-3990b2ae0893` |
| HTTP Request | References `$('Context (carry)').item.json._cfg` | `154aace9-5adf-4929-8e59-0013e9e4a00b` |

#### Test Results
| Execution | Status | Notes |
|-----------|--------|-------|
| 2809 | PARTIAL | CV ✅, Cover Letter ❌ (led to Batch 12 discovery) |
| 2806 | ERROR | null order_id SQL constraint (fixed) |

---

## Batch 10: Data Flow & Performance Fixes (COMPLETE)

### Session: 2026-01-25

**Goal:** Fix data flow issues causing order processing failures.

#### Issues Fixed
- Build ctx node empty - added field mappings
- Idempotency Check too slow - DISABLED
- Binary data lost after Respond 202 - converted Stash Metadata to Code node
- Set - Config $env access denied - replaced with hardcoded values
- Duplicate Error Handler - DISABLED

---

## Currently Disabled Nodes (for performance/compatibility)

| Node | Node ID | Reason |
|------|---------|--------|
| Rate Limiter | `b0f341bb-668e-4fcc-9dfe-5b9825cd7918` | Was adding 2.2s delay — move to intake workflow |
| Idempotency Check | `b7dad4ba-70b5-45fa-8f0f-14f6d82f66df` | Was adding 2.2s delay — move to intake workflow |
| Error Handler | `0d11e236-af2b-4175-9285-9963c4a43ee5` | Duplicates separate error workflow |
| Ack Payload | `ffc0e75a` | No longer needed (responseMode: onReceived) |

**Note:** 8 respondToWebhook nodes were fully REMOVED in Batch 17 (not just disabled). See Batch 17 section for details.

---

## Completed Batches Summary

### Batch 1: Main Workflow Optimization (COMPLETE)
- Removed AI Orchestrator layer
- Fixed security node positioning
- Consolidated file processing nodes
- Enhanced tier-specific AI prompts
- **Result:** 15 nodes removed, ~$0.02 saved per order

### Batch 2: Workflow Validation & Error Fixes (COMPLETE)
- Fixed 15 IF nodes missing error handling
- Fixed 17 nodes with optional chaining issues
- Validated 5 errors as false positives
- **Result:** Warnings reduced from 229 to 154

### Batch 3: Optional Improvements (COMPLETE)
- Upgraded typeVersions on 37 nodes
- Added error handling to 40+ nodes
- **Result:** Warnings reduced to 94

### Batch 4: Supporting Workflows Validation (COMPLETE)
- Validated and fixed 3 supporting workflows
- Applied 17 total operations

### Batch 5: Database Security Audit (COMPLETE)
- Added 11 payment tracking columns
- Created audit_log table with triggers
- Enabled RLS on all tables

### Batch 6: Stripe Payment Passthrough (COMPLETE)
- Frontend captures payment_intent, customer_id from Stripe
- n8n workflow stores payment data in orders table

### Batch 7: P&L Fixes & Addon Pricing (COMPLETE)
- Fixed Compute Token Cost node references
- Enabled addon pricing in Stripe checkout

### Batch 8: Binary Data Fix (COMPLETE)
- Rewrote Idempotency Check to preserve binary
- Added `includeBinary: true` to 4 Set nodes

### Batch 9: Timeout Fix & Frontend Repairs (COMPLETE)
- Disabled Rate Limiter to fix 524 timeout
- Fixed frontend orderId generation
- Fixed corrupted checkout file

---

## Key Files

| File | Description |
|------|-------------|
| `PLAN.md` | This file - project planning and context |
| `TODO.md` | Current task tracking and checklists |
| `VALIDATION_REPORT.md` | Complete validation documentation |
| `OPTIMIZATION_SUMMARY.md` | Optimization details and testing checklist |

---

## Session Resume Instructions

When starting a new Claude Code session:

### Quick Start
1. Read `PLAN.md` (this file) for project context and current status
2. Read `TODO.md` for actionable tasks and checklists

### IMPORTANT: Workflow Source of Truth
- **DO NOT** use any local JSON workflow files - they are outdated
- The **ONLY** valid workflow is the live n8n workflow (ID: `40hfyY9Px6peWs3wWFkEY`)
- **ALL** workflow changes must be made via MCP connection to n8n cloud
- Use `n8n_get_workflow` to read current state, `n8n_update_partial_workflow` to modify

### MCP Tools Available

**n8n MCP (workflow management):**
- `n8n_list_workflows` - List all workflows
- `n8n_get_workflow` - Get workflow details (use mode='structure' for node list)
- `n8n_validate_workflow` - Validate workflow (use profile='runtime')
- `n8n_update_partial_workflow` - Apply incremental changes
- `n8n_executions` - Check execution history and errors

### Current State Summary
- **Main Workflow ID:** `40hfyY9Px6peWs3wWFkEY`
- **Workflow Status:** Rate Limiter, Idempotency Check, Error Handler DISABLED
- **Response Time:** ~10ms to Respond 202 (was 2.3s+)
- **Database Status:** Migrations executed, payment tracking active
- **Frontend Status:** Fixed and deployed
- **Supabase Storage:** Configured with credentials (`xidmgkcqltvknvtuoeoh.supabase.co`)

### What's Next
1. ~~TEST STANDARD ORDER~~ ✅ PASSED (execution #2835)
2. ~~FIX EMAIL DELIVERY "If Email Sent Ok"~~ ✅ FIXED (execution #2836)
3. ~~TEST EXECUTIVE ORDER~~ ✅ PASSED (execution #2837)
4. ~~TEST STARTER ORDER~~ ✅ PASSED (execution #2842, required Capture Rewrite fix)
5. ~~BATCH 17: 524 CLOUDFLARE TIMEOUT FIX~~ ✅ IMPLEMENTED (execution #2854, 202 in <0.5s)
6. ~~REAL FRONTEND ORDER TEST~~ ✅ PASSED (executions #2861→#2862→#2863)
7. ~~CV PROMPT FIX~~ ✅ VERIFIED (execution #2870, quality 8.5/10)
8. ~~COVER LETTER ADDON FIXES~~ ✅ APPLIED (4 nodes updated)
9. ~~COVER LETTER STORAGE PATH FIX~~ ✅ FIXED (Batch 21 — uploads to cvstore, email downloads correctly)
10. ~~TEST COVER LETTER EMAIL ATTACHMENT~~ ✅ PASSED (#2899→#2900→#2901, BOTH PDFs in email)
11. ~~FIX CV FORMATTING~~ ✅ FIXED (Batch 23 — 11 AI prompt nodes updated)
12. ~~TEST CV FORMATTING~~ ✅ PASSED (Batch 26 — Starter #2929 + Executive #2932)
13. ~~FIX LINKEDIN OPTIMIZATION ADDON~~ ✅ FIXED (Batch 24 — 8 operations, prompt+capture+validation+upload)
14. ~~FIX AI NODE modelId~~ ✅ FIXED (Batch 26 — 12 AI nodes, explicit modelId required)
15. ~~FIX FILE TYPE ROUTING~~ ✅ FIXED (Batch 26 — FALSE branch → Extract from File1)
16. ~~TEST LINKEDIN ADDON~~ ✅ PASSED (execution #2938 — 99/99 nodes, 249s)
17. ~~ADDON TESTING: One Day Delivery~~ ✅ PASSED — Migration 005, priority/sla/due_date DB update working (#2985)
18. ~~ADDON TESTING: LinkedIn Optimization~~ ✅ PASSED — All email paths verified (#2965, #2986)
19. ~~EMAIL WORKFLOW RESTRUCTURE~~ ✅ COMPLETE — 3 Gmail paths (CV Only, CV+CL, CV+CL+LI) with IF gates
20. ~~ADDON TESTING: Editable Word~~ ✅ PASSED — Session 29: CloudConvert replaced with Google Docs API. Starter+DOCX #2988 (2 attachments) + Executive+All #2991 (4 attachments) both verified.
21. **PRODUCTION HARDENING** ← NEXT — Intermittent n8n Cloud crashes (0 nodes, "Unknown error"), intake Forward timeout (30s)
22. **INVESTIGATE FRONTEND** - Confirmation page slowness (Next.js/Vercel, not n8n)
23. **FUTURE: Re-enable Rate Limiter & Idempotency Check** - Move to intake workflow

---

## Batch 17: 524 Cloudflare Timeout Fix (COMPLETE)

### Session: 2026-02-02

### Problem
- Workflow takes 148-195s; Cloudflare times out at ~100s → 524 error
- Webhook has `responseMode: "responseNode"` and Respond 202 fires at ~95ms
- BUT n8n Cloud's gateway holds the HTTP connection until execution completes (~148-195s)
- The Respond 202 node executes successfully but the response never reaches the client

### Root Cause
n8n Cloud's reverse proxy/gateway does NOT honor the Respond to Webhook node mid-execution. It waits for the entire workflow execution to finish before releasing the HTTP connection. Cloudflare's 100s proxy timeout triggers a 524 before the workflow completes.

### Solution Implemented: Two-Workflow Split

```
CLIENT → Intake Workflow (I9MS3uIjhD4kNlbP, 5 nodes, <0.5s)
              ├─ Validate → Respond 202 (or 400 error)
              └─ HTTP Request → Processing Workflow (40hfyY9Px6peWs3wWFkEY, 137 nodes, async)
```

### Changes to Main Workflow (`40hfyY9Px6peWs3wWFkEY`)

| # | Change | Details |
|---|--------|---------|
| 1 | Webhook Intake (`30dad1f6`) | path → `careeredge/process`, responseMode → `onReceived` |
| 2 | Ack Payload (`ffc0e75a`) | Disabled (no longer needed) |
| 3 | Removed 8 respondToWebhook nodes | n8n rejects ANY respondToWebhook nodes with `onReceived` mode, even disabled |
| 4 | Added connection | Ack Payload → Stash Metadata (replaced removed Respond 202 link) |

**Removed nodes:** Respond 202 (`42ef179a`), Respond to Webhook 400 (`a8b20102`), Error Message - No CV (`45d2a4bc`), CV too Large (`a89ebc36`), CV Infected (`83590b2d`), Error Message (`add57c9d`), JD Required (`c55a8073`), Error - Unknown Package Tier (`7fa1eddc`)

### Intake Workflow Created (`I9MS3uIjhD4kNlbP`)

| # | Node | ID | Type | Details |
|---|------|----|------|---------|
| 1 | Webhook | `intake-webhook-001` | webhook | POST `careeredge/submit`, responseMode: responseNode, binary: cv, webhookId: `a1b2c3d4-intake-524-fix` |
| 2 | Validate | `intake-validate-001` | if | AND: orderId, email, binary cv, jobDescription all non-empty |
| 3 | Respond 400 | `intake-respond400-001` | respondToWebhook | Static JSON error, responseCode: 400 |
| 4 | Respond 202 | `intake-respond202-001` | respondToWebhook | Expression body with orderId, responseCode: 202 |
| 5 | Forward to Processing | `intake-forward-001` | httpRequest | POST multipart-form-data to `/webhook/careeredge/process` with 11 form fields + binary cv0, timeout: 30s |

**Connections:** Webhook → Validate; Validate TRUE → [Respond 202 + Forward to Processing in parallel]; Validate FALSE → Respond 400

**Forward body parameters:** orderId, email, packageTier, candidateName, jobDescription, addons, source, payment_intent, customer_id, amount_total, currency (all from `$json.body`), plus formBinaryData `cv` from inputDataFieldName `cv0`

### Key Discoveries During Implementation
1. **webhookId required:** Webhook nodes created via API without a `webhookId` don't register properly — 404 errors
2. **Multipart field naming:** n8n appends an index to multipart file field names (`cv` → `cv0`)
3. **respondToWebhook strict check:** `checkResponseModeConfiguration` rejects ANY respondToWebhook node types with `onReceived`, even disabled ones — must be fully removed

### Test Results
| Execution | Status | Response Time | Notes |
|-----------|--------|---------------|-------|
| 2849 | ERROR | — | Webhook 404 (missing webhookId) |
| 2850 | OK | 219ms | Intake: 400 validation ✅ (missing fields test) |
| 2851 | PARTIAL | 0.41s | 202 ✅ but Forward binary error (cv vs cv0) |
| 2852 | ERROR | — | Processing: binary field `cv` not found |
| 2853 | ERROR | — | Processing: respondToWebhook nodes present (disabled not enough) |
| **2854** | **SUCCESS** | **0.38s** | **202 ✅, processing: 15 nodes, 115s. All data + binary flowing correctly** |

**Note:** Execution #2854 error at Upsert Order was due to test orderId not being a UUID (test data artifact, not structural). Real frontend orders use UUID orderIds.

---

## Future: Scalability Plan (Saved for Later)

### Current Limitations
| Concern | Current State | Risk |
|---------|---------------|------|
| **Execution duration** | 148-195s per order | Long-running |
| **n8n Cloud concurrency** | Limited by plan (typically 1-5 concurrent) | Orders queue/fail |
| **API rate limits** | OpenAI, Anthropic, Google Docs all have limits | Can hit limits |
| **503 during processing** | API calls blocked while workflow busy | Management issues |

### Why 503 Errors Occur
- n8n Cloud instance is busy processing a workflow (154s+ executions)
- API requests to n8n get queued or rejected during processing
- This is expected behavior, not a bug

### Solutions for Production Scale

**1. Upgrade n8n Cloud Plan**
- Higher plans allow more concurrent executions
- Check current plan limits at n8n Cloud dashboard

**2. Queue-Based Architecture (Recommended for High Volume)**
```
Frontend → Intake (202 instant) → Message Queue (SQS/Redis) → Workers
```
- Orders go into a queue immediately
- Multiple worker instances process from queue
- Never lose orders, graceful backpressure

**3. Webhook Retry/Dead Letter**
- If processing fails, have a retry mechanism
- Dead letter queue for failed orders requiring manual review

**4. Split Long Operations**
- Google Docs operations (3-4s each) could be optimized
- Consider pre-generated templates or alternative PDF generation

**5. External Worker Pattern**
- Move heavy AI processing to dedicated workers
- n8n handles orchestration, external services handle compute

### When to Implement
- When order volume exceeds 10-20/hour consistently
- When 503 errors affect customer experience
- Before any marketing push that could spike traffic

---

**Last Updated:** 2026-02-17
**Session 29:** Editable Word addon COMPLETE — CloudConvert replaced with Google Docs API. Both tests PASSED (Starter+DOCX, Executive+All addons). All 4 addons now fully operational.
**Next Action:** Production hardening (intermittent n8n Cloud crashes) + frontend investigation
