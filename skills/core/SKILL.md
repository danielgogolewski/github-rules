---
name: zerodrift-core
version: "1.1.0"
last_updated: "2026-03-28"
author: "Hyperdata PSA"
description: "ALWAYS use this skill when the user invokes zero drift or exact parity in any context — code, data, environments, deployments, files, design, or synchronization. Trigger words (EN): '1:1', 'zero drift', 'ZeroDrift', 'parity', 'exact match', 'rsync --delete', 'pin versions', 'Roman Pizza Rule', 'same as source', 'no extras', 'no less', 'must be identical', 'exact replica', 'same as prod', 'mirror environment', 'pixel perfect', 'match the design', 'as in Figma', 'Figma to code', 'design token'. Trigger words (PL): '1:1', 'identycznie', 'dokładnie to samo', 'zero różnic', 'tak jak jest', 'przenieś bez zmian', 'migracja 1:1', 'z Figmy', 'pixel perfect', 'takie same kolory', 'takie same fonty'. Also trigger when the user says a seed, environment, structure, dataset, or design must reflect a source without deviation. When in doubt: load this skill."
---

# ZERODRIFT — Zero Drift, Absolute Parity

> The source is truth. Everything else is noise.

→ Full philosophy: see `PHILOSOPHY.md` in the ZeroDrift repository.  
→ Advanced Figma effects: see `references/figma-advanced.md`.

---

## Core Definition

**ZeroDrift = destination IS source.**

Not "based on". Not "similar to". Not "inspired by". Not "improved". **IS.**

```
source → [zero drift operation] → destination

Every field. Every version. Every file. Every state value.
Without remainder. Without addition. Without beautification.
```

If source is version `73.23` → destination is `73.23`. Not `~73.23`. Not `73.24`.  
If source has a deficit → destination has a deficit.  
If source has a bump → destination has a bump.

---

## The rsync --delete Model

```bash
rsync -av --delete source/ destination/
# Extra in destination → removed
# Missing in destination → added
# Result: destination IS source
```

Every sync, migration, or replication behaves like `rsync --delete`.

---

## The 8 Core Rules

### R1 — Versions pinned, not approximated
```json
"react": "^18.0.0"   ❌  drift guaranteed
"react": "18.3.1"    ✅  exact, always
```
No `^`. No `~`. No `*`. No `latest`.

---

### R2 — State replicated, not beautified
```typescript
// Production: balance = -342.50, orders = 0
// Replica MUST be: balance = -342.50, orders = 0
// NOT: balance = 1000, orders = 5  ("cleaner for testing")
// Deficit is deficit. Zero is zero.
```

---

### R3 — Structure complete, not approximate
```
Missing file = VIOLATION
Extra file   = VIOLATION
```
Source structure is the contract. Destination must match exactly.

---

### R4 — Functions return exactly what they declare
```typescript
// ❌ undeclared side effects + extra fields
function getUser(id: string): User {
  analytics.track(id)        // undeclared
  return { ...user, _x: 1 } // undeclared field
}
// ✅ signature = reality
function getUser(id: string): User {
  return db.users.findById(id)
}
```

---

### R5 — Edits scoped to the task, nothing beyond
```
Task: "change button color"
✅ 1:1: color changed. nothing else.
❌ VIOLATION: color + refactor + rename + cleanup
```
The diff IS the intention. Every line beyond the intention is drift.

---

### R6 — Commits contain exactly one logical change
```
✅ "fix: border-radius on Card" → diff shows border-radius only
❌ "fix: border-radius on Card" → diff shows 5 unrelated changes
```
Title = 100% of diff. Diff = 100% of title.

---

### R7 — Seed data mirrors production reality
```typescript
// ❌ invented fantasy data
{ name: "Test User", balance: 1000, orders: 5 }
// ✅ anonymized but structurally real
{ name: "User_A7F2", balance: -342.50, orders: 0 }
//                          ^ deficit  ^ zero orders = real edge case
```

### R7a — GDPR/RODO: anonymize before seeding (F-08)
```
Before using production data as seed:
1. Identify all PII fields: name, email, phone, address, IP, ID numbers
2. Apply pseudonymization with fixed faker seed (for reproducibility)
3. Document which fields were anonymized
4. Verify with scan: grep -r "@" seed/ | grep -v "example.com"

Preserve: data structure, statistical distributions, edge cases, nulls
Remove: all real PII values — every one, without exception

Failure to anonymize = GDPR Art. 5(1)(f) violation
Anonymization is not optional. It is not "we'll do it later."
```

---

### R8 — Environments are mirrors, not approximations
```bash
# Every key from prod present in staging
# Values differ only where they must (URLs, credentials)
# Zero missing keys. Zero extra keys.
diff <(ssh prod printenv | sort) <(printenv | sort)
# Zero output = 1:1
```

---

## Design & Figma Rules

### Photoshop Overlay Test — Definition of Done

```
1. Open implementation at Figma frame width (1920 or 1440)
2. Full-page screenshot
3. Export same Figma frame at 1x
4. Photoshop: overlay, Multiply blend, 50% opacity, zoom 100%

Pass: nothing visible — shapes merge, text aligns, colors match
Fail: any outline, offset, color shift = NOT DONE
```

**This is not optional. This is the acceptance criterion.**

