#!/bin/bash
# ZeroDrift — WordPress Migration Verification Script
# Run on DESTINATION after migration and search-replace
# Usage: ./wp-cli-verify.sh source-domain.com

SOURCE_DOMAIN="${1:-source-domain.com}"
ERRORS=0

echo "=================================================="
echo " ZeroDrift WP Migration Verification"
echo " Source domain: $SOURCE_DOMAIN"
echo "=================================================="

# ── POST COUNTS ────────────────────────────────────────
echo ""
echo "[ 1/8 ] Post counts..."
COUNT=$(wp post list --post_type=any --post_status=any --format=count 2>/dev/null)
echo "  Total posts/pages: $COUNT"
echo "  ⚠  Compare manually with source count"

# ── PUBLISH DATES ──────────────────────────────────────
echo ""
echo "[ 2/8 ] Checking for posts with today's date (migration date reset)..."
TODAY=$(date +%Y-%m-%d)
RESET=$(wp db query "SELECT COUNT(*) FROM wp_posts WHERE DATE(post_date) = '$TODAY' AND post_status = 'publish'" --skip-column-names 2>/dev/null)
if [ "$RESET" -gt "0" ]; then
  echo "  ❌ FAIL: $RESET published posts have today's date — likely reset during migration"
  ERRORS=$((ERRORS+1))
else
  echo "  ✅ PASS: No publish date resets detected"
fi

# ── OLD DOMAIN IN CONTENT ──────────────────────────────
echo ""
echo "[ 3/8 ] Checking for old domain in post content..."
OLD_IN_CONTENT=$(wp db query "SELECT COUNT(*) FROM wp_posts WHERE post_content LIKE '%$SOURCE_DOMAIN%'" --skip-column-names 2>/dev/null)
if [ "$OLD_IN_CONTENT" -gt "0" ]; then
  echo "  ❌ FAIL: $OLD_IN_CONTENT posts still contain $SOURCE_DOMAIN"
  ERRORS=$((ERRORS+1))
else
  echo "  ✅ PASS: No old domain in post content"
fi

# ── OLD DOMAIN IN POSTMETA ─────────────────────────────
echo ""
echo "[ 4/8 ] Checking for old domain in postmeta (ACF, links)..."
OLD_IN_META=$(wp db query "SELECT COUNT(*) FROM wp_postmeta WHERE meta_value LIKE '%$SOURCE_DOMAIN%' AND meta_key NOT LIKE '\_%edit%'" --skip-column-names 2>/dev/null)
if [ "$OLD_IN_META" -gt "0" ]; then
  echo "  ❌ FAIL: $OLD_IN_META postmeta rows still contain $SOURCE_DOMAIN"
  ERRORS=$((ERRORS+1))
else
  echo "  ✅ PASS: No old domain in postmeta"
fi

# ── FK INTEGRITY: posts → users ────────────────────────
echo ""
echo "[ 5/8 ] Checking post_author FK integrity..."
ORPHAN_AUTHORS=$(wp db query "SELECT COUNT(*) FROM wp_posts WHERE post_author NOT IN (SELECT ID FROM wp_users) AND post_author != 0" --skip-column-names 2>/dev/null)
if [ "$ORPHAN_AUTHORS" -gt "0" ]; then
  echo "  ❌ FAIL: $ORPHAN_AUTHORS posts reference non-existent users"
  ERRORS=$((ERRORS+1))
else
  echo "  ✅ PASS: All post_author references valid"
fi

# ── FK INTEGRITY: postmeta → posts ─────────────────────
echo ""
echo "[ 6/8 ] Checking postmeta orphans..."
ORPHAN_META=$(wp db query "SELECT COUNT(*) FROM wp_postmeta WHERE post_id NOT IN (SELECT ID FROM wp_posts)" --skip-column-names 2>/dev/null)
if [ "$ORPHAN_META" -gt "0" ]; then
  echo "  ❌ FAIL: $ORPHAN_META orphan postmeta rows (no matching post)"
  ERRORS=$((ERRORS+1))
else
  echo "  ✅ PASS: No orphan postmeta"
fi

# ── FK INTEGRITY: term_relationships ──────────────────
echo ""
echo "[ 7/8 ] Checking term_relationships integrity..."
ORPHAN_TERMS=$(wp db query "SELECT COUNT(*) FROM wp_term_relationships tr LEFT JOIN wp_term_taxonomy tt ON tr.term_taxonomy_id = tt.term_taxonomy_id WHERE tt.term_taxonomy_id IS NULL" --skip-column-names 2>/dev/null)
if [ "$ORPHAN_TERMS" -gt "0" ]; then
  echo "  ❌ FAIL: $ORPHAN_TERMS orphan term_relationships"
  ERRORS=$((ERRORS+1))
else
  echo "  ✅ PASS: term_relationships integrity OK"
fi

# ── SEO METADATA PRESENCE ─────────────────────────────
echo ""
echo "[ 8/8 ] Checking SEO metadata presence (Yoast)..."
POSTS_WITH_SEO=$(wp db query "SELECT COUNT(DISTINCT post_id) FROM wp_postmeta WHERE meta_key = '_yoast_wpseo_title'" --skip-column-names 2>/dev/null)
PUBLISHED=$(wp post list --post_type=post --post_status=publish --format=count 2>/dev/null)
echo "  Published posts: $PUBLISHED"
echo "  Posts with Yoast title: $POSTS_WITH_SEO"
if [ "$POSTS_WITH_SEO" -lt "$PUBLISHED" ]; then
  echo "  ⚠  WARNING: Some published posts missing SEO title — verify manually"
else
  echo "  ✅ PASS: SEO metadata present"
fi

# ── SUMMARY ────────────────────────────────────────────
echo ""
echo "=================================================="
if [ "$ERRORS" -eq "0" ]; then
  echo " ✅ ALL CHECKS PASSED — ZeroDrift verified"
else
  echo " ❌ $ERRORS CHECKS FAILED — do not launch"
  echo "    Fix all failures before go-live"
fi
echo "=================================================="
