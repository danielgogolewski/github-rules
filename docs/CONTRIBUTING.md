# Contributing to ZeroDrift

ZeroDrift is a living standard. Rules evolve as AI agents evolve.

## What we need

**New drift patterns** — Found an AI making a specific mistake not covered by existing rules? Open an issue with:
- What the AI did
- What it should have done
- Which domain (Figma / WordPress / Content / Code)

**New domain rules** — Got a rule set for a new domain (Shopify migration, Next.js deployment, Webflow → code)? Submit a PR with a new `.mdc` file in `rules/`.

**Tested on a new tool** — Verified these rules work with a specific AI agent (Windsurf, Aider, Gemini CLI)? Update the compatibility table in README.

**Better acceptance tests** — Know a more reliable way to verify 1:1 parity than the Photoshop overlay? We want to hear it.

## Rule format

Each rule file should follow this structure:

```markdown
---
description: "One sentence. When to apply. Trigger words."
alwaysApply: false
globs:
  - "relevant/file/patterns"
---

# ZERODRIFT — [Domain] Rules

[One sentence: source → destination contract]

---

## R1 — Rule name

[Code example with ❌ VIOLATION and ✅ 1:1]

---

## Checklist

- [ ] Verifiable item?
- [ ] Another verifiable item?

**Any NO = not done.**
```

## Principles for rule writing

1. **Every rule must have a ❌ violation example** — abstract rules don't train AI well
2. **Every rule must be verifiable** — if you can't check it, it's not a rule
3. **Checklists must be checkboxes** — not prose
4. **No ambiguity** — rules must be executable by AI without human interpretation

## Submitting

1. Fork the repo
2. Create a branch: `rule/domain-name` or `fix/rule-id`
3. PR with: what drift this prevents, what domain, example of violation
