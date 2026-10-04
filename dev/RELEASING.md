# Releasing Resume-ATS-Friendly

One workflow, `.github/workflows/release.yml`, runs when a `v*` tag is pushed. It compiles `Resume.tex` and `CoverLetter.tex` in a full TeX Live, fails on any error or undefined reference, and publishes a GitHub release. A push to a branch does nothing.

The release body is this version's `CHANGELOG.md` section with `dev/release-notes-tail.md` below it. What you write in the CHANGELOG is what the release page says.

## What is attached to a release

- **`Resume.pdf`** and **`CoverLetter.pdf`** -- compiled by the workflow from the tagged commit.
- **`Resume-ATS-Friendly-<version>.zip`** -- the template as committed at the tag: both classes, both example `.tex` files, the `.bib`, README, LICENSE and CHANGELOG. `dev/` and `.github/` are left out by `.gitattributes`.
- **`SHA256SUMS`** -- for the three files above.

## Each release

1. **Compile both documents and look at them.**

       latexmk -pdf Resume.tex
       latexmk -pdf CoverLetter.tex

   Open both PDFs. The workflow can tell a document compiled; only you can tell it looks right. Commit the PDFs this produces, since the repository and the zip carry them.

2. **Start the CHANGELOG section.**

       dev/scripts/bump-version.sh 1.1.0

   It prepends a `## [1.1.0] - <date>` section holding every commit since the last tag under `### Commits`, and adds the reference link at the foot. It does not commit, tag or push. Pick the number by the "How to read the version" note at the top of the CHANGELOG.

3. **Write the notes** into that section, **above** its `### Commits` heading and not over it. A bold lead paragraph, then `### Added`, `### Changed`, `### Fixed`, `### Removed` as they apply. Anything a user has to change in their own `.tex` file goes first.

   Check it extracts, because the workflow refuses a version the CHANGELOG does not describe:

       dev/scripts/changelog-section.sh 1.1.0

4. **Commit and push the branch.**

       git add -A && git commit -m 'Version bump 1.1.0'
       git push origin main

5. **Rehearse it** (optional). From the Actions tab, run **Publish a release** on `main`. It compiles, checks and prints the release body, and publishes nothing, since there is no tag.

6. **Tag it and push the tag.** This is the only step that publishes anything.

       git tag v1.1.0
       git push origin v1.1.0

7. **Watch it finish** at <https://github.com/ozankiratli/Resume-ATS-Friendly/actions>, then open the release page and check the body and the four files.

## When the workflow fails

Nothing has been published: the release is created by the last step, after every check. Fix it on `main`, then move the tag to the fixed commit:

    git tag -d v1.1.0
    git push origin :refs/tags/v1.1.0
    git tag v1.1.0
    git push origin v1.1.0

Once a release is published, do not edit it. A mistake there is fixed by releasing the next patch number.
