# ZeroDrift

> **The source is truth. Everything else is noise.**

ZeroDrift is an open standard of rules and skills for AI coding agents that enforces **absolute parity** between source and destination — across code, design, content, and infrastructure.

No approximations. No "while I'm here" improvements. No rounded values. No substitutes.

---

## The Problem

AI coding agents are brilliant at building things from scratch.
They are terrible at **replicating** things exactly.

Given "migrate this WordPress site" or "implement this Figma design", an AI will:
- Round `13px` to `14px` because it "looks cleaner"
- Install `plugin@latest` instead of `plugin@5.7.7`
- Extract hidden Figma layers that were never meant to render
- "Clean up" content while migrating it
- Add a small improvement to a function it wasn't asked to touch

Each of these is **drift**. Drift compounds. Drift breaks production.

ZeroDrift gives AI agents a strict, verifiable contract: **destination IS source**.

---

## The Roman Pizza Rule

> Pizza must taste the same in Rome and in NYC.
> If that requires shipping water from the Tiber — you ship the water.
> You do not find a "similar substitute".

The cost of shipping Tiber water is always lower than the cost of drift discovered in production.

---

## The Mental Model

```bash
rsync -av --delete source/ destination/
```

`--delete` = extra in destination is removed. Missing is added.
Result: destination IS source. Not "similar to". Not "based on". **IS.**

Every ZeroDrift operation behaves like `rsync --delete`.

---

## What's Inside

```
zerodrift/
├── skills/core/SKILL.md          # Universal AI skill
├── rules/
│   ├── universal/one-to-one.mdc  # Core 1:1 rules
│   ├── figma/implementation.mdc  # Pixel-perfect Figma → code
│   ├── wordpress/migration.mdc   # WordPress site migration
│   └── content/migration.mdc     # Content migration
├── checklists/                   # Pre-launch verification
└── docs/                         # Philosophy, audit, contributing
```

---

## Quickstart

```bash
git clone https://github.com/zerodrift/zerodrift .zerodrift

# Pick what you need:
cp .zerodrift/rules/universal/one-to-one.mdc     .cursor/rules/
cp .zerodrift/rules/figma/implementation.mdc     .cursor/rules/
cp .zerodrift/rules/wordpress/migration.mdc      .cursor/rules/
cp .zerodrift/rules/content/migration.mdc        .cursor/rules/
```

---

## The Three Domains

### 🎨 Figma → Code (pixel-perfect)
- Font: exact name, weight, all 7 CSS properties
- Colors: exact hex — `#6B7180` ≠ `#6B7280`
- Visible layers only — canvas is the contract
- Auto Layout → CSS: every property, none skipped
- **Acceptance test:** Photoshop overlay at 50% opacity — zero visible difference

### 🔄 WordPress Migration
- Core: exact version match
- Plugins: exact versions via `wp plugin list`
- DB: full `--add-drop-table` clone, all tables
- Media: `rsync --delete` with file count verification

### 📄 Content Migration
- Every post migrates — no exceptions
- Publish dates never reset to migration date
- SEO metadata migrates for every post
- State as-is: deficit is deficit, zero is zero

---

## Compatibility

| Tool | Format | Location |
|------|--------|----------|
| Cursor | `.mdc` | `.cursor/rules/` |
| Claude Code | `.md` | `CLAUDE.md` |
| Windsurf | `.md` | `.windsurf/rules/` |
| GitHub Copilot | `.md` | `.github/copilot-instructions.md` |

---

## How It's Different

| | ZeroDrift | GuardrailsAI | GitOps | GitHub Spec-Kit |
|---|---|---|---|---|
| Figma design fidelity | ✅ | ❌ | ❌ | ❌ |
| Content migration parity | ✅ | ❌ | ❌ | ❌ |
| WordPress migration | ✅ | ❌ | ❌ | ❌ |
| AI agent rules/skills | ✅ | ✅ | ❌ | ✅ |
| Zero-drift philosophy | ✅ | Partial | ✅ | Partial |

---

## License

MIT

*Created by [Daniel Gogolewski](https://hyperdata.pl/daniel-gogolewski), Founder of [Hyperdata](https://hyperdata.pl)*
