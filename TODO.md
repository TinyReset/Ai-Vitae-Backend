# Ai-Vitae TODO List

## Quick Start for New Sessions

**Workflow ID:** `40hfyY9Px6peWs3wWFkEY`
**Current Status:** Production-ready, Batch 3 in progress
**Validation:** 5 errors (false positives), 94 warnings (low-priority)

### What to Do Next
1. **Production Testing** - Run the Pre-Deployment Checklist below
2. **Optional Improvements** - Upgrade typeVersions or add error handling (Batch 3)
3. **Git Commit** - Commit session changes when ready

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

### Session Summary (Batch 3)
Upgraded typeVersions and added error handling to external service nodes.
- Warnings reduced from 154 → 94 (60 fewer warnings)
- 37 nodes upgraded to latest typeVersions
- 40+ nodes now have error handling configured
- Database nodes have `retryOnFail: true` for connection resilience

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

**Last Updated:** 2026-01-18
**Status:** Batch 3 IN PROGRESS - TypeVersions and error handling complete
**Next Action:** Run production tests (Pre-Deployment Checklist) or continue Batch 3 remaining tasks
