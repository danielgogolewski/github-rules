# Changelog

All notable changes to ZeroDrift are documented in this file.
Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
versioning follows [SemVer](https://semver.org/).

## [1.1.1] — 2026-07-14

Housekeeping patch. No semantic changes to any rule.

### Fixed
- README Quickstart pointed to a non-existent repository URL — now points to the actual repo
- `skills/core/SKILL.md` referenced `PHILOSOPHY.md` at the wrong path (file lives in `docs/`)
- `references/wp-cli-verify.sh` crashed on empty query results — comparisons now guard against unset values, and the script fails fast with a clear error when `wp-cli` is missing
- Version metadata was inconsistent across files (`1.1.0` in most frontmatter, missing entirely in `rules/content/migration.mdc`) — all files now declare `1.1.1`

### Removed
- `docs/AUDIT.md` — legacy pre-split combined rules file that duplicated (and had already drifted from) the three domain `.mdc` rules; the split rules are the single source of truth
- Dangling `(F-XX)` audit-finding codes in `SKILL.md` and `rules/wordpress/migration.mdc` that referenced a document not in the repo
- Stray empty directory created by a failed shell brace expansion (was included in the old distribution zip)

### Added
- This changelog
- README note that `references/` support files must be kept alongside copied rules

## [1.1.0] — 2026-03-28

Initial public release.

### Added
- `skills/core/SKILL.md` — universal ZeroDrift skill (8 core rules, Figma rules, exception protocol)
- `rules/universal/one-to-one.mdc` — universal 1:1 parity rule
- `rules/figma/implementation.mdc` — pixel-perfect Figma-to-code rules (F1–F10)
- `rules/wordpress/migration.mdc` — WordPress migration rules (WP-M1–M8, rollback protocol)
- `rules/content/migration.mdc` — content migration rules (C1–C7)
- `references/figma-advanced.md` — blend modes, backdrop-filter, inner shadow, stroke alignment, gradients
- `references/wp-cli-verify.sh` — automated post-migration verification script
- `checklists/pre-launch.md` — combined sign-off checklist
- `docs/PHILOSOPHY.md`, `docs/CONTRIBUTING.md`
