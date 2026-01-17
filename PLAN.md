# Ai-Vitae Project Plan

## Project Overview

**Ai-Vitae** is a CV/resume rewriting service built on n8n with tiered AI processing.

### Current Status (as of 2026-01-11)
- **Main Workflow:** Ai-Vitae Workflow - OPTIMIZED and ready for deployment
- **Workflow ID:** `6CE5jhRjCdkmLVvR-EQlK`
- **Nodes:** 142 (reduced from 157)

---

## Architecture Summary

### Package Tiers
| Tier | AI Model | Focus |
|------|----------|-------|
| Starter | GPT-4o-mini | Clean, ATS-optimized CV |
| Standard | GPT-4o-mini | Enhanced writing quality |
| Premium | Claude Sonnet 4 | Strategic positioning |
| Executive | Claude Opus 4.1 | C-suite presence |

### Add-ons
1. **Extra Cover Letter** - GPT-4o generated cover letter PDF
2. **LinkedIn Optimization** - Optimized LinkedIn profile text
3. **Editable Word** - HTML → DOCX conversion
4. **One Day Delivery** - Priority processing with 24h SLA

### Supporting Workflows
- **Email Delivery Workflow** - Handles all email notifications
- **Error & Alert Monitor** - Error tracking and alerting

---

## Completed Work

### Batch 1: Main Workflow Optimization (COMPLETE)
- [x] Remove AI Orchestrator (redundant layer)
- [x] Remove email redundancy (use Email Delivery workflow)
- [x] Fix security node position (validate before processing)
- [x] Consolidate file processing nodes
- [x] Consolidate normalize nodes
- [x] Consolidate Set/Edit nodes
- [x] Simplify Google Docs flow
- [x] Enhance tier-specific AI prompts
- [x] Verify all 4 addon logic paths
- [x] Create validation report

**Result:** 15 nodes removed, ~$0.02 saved per order, ~2-3s faster processing

---

## Batch 2: [TO BE DEFINED]

### Planned Work
<!-- User to define Batch 2 scope -->

---

## Key Files

| File | Description |
|------|-------------|
| `Ai-Vitae_Workflow_FINAL.json` | Production-ready optimized workflow |
| `VALIDATION_REPORT.md` | Complete validation documentation |
| `OPTIMIZATION_SUMMARY.md` | Optimization details and testing checklist |
| `PLAN.md` | This file - project planning |
| `TODO.md` | Current task tracking |

---

## Session Resume Instructions

When starting a new Claude Code session:
1. Read `PLAN.md` for project context
2. Read `TODO.md` for current tasks
3. Reference `VALIDATION_REPORT.md` for workflow details
4. Check n8n instance for current workflow state

---

**Last Updated:** 2026-01-17
**Session:** Initial planning file creation
