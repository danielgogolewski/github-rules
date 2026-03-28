# ZeroDrift Pre-Launch Checklist

Complete this checklist before every migration or Figma implementation goes live.
Every NO = stop. Fix before proceeding.

---

## WordPress Migration

- [ ] Core version identical to source?
- [ ] All plugins at exact source versions? (`wp plugin list`)
- [ ] Database fully imported (all tables, `--add-drop-table`)?
- [ ] Media file counts match (source vs destination)?
- [ ] All wp-config.php constants from source are present?
- [ ] Theme rsync'd with `--delete`?
- [ ] All menus, widgets, permalinks verified?
- [ ] User accounts and roles intact?
- [ ] search-replace run with `--precise --all-tables`?
- [ ] Rollback snapshot taken and labeled with timestamp?

---

## Content Migration

- [ ] Post/page count identical to source?
- [ ] Post statuses preserved? (draft = draft, published = published)
- [ ] Publish dates preserved? (NOT reset to migration date)
- [ ] All ACF / custom fields present and populated?
- [ ] All featured images present and assigned?
- [ ] All categories, tags, and custom taxonomy terms migrated?
- [ ] SEO metadata (Yoast/RankMath) migrated for every post?
- [ ] Zero old domain references in post content?
- [ ] Zero old domain references in postmeta?
- [ ] All internal links resolving on new domain?
- [ ] Redirect map covers every changed URL?

---

## Figma Implementation

- [ ] All 7 typography properties applied per text element?
- [ ] All color hexes copied exact from Figma? (no eyeballing grays)
- [ ] Only visible layers extracted? (hidden layers ignored)
- [ ] All Auto Layout properties mapped to CSS?
- [ ] Viewport scaling applied? (`clamp()` for fluid scaling)
- [ ] Breakpoints only from existing Figma frames?
- [ ] Shadows: exact X, Y, blur, spread, color, opacity per layer?
- [ ] Border radius: per corner where mixed in Figma?
- [ ] All component variants implemented? (no missing, no invented)
- [ ] **Photoshop Overlay Test PASSED at 1920px and 1440px?**

---

## Universal (all tasks)

- [ ] No unsolicited changes in diff?
- [ ] Commit title = 100% of the diff?
- [ ] No "while I'm here" improvements?
- [ ] Package versions pinned exactly? (no `^`, `~`, `latest`)

---

**Signed off:** _____________________ **Date:** _____________
