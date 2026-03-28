---
description: "1:1 parity rules for WordPress site migration, content migration, and Figma-to-code implementation. Apply when working on any WP migration, content transfer, theme build from Figma, or pixel-perfect implementation. The source is always the authority. Nothing is added, nothing is removed, nothing is approximated."
alwaysApply: false
globs:
  - "**/*.php"
  - "**/*.css"
  - "**/*.scss"
  - "**/wp-config*"
  - "**/theme/**"
  - "**/plugins/**"
  - "**/figma/**"
  - "**/migration/**"
---

# 1:1 IMPLEMENTATION RULES
## WordPress Migration · Content Migration · Figma Implementation

---

## THE PRIME DIRECTIVE

**Source is truth. Destination IS source.**
Not "based on". Not "cleaned up". Not "improved". **IS.**

```
rsync -av --delete source/ destination/

--delete means:
  extra in destination  → removed
  missing in destination → added
  result: destination = clone of source. No orphans. No gaps.
```

**The Photoshop Overlay Test** — definition of done for any visual implementation:
Screenshot browser → screenshot Figma → overlay at Multiply 50% in Photoshop → zero visible difference.
Any outline, offset, or color shift = NOT DONE.

---

## PART 1 — WORDPRESS SITE MIGRATION

### WP-M1 — Plugin versions are pinned, not approximated

```
Source site: Contact Form 7 v5.7.7
Destination: Contact Form 7 v5.7.7  ✅
Destination: Contact Form 7 v5.8.1  ❌ — "latest stable"
Destination: Contact Form 7 v5.7.*  ❌ — "roughly the same"
```

**Every plugin installed on source must be installed on destination at the exact same version.**
Do not update during migration. Migration and update are separate tasks, never combined.

```bash
# Extract exact versions from source
wp plugin list --format=csv --fields=name,version > plugins-source.csv

# Install exact versions on destination
while IFS=, read name version; do
  wp plugin install "$name" --version="$version" --activate
done < plugins-source.csv
```

---

### WP-M2 — WordPress core version is exact

```bash
# Source runs: WordPress 6.4.3
# Destination must run: WordPress 6.4.3

wp core download --version=6.4.3  ✅
wp core download                  ❌  # installs latest — drift guaranteed
```

Upgrade only after migration is verified complete and signed off.

---

### WP-M3 — Database is a full clone

```bash
# Export from source — all tables, all data
wp db export source-full.sql --add-drop-table

# Import to destination
wp db import source-full.sql

# Then replace URLs only (never touch content structure)
wp search-replace 'https://source-domain.com' 'https://dest-domain.com' \
  --all-tables \
  --precise \
  --report-changed-only
```

**No selective table imports.** Every table migrates.
wp_options, wp_posts, wp_postmeta, wp_users, wp_usermeta, wp_terms,
wp_term_taxonomy, wp_term_relationships, wp_comments, wp_commentmeta —
ALL of them. Custom plugin tables — ALL of them.

Missing table = broken functionality that will only appear in production.

---

### WP-M4 — Media library is complete, paths intact

```bash
# Sync uploads — rsync --delete is mandatory
rsync -avz --delete source:/var/www/html/wp-content/uploads/ \
                    destination:/var/www/html/wp-content/uploads/

# Verify count matches
ssh source "find wp-content/uploads -type f | wc -l"
ssh destination "find wp-content/uploads -type f | wc -l"
# Numbers must be identical. Any difference = missing files.
```

File counts must match exactly. Do not regenerate thumbnails until full sync verified.

---

### WP-M5 — wp-config.php: all constants, exact names