---

### D1 — Typography: all 7 properties, exact

```css
font-family: 'Inter', sans-serif;  /* exact name — not system-ui */
font-size: 13px;                   /* NOT 14px — 1px matters */
font-weight: 500;                  /* numeric — not "medium" */
line-height: 20px;                 /* px from Figma — not 1.5 */
letter-spacing: -0.02em;           /* sign + decimals */
text-transform: uppercase;         /* if Figma has it */
color: #1A1A2E;                    /* exact hex */
```

If Figma uses a paid font → purchase it. Never substitute.

---

### D2 — Colors: exact hex, every gray is different

```css
/* #6B7180 and #6B7280 are different colors. Both intentional. */
:root {
  --color-text-primary:   #0A0A0A;
  --color-text-secondary: #6B7180;  /* NOT #6B7280 */
  --color-border:         #E5E7EB;
}
```

---

### D3 — Visible layers only

```
✅ Extract: visible=true, opacity>0, within frame boundary
❌ Skip:    eye icon OFF, opacity=0, outside frame, hidden parent
            layers named "ref", "guide", "DO NOT USE"

Canvas preview IS the contract. Layer panel is implementation detail.
```

---

### D4 — Auto Layout → CSS complete mapping

```
direction: horizontal  →  flex-direction: row
direction: vertical    →  flex-direction: column
item spacing: 16       →  gap: 16px
padding T/R/B/L        →  padding: Tpx Rpx Bpx Lpx
align: center          →  align-items: center
justify: space-between →  justify-content: space-between
fill container         →  width/height: 100%
hug contents           →  width: fit-content
fixed: 320             →  width: 320px
min/max: 200/800       →  min-width: 200px; max-width: 800px
wrap: wrap             →  flex-wrap: wrap
```

Nested Auto Layout = nested flex. Every level. Every property.

---

### D5 — Viewport scaling

```
Figma 1920px → 1440px viewport: scale factor = 0.75
All Figma values × 0.75 = correct 1440 values

Or fluid: font-size: clamp(Xpx, Yvw, Zpx)
  Z = Figma value (at 1920)
  Y = (Figma_value / 1920) * 100
  X = value at minimum viewport

Breakpoints ONLY from Figma frames. No Figma frame = no breakpoint.
```

→ For advanced effects (blend modes, backdrop-filter, inner shadow):  
see `references/figma-advanced.md`

---

## Exception Protocol (F-02)

When source is unavailable, incomplete, or inconsistent:

```
STOP
↓
Document: what is missing / inconsistent, where, why
↓
Surface: report to decision-maker with specific question
↓
Wait: do not proceed until explicit decision received
↓
Log: record decision + timestamp + who decided

NEVER: STOP → improvise → continue silently
```

Common exceptions and required responses:

| Situation | Response |
|---|---|
| Plugin version not in WP.org archive | STOP → find alternative source → ask client |
| Source DB partially corrupted | STOP → restore from backup → document scope |
| Figma frame incomplete / has placeholders | STOP → ask designer to complete |
| Media file missing on source | STOP → document missing file list → ask client |
| Content encoding mismatch | STOP → identify affected posts → ask client |

---

## When ZeroDrift Applies vs. Does NOT Apply

| Context | Apply? | Reason |
|---|---|---|
| Sync environments | ✅ | Parity prevents silent failures |
| Package versions | ✅ | Drift causes reproducibility bugs |
| Seed data | ✅ | Real distributions catch real bugs |
| Figma → code | ✅ | Figma is source of truth |
| Content migration | ✅ | Source content is the contract |
| Writing new feature | ❌ | Creative task, no source to mirror |
| Fixing a bug | ❌ | Change is the point |
| Generating new content | ❌ | No source = no parity constraint |
| Silent "improvements" | ❌ | Always surface, never self-authorize |

---

## AI Behavior Under ZeroDrift

1. **Stop improving** — no unsolicited type fixes, cleanups, renames
2. **Stop approximating** — no `^`, `~`, rounded values, eyeballed colors
3. **Stop beautifying** — deficits stay deficits, zeros stay zeros
4. **Stop substituting** — missing resource → ask, never invent
5. **Scope all output** — every output item maps to an input item
6. **Flag, never fix** — inconsistency in source → surface to user

When unsure: **do less, not more. Ask, do not assume.**

---

## Pre-Operation Checklist

- [ ] `--delete` equivalent active? (no orphaned state)
- [ ] All versions pinned exactly? (no `^`, `~`, `latest`)
- [ ] State replicated as-is? (deficits, nulls, zeros preserved)
- [ ] Structure identical? (no missing, no extra files)
- [ ] No unsolicited changes in diff?
- [ ] Commit title = 100% of diff?
- [ ] Seed data anonymized per R7a? (GDPR compliant)
- [ ] All env vars from source present?
- [ ] All 7 typography properties applied?
- [ ] All color hexes exact? (grays are not interchangeable)
- [ ] Visible layers only extracted?
- [ ] All Auto Layout → CSS mapped?
- [ ] Viewport scaling applied?
- [ ] Photoshop overlay test passed?

**Any NO = not zero drift. Stop. Fix before proceeding.**

---

## One-Line Summary

```
destination IS source.  rsync --delete.  Ship the Tiber water.  Overlay passes.
```
