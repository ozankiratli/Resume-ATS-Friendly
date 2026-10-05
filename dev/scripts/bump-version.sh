#!/usr/bin/env bash
#
# Start the CHANGELOG entry for a new version from the git log.
#
# Usage: dev/scripts/bump-version.sh <new-version>          e.g. 1.1.0
#
# This project has no VERSION file. A version is its CHANGELOG section and its tag, and
# release.yml refuses a tag the CHANGELOG has no section for. This prepends that section,
# listing every commit since the last release tag under a "### Commits" heading, and adds
# the matching reference-link definition at the foot of the file. It also points the
# README's version badge at the new version.
#
# Does not commit, tag or push. It prints those commands for you.
#
# Write the release notes ABOVE the "### Commits" heading, not over it: the commit
# list stays in the changelog as the record of what actually landed.

set -euo pipefail

NEW="${1-}"
if [[ ! "$NEW" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Usage: $0 <new-version>   (e.g. 1.1.0)" >&2
    exit 1
fi

ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"

LOG="CHANGELOG.md"
[ -f "$LOG" ] || { echo "ERROR: $LOG not found in $ROOT" >&2; exit 1; }

# The newest section heading is the current version.
CURRENT="$(sed -n 's/^## \[\([0-9][0-9.]*\)\].*/\1/p' "$LOG" | head -1)"
[ "$NEW" != "$CURRENT" ] || { echo "ERROR: $LOG is already at $NEW" >&2; exit 1; }
grep -qF "## [$NEW]" "$LOG" && { echo "ERROR: $LOG already has a [$NEW] section" >&2; exit 1; }
git rev-parse -q --verify "refs/tags/v$NEW" > /dev/null && {
    echo "ERROR: tag v$NEW already exists" >&2; exit 1; }

# The README's version badge: the shields.io image and the link to that version's
# release, on one line. Checked before anything is written, so a README whose badge has
# gone or changed shape stops the bump instead of leaving the CHANGELOG changed without
# it. Whatever version the badge shows is replaced, not only the current one.
README="README.md"
BADGE='^\[!\[Version\]'
[ -f "$README" ] || { echo "ERROR: $README not found in $ROOT" >&2; exit 1; }
nbadge="$(grep -cE "$BADGE" "$README" || true)"
[ "$nbadge" -eq 1 ] || {
    echo "ERROR: $README should have one version badge line, starting [![Version], and has $nbadge" >&2; exit 1; }
grep -E "$BADGE" "$README" \
    | grep -qE 'badge/version-v[0-9]+\.[0-9]+\.[0-9]+-.*/releases/tag/v[0-9]+\.[0-9]+\.[0-9]+\)' || {
    echo "ERROR: $README's version badge is not in the form this script updates:" >&2
    grep -E "$BADGE" "$README" >&2
    exit 1
}

# Everything since the most recent tag, or the whole history for a first release.
LAST_TAG="$(git describe --tags --abbrev=0 2>/dev/null || true)"
if [ -n "$LAST_TAG" ]; then
    RANGE="$LAST_TAG..HEAD"
else
    RANGE="HEAD"
fi

COMMITS="$(git log --no-merges --reverse --pretty='- (%h) %s' "$RANGE")"
if [ -z "$COMMITS" ]; then
    echo "ERROR: no commits since ${LAST_TAG:-the start of history} - nothing to release" >&2
    exit 1
fi

ENTRY="## [$NEW] - $(date +%F)

### Commits

$COMMITS

---
"

# Inserted above the newest existing section. The entry reaches awk through ENVIRON
# rather than -v, because -v processes escape sequences and would rewrite a commit
# subject that happens to contain \t or \n.
ENTRY="$ENTRY" awk '
    !inserted && /^## \[/ { print ENVIRON["ENTRY"]; inserted = 1 }
    { print }
    END { if (!inserted) print ENVIRON["ENTRY"] }
' "$LOG" > "$LOG.tmp" && mv "$LOG.tmp" "$LOG"

# Every `## [x.y.z]` heading is a Markdown reference link and renders as literal
# brackets without a definition. The base URL is taken from the newest existing one,
# so it follows the repository rather than being written down twice.
LINKBASE="$(sed -n 's|^\[[0-9][0-9.]*\]: \(https://.*\)/v[0-9][0-9.]*$|\1|p' "$LOG" | head -1)"
[ -n "$LINKBASE" ] || LINKBASE="https://github.com/ozankiratli/Resume-ATS-Friendly/releases/tag"
LINK="[$NEW]: $LINKBASE/v$NEW"

if grep -qE '^\[[0-9]+\.[0-9]+\.[0-9]+\]: ' "$LOG"; then
    LINK="$LINK" awk '
        !inserted && /^\[[0-9]+\.[0-9]+\.[0-9]+\]: / { print ENVIRON["LINK"]; inserted = 1 }
        { print }
    ' "$LOG" > "$LOG.tmp" && mv "$LOG.tmp" "$LOG"
else
    printf '\n%s\n' "$LINK" >> "$LOG"
fi

sed -i -E "/$BADGE/ {
    s#badge/version-v[0-9]+\.[0-9]+\.[0-9]+-#badge/version-v$NEW-#
    s#/releases/tag/v[0-9]+\.[0-9]+\.[0-9]+\)#/releases/tag/v$NEW)#
}" "$README"
grep -qF "badge/version-v$NEW-" "$README" && grep -qF "/releases/tag/v$NEW)" "$README" || {
    echo "ERROR: $README's version badge did not take v$NEW; $LOG has been changed already" >&2; exit 1; }

echo "${CURRENT:-none} -> $NEW"
echo "  $LOG : $(printf '%s\n' "$COMMITS" | wc -l) commits since ${LAST_TAG:-the start}, link definition added"
echo "  $README    : version badge points at v$NEW"
echo
echo "Write this version's notes into $LOG, above its '### Commits' heading,"
echo "and check they extract: dev/scripts/changelog-section.sh $NEW"
echo "Then:"
echo "  git add -A && git commit -m 'Version bump $NEW'"
echo "  git push origin main"
echo "  git tag v$NEW && git push origin v$NEW"
echo
echo "Pushing the tag is what publishes. Nothing here has pushed anything."