```php
// Every constant from source wp-config.php must exist in destination
// Values change (DB credentials, URLs) — constant names do not

// ❌ VIOLATION — dropped a custom constant
// Source had: define('CUSTOM_API_KEY', '...');
// Destination: missing → plugin silently fails

// ✅ 1:1 — all constants present, values updated for destination
define('DB_NAME',      'dest_db');
define('DB_USER',      'dest_user');
define('DB_PASSWORD',  'dest_pass');
define('DB_HOST',      'localhost');
define('WP_HOME',      'https://dest-domain.com');    // changed
define('WP_SITEURL',   'https://dest-domain.com');    // changed
define('CUSTOM_API_KEY', 'dest_api_key');             // present ✅
define('WP_DEBUG',     false);                        // present ✅
```

Run a diff of constant names (not values) between source and destination config. Zero missing.

---

### WP-M6 — Theme files are rsync'd, not rewritten

```bash
# Theme migration — exact file-for-file
rsync -avz --delete source:/wp-content/themes/client-theme/ \
                    destination:/wp-content/themes/client-theme/

# ❌ VIOLATION — "I rewrote it cleaner while migrating"
# ❌ VIOLATION — "I updated the template hierarchy"
# ❌ VIOLATION — "I removed that deprecated function"
```

Theme is migrated AS IS. Improvements are a separate ticket, separate commit, separate deploy.

---

### WP-M7 — Site settings migrated exactly

The following must be verified manually after URL search-replace:

```
WordPress Settings → General:
  Site Title       → identical
  Tagline          → identical (including if empty)
  Timezone         → identical
  Date Format      → identical

Settings → Reading:
  Front page       → same page assigned
  Posts per page   → same number

Settings → Permalinks:
  Structure        → identical string

Menus:
  Every menu exists with identical name
  Every menu item present, same order, same URL (post-replace)
  Menu locations assigned identically

Widgets:
  Every widget area populated identically
  Widget settings (titles, configs) identical
```

---

### WP-M8 — User accounts and roles preserved

```bash
# Users migrate with database — roles and capabilities must be verified
wp user list --format=csv --fields=ID,user_login,roles > users-source.csv

# On destination after migration:
wp user list --format=csv --fields=ID,user_login,roles > users-dest.csv

diff users-source.csv users-dest.csv
# Must show: no differences (except password hashes which are db-level)
```

No user created, deleted, or role-changed during migration.

---

## PART 2 — CONTENT MIGRATION

### C1 — Every post and page migrates — no exceptions

```bash
# Count on source
wp post list --post_type=any --post_status=any --format=count

# Count on destination (after migration)
wp post list --post_type=any --post_status=any --format=count

# Numbers must be identical.
# "We'll skip drafts" = VIOLATION unless explicitly approved by client.
# "We'll skip old posts" = VIOLATION unless explicitly approved by client.
```

---

### C2 — Content is migrated exactly — not "cleaned up"

```
Source post body:
  "Contact us at <a href="tel:+48123456789">+48 123 456 789</a>
   or visit our <strong>Warsaw office</strong>."

Destination MUST have exactly:
  "Contact us at <a href="tel:+48123456789">+48 123 456 789</a>
   or visit our <strong>Warsaw office</strong>."

❌ VIOLATIONS:
  - Removed the phone number ("outdated")
  - Changed bold to italic ("looks better")
  - Rewrote sentence ("better grammar")
  - Stripped HTML ("cleaner markup")
  - Added paragraph break ("more readable")
```

Content migration is not content editing. Editing is a separate project scope.
If source has bad grammar, bad formatting, or outdated info — it migrates as-is.
Flag it. Do not fix it without explicit approval.

---

### C3 — Post metadata migrated exactly

Every piece of metadata migrates. Not a subset:

```
For each post/page, verify:
  post_status      → identical (published stays published, draft stays draft)
  post_date        → identical (original publish date, NOT migration date)
  post_modified    → identical
  post_author      → identical (correct user ID mapping)
  post_name (slug) → identical
  post_parent      → identical (page hierarchy preserved)
  menu_order       → identical
  featured image   → present and correct image
  all _postmeta    → every custom field, every ACF field, every plugin meta
```

**Publish date is never reset to migration date.** That destroys SEO and editorial history.

---

### C4 — Taxonomies: exact hierarchy, exact slugs

