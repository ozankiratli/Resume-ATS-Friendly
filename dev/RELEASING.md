# Releasing Resume-ATS-Friendly

One workflow, `.github/workflows/release.yml`, runs when a `v*` tag is pushed. It checks that the CHANGELOG describes the version and that the tag still names the commit it built, then publishes a GitHub release. A push to a branch runs nothing. The test suite is not part of it: it runs here, on your machine, in step 1.

The release body is this version's `CHANGELOG.md` section with `dev/release-notes-tail.md` below it. What you write in the CHANGELOG is what the release page says.

## The test suite

The suite compiles both documents with pdfLaTeX, the one engine the template supports, and lists the errors and warnings, not only the first. It runs here, on your machine:

    dev/tests/run.sh                                    # this machine's TeX Live
    dev/tests/run.sh --env all --out .tmp/resume-suite  # every environment, in Docker
    dev/tests/run.sh --clean                            # free the space afterwards

The environments, chosen by who uses them:

| Name | What it is |
|---|---|
| `ubuntu-24.04` | Ubuntu's previous LTS, TeX Live from apt |
| `ubuntu-26.04` | Ubuntu's current LTS, TeX Live from apt |
| `arch` | the current TeX Live release, from Arch's packages: what this machine runs |
| `latest-ctan` | a TeX Live image updated to today's CTAN packages: what MiKTeX and tlmgr users have |

They are defined in `dev/tests/run.sh`, in two places: `ENVIRONMENTS` lists them, and `environment()` says what each one is. A new environment needs both; `run.sh --list` refuses a name that `environment()` does not describe. When Ubuntu releases a new LTS, both Ubuntu entries move up one, and a workaround for an old package version can go once the previous LTS no longer has that version.

`--env` takes one name, several separated by commas, or `all`. Each environment runs in a throwaway container: its base image is pulled, TeX Live is installed into the container the way that environment installs it, the suite runs, and the container is removed with everything installed in it. Nothing is reused, so every run is fresh, and every run installs TeX Live again, which takes a few minutes per environment. While you test a fix, run only the environment that fails. Ctrl-C removes the running container and stops the run.

At the end of an `--env` run there is one table per environment, with a row per document and engine: result, page count, errors, warnings, and the moderncv, icon, font and biblatex versions it compiled with. Below a table, every check that failed is listed with what it printed, so the reasons are still there when the terminal has scrolled past them; the same is in each environment's `summary.md` under `--out`. Errors are listed up to 60 lines per document. With `--out`, each environment has its own directory holding one per engine, today only `pdflatex/`, with the PDFs and the whole logs, and the TeX Live installation's output in `setup.log`. What an earlier run left there is removed first.

The base images are all a run leaves behind. They are kept between runs, and when a pull brings a newer one, the copy it replaces is removed. `--clean` removes them, to free the space when no testing is going on; the next run pulls them again. Neither ever forces a removal, so an image a container still uses stays.

Docker runs through sudo, as `sudo docker`. sudo asks for your password at the start of a run, and again if a run outlasts its timeout, so stay with a run while it goes. `DOCKER=docker` runs it without sudo, for a user in the `docker` group.

## What is attached to a release

- **`Resume.pdf`** and **`CoverLetter.pdf`** -- as committed at the tag: the ones you looked at in step 1.
- **`Resume-ATS-Friendly-<version>.zip`** -- the template as committed at the tag: both classes, both example `.tex` files and their PDFs, the `.bib`, README, LICENSE and CHANGELOG. `dev/` and `.github/` are left out by `.gitattributes`.
- **`SHA256SUMS`** -- for the three files above.

## Each release

1. **Run the suite in every environment, then compile both documents and look at them.**

       dev/tests/run.sh --env all --out .tmp/resume-suite
       latexmk -pdf Resume.tex
       latexmk -pdf CoverLetter.tex

   Every environment must pass. If the change touched layout, open the PDFs under `.tmp/resume-suite/` as well: a page count that differs between environments or engines is the first sign, and a line that moves to the next page is the second. The two `latexmk` runs make the PDFs to open and commit. The suite can tell a document compiled; only you can tell it looks right. When the release is out, `dev/tests/run.sh --clean` frees the space the base images take.

2. **Start the CHANGELOG section.**

       dev/scripts/bump-version.sh 1.1.0

   It prepends a `## [1.1.0] - <date>` section holding every commit since the last tag under `### Commits`, and adds the reference link at the foot. It does not commit, tag or push. Pick the number by the "How to read the version" note at the top of the CHANGELOG.

3. **Write the notes** into that section, **above** its `### Commits` heading and not over it. A bold lead paragraph, then `### Added`, `### Changed`, `### Fixed`, `### Removed` as they apply. Anything a user has to change in their own `.tex` file goes first.

   Check it extracts, because the workflow refuses a version the CHANGELOG does not describe:

       dev/scripts/changelog-section.sh 1.1.0

4. **Commit and push the branch.**

       git add -A && git commit -m 'Version bump 1.1.0'
       git push origin main

5. **Rehearse it.** From the Actions tab, run **Publish a release** on `main`. It runs the CHANGELOG check, builds the zip and prints the release body, and publishes nothing: only a pushed tag publishes. Read the release body it printed.

6. **Tag it and push the tag.** This is the only step that publishes anything.

       git tag v1.1.0
       git push origin v1.1.0

7. **Watch it finish** at <https://github.com/ozankiratli/Resume-ATS-Friendly/actions>, then open the release page and check the body and the four files.

## When the workflow fails

Nothing has been published: the release is created by the last step, after every check.

Fix it on `main`. If the fix touches the classes or the documents, go back through step 1 first: the suite in every environment, and both PDFs compiled again, looked at and committed, because the release attaches the committed PDFs. If the fix changes what the release does, add it to the notes from step 3. Push, then move the tag to the fixed commit:

    git tag -d v1.1.0
    git push origin :refs/tags/v1.1.0
    git tag v1.1.0
    git push origin v1.1.0

Once a release is published, do not edit it. A mistake there is fixed by releasing the next patch number.
