# Ai-Vitae TODO List

## Current Session: 2026-01-17

### Session Context
Resuming work on Batch 2 for n8n workflow development.

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

## Batch 2: [PENDING DEFINITION]

### Tasks
<!-- To be filled in when user provides Batch 2 scope -->

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

### Batch 2 Context Needed
User mentioned "Batch 2" from previous session - awaiting clarification on:
1. What workflows/features are included in Batch 2?
2. What was completed vs remaining?
3. Any specific priorities?

---

**Last Updated:** 2026-01-17
**Next Action:** Define Batch 2 scope with user