```bash
# Categories and tags migrate with database
# Custom taxonomies migrate with database
# Verify term hierarchy is intact:

wp term list category --format=csv --fields=term_id,name,slug,parent \
  > terms-source.csv

# On destination:
wp term list category --format=csv --fields=term_id,name,slug,parent \
  > terms-dest.csv

diff terms-source.csv terms-dest.csv
# Zero differences.
```

Term slugs are part of the URL structure. Slug drift = 404 errors.

---

### C5 — SEO metadata migrated exactly

If Yoast SEO or RankMath is installed, for every post verify:

```
_yoast_wpseo_title           → identical (or RankMath equivalent)
_yoast_wpseo_metadesc        → identical
_yoast_wpseo_canonical       → identical (update domain only)
_yoast_wpseo_focuskw         → identical
_yoast_wpseo_opengraph-image → present and resolving

❌ VIOLATION — "I left SEO blank, they can fill it later"
SEO metadata is content. It migrates.
```

---

### C6 — Internal links resolve after domain change

```bash
# After search-replace, verify no broken internal links remain
wp post list --post_status=publish --format=ids | \
  xargs -I {} wp post get {} --field=post_content | \
  grep -o 'href="[^"]*"' | \
  grep 'source-domain.com'
# Must return: nothing. Zero old domain references in content.

# Also check postmeta (ACF link fields, etc.)
wp db query "SELECT meta_value FROM wp_postmeta
  WHERE meta_value LIKE '%source-domain.com%'
  AND meta_key NOT LIKE '\_edit%'"
# Must return: nothing.
```

---

### C7 — Redirects from old URLs to new are 1:1 mapped

If the domain changes OR permalink structure changes:

```
Every old URL → exact corresponding new URL
No old URL left without a redirect
No redirect points to homepage as fallback ("close enough")

# Generate redirect map before migration
wp post list --post_status=publish --format=csv \
  --fields=ID,post_name,post_type > url-inventory.csv

# After migration, validate every URL in list returns 200 or 301
# NOT 404. NOT redirect-to-homepage.
```

---

## PART 3 — FIGMA TO WORDPRESS/CODE IMPLEMENTATION

### F1 — THE PHOTOSHOP OVERLAY TEST (definition of done)

```
1. Open page in browser at Figma frame width (1920 or 1440)
2. Full-page screenshot
3. Export Figma frame at 1x (File → Export frame)
4. Photoshop: paste browser screenshot over Figma export
5. Top layer: Multiply blend mode, 50% opacity
6. Zoom to 100%

Pass: shapes merge, text aligns, colors match — nothing visible
Fail: any outline, color shift, offset, size difference = NOT DONE

This is not optional. This is the acceptance criterion.
```

---

### F2 — Fonts: exact name, exact weight, exact load method

```css
/* Step 1: identify font in Figma inspect panel */
/* Step 2: find exact Google Fonts / Adobe Fonts / local font name */
/* Step 3: load exactly that font — not a "similar" substitute */

/* Figma: Inter, 500, 13px, -0.02em letter-spacing */

/* ❌ VIOLATION */
font-family: 'Helvetica Neue', sans-serif;  /* "looks similar" */
font-family: system-ui;                     /* "clean and fast" */

/* ✅ 1:1 */
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@500&display=swap');
font-family: 'Inter', sans-serif;
font-size: 13px;
font-weight: 500;
line-height: 20px;        /* exact px, not 1.5 */
letter-spacing: -0.02em;  /* sign and decimals */
```

If Figma uses a paid/licensed font — that font is purchased and installed. Not substituted.
Substituting a font is substituting water from the Tiber with tap water. It is not the same pizza.

---

### F3 — Colors: exact hex, every gray shade is different

```css
/* Copy hex directly from Figma color picker — do not eyeball */

/* ❌ VIOLATION */
color: #6b7280;   /* Figma: #6B7180 — different gray */
color: gray;      /* unacceptable */
color: #000;      /* if Figma says #0A0A0A — it is not black */

/* ✅ 1:1 */
:root {
  --color-text-primary:   #0A0A0A;   /* from Figma: Primary Text */
  --color-text-secondary: #6B7180;   /* from Figma: Secondary Text */
  --color-text-muted:     #9CA3AF;   /* from Figma: Muted Text */
  --color-border:         #E5E7EB;   /* from Figma: Border Default */
  --color-surface:        #F9FAFB;   /* from Figma: Surface */
}

/* Every gray in the design system is intentional and different.
   #6B7180 and #6B7280 are not the same. Copy exact. */
```

---

### F4 — Visible graphics only — not what is in the layer panel

```
Extract from Figma only what is VISIBLE in canvas preview at 100% zoom:
  ✅ layers with eye icon ON
  ✅ layers with opacity > 0
  ✅ layers within frame boundary

DO NOT extract:
  ❌ layers hidden with eye icon
  ❌ layers with opacity: 0
  ❌ design reference layers (often named "ref", "guide", "DO NOT USE")
  ❌ layers outside frame boundary (overflow clipped)
  ❌ mask layers themselves (only the masked content)
  ❌ layers inside a hidden parent

Rule: if you cannot see it in Figma canvas — it does not render in browser.
The canvas preview is the contract. The layer panel is the implementation detail.
```

---

### F5 — Auto Layout maps to CSS exactly

```
Figma Auto Layout property    →   CSS property

direction: horizontal         →   flex-direction: row
direction: vertical           →   flex-direction: column
item spacing: 16              →   gap: 16px
padding: 24 / 16              →   padding: 24px 16px
padding (per side): T R B L   →   padding: Tpx Rpx Bpx Lpx
align items: center           →   align-items: center
align items: start            →   align-items: flex-start
justify: space-between        →   justify-content: space-between
justify: center               →   justify-content: center
fill container (horizontal)   →   width: 100%
fill container (vertical)     →   height: 100%
hug contents                  →   width: fit-content
fixed width: 320              →   width: 320px
min width: 200                →   min-width: 200px
max width: 800                →   max-width: 800px
wrap: wrap                    →   flex-wrap: wrap
```

Nested Auto Layout → nested flex containers. Every level. Every property. No level skipped.

```css
/* ❌ VIOLATION — guessed */
.hero { padding: 80px 40px; gap: 20px; }

/* ✅ 1:1 — read from Figma Auto Layout inspect */
.hero {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 96px 48px;       /* Figma: top/bottom 96, left/right 48 */
  gap: 24px;                /* Figma: item spacing 24 */
  max-width: 1440px;        /* Figma: fixed width 1440 */
}
```

---

### F6 — Viewport scaling: Figma frame → actual window

```
Figma frame width: 1920px
Target: responsive from 1280px to 1920px

Scale formula: value × (viewport / figma_frame_width)
At 1440px: multiply all Figma values by 0.75

Use CSS clamp() for fluid scaling:
  font-size: clamp(Xpx, Y_vw, Zpx)

  X = minimum (value at 1280px viewport)
  Z = maximum (value at 1920px = Figma value)
  Y = vw coefficient = (Figma_value / 1920) * 100

Example — Figma font-size: 64px
  At 1280px: 64 × (1280/1920) = 42.67px → 42px
  font-size: clamp(42px, 3.33vw, 64px);

Example — Figma gap: 48px
  gap: clamp(32px, 2.5vw, 48px);

Breakpoints ONLY from existing Figma frames:
  → 1920px frame  =  @media (min-width: 1920px)
  → 1440px frame  =  @media (min-width: 1440px)
  → 768px frame   =  @media (min-width: 768px)
  → 375px frame   =  @media (max-width: 767px)

Never invent a breakpoint. No Figma frame = no breakpoint.
```

---

### F7 — Shadows and effects: exact values

```css
/* Read from Figma: Effects panel → Box Shadow / Drop Shadow */

/* Figma shows:
   X: 0  Y: 4  Blur: 24  Spread: 0  Color: #000000 at 12% opacity */

/* ❌ VIOLATION */
box-shadow: 0 2px 10px rgba(0,0,0,0.2);   /* eyeballed */

/* ✅ 1:1 */
box-shadow: 0px 4px 24px 0px rgba(0, 0, 0, 0.12);
```

Multiple shadows: copy all layers in Figma order.
Blur ≠ spread. Both are separate values. Both must be correct.

---

### F8 — Border radius: per corner if mixed

```css
/* Figma: corner radius per corner (top-left, top-right, bottom-right, bottom-left) */

/* ❌ VIOLATION — uniform radius applied */
border-radius: 8px;

/* ✅ 1:1 — Figma shows: TL=8, TR=8, BR=0, BL=0 */
border-radius: 8px 8px 0 0;
```

---

### F9 — WordPress template = Figma template, exactly

```
Figma page named "Blog Single" → WordPress template: single.php or single-{post-type}.php
Figma page named "Archive"     → WordPress template: archive.php
Figma page named "Homepage"    → WordPress template: front-page.php

Template assignment in WP admin must match Figma page type.
❌ VIOLATION — "I used the default template, looks the same"
Default template ≠ custom template. They diverge when client adds content.
```

---

## COMBINED PRE-LAUNCH CHECKLIST

### WordPress Migration
- [ ] Core version identical to source?
- [ ] All plugins installed at exact source versions?
- [ ] Database fully imported (all tables)?
- [ ] File counts match (uploads directory)?
- [ ] wp-config.php has all constants from source?
- [ ] Theme files rsync'd with --delete?
- [ ] All settings verified (menus, widgets, permalinks, reading)?
- [ ] User accounts and roles intact?
- [ ] search-replace run with --precise --all-tables?

### Content Migration
- [ ] Post/page count identical to source?
- [ ] Post statuses preserved (drafts are drafts, published is published)?
- [ ] Publish dates preserved (not reset to migration date)?
- [ ] All ACF / custom fields present and populated?
- [ ] All featured images present and assigned?
- [ ] All categories, tags, taxonomy terms migrated with slugs intact?
- [ ] SEO metadata (Yoast/RankMath) migrated for every post?
- [ ] Zero old domain references in content?
- [ ] All internal links resolving on new domain?
- [ ] Redirect map covers every changed URL?

### Figma Implementation
- [ ] Fonts loaded exactly (name, weight, fallback)?
- [ ] All 7 typography properties applied per element?
- [ ] All color hexes exact from Figma? (grays verified)
- [ ] Only visible layers extracted?
- [ ] All Auto Layout properties mapped to CSS?
- [ ] Viewport scaling applied? (clamp() for fluid)?
- [ ] Breakpoints only from Figma frames?
- [ ] Shadows: exact X, Y, blur, spread, color, opacity?
- [ ] Border radius: per corner where mixed?
- [ ] Photoshop overlay test PASSED at 1920 and 1440?

**Any NO = not 1:1. Stop. Do not mark as done.**

---

## AI BEHAVIOR ON THIS PROJECT

When working on WordPress migration, content migration, or Figma implementation:

1. **Never skip content** — every post, every field, every image migrates
2. **Never "improve" while migrating** — migration and improvement are separate tasks
3. **Never approximate values** — copy exact hex, exact px, exact version
4. **Never use hidden layers** — visible canvas = implementation contract
5. **Never invent breakpoints** — only Figma frames become breakpoints
6. **Never reset publish dates** — original date is preserved always
7. **Never substitute fonts** — if the font is paid, the font is purchased
8. **Surface inconsistencies, never silently fix them** — flag to user, wait for decision

When source has a flaw → migrate the flaw → flag the flaw → fix separately.
The migration phase has zero creative license.

---

## ONE-LINE SUMMARY

```
Source is truth. rsync --delete. Tiber water. Overlay test passes. Ship.
```
