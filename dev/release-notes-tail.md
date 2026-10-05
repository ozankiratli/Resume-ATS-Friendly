<!-- The standing tail of every GitHub release body: the part that does not change from release to release. The part that does is this version's CHANGELOG.md section, which dev/scripts/changelog-section.sh extracts and release.yml puts above this.

@VERSION@ and @NAME@ are substituted by release.yml. This lives in a file rather than inside the workflow because it is markdown full of backticks, which a YAML block scalar and a shell heredoc each mangle in their own way.

The engines named below are the ones in ENGINES in dev/tests/run.sh; the two change together. The sentence on where this release compiled is true because step 1 of dev/RELEASING.md runs the suite in every environment; nothing in release.yml checks it.
-->

## Download

- **`@NAME@.zip`** -- the template: both classes, the example `Resume.tex` and `CoverLetter.tex`, `MyPublications.bib`, the README and the license. Unzip it and compile, or upload it to Overleaf as a new project.
- **`Resume.pdf`** and **`CoverLetter.pdf`** -- the examples, as they stand at this release.

Verify what you downloaded with `sha256sum -c --ignore-missing SHA256SUMS`.

Before it was published, this release compiled without errors with pdfLaTeX, on the TeX Live of Ubuntu's current and previous LTS, on the current TeX Live release, and on the latest CTAN packages.

## Compile

```bash
latexmk -pdf Resume.tex
latexmk -pdf CoverLetter.tex
```

`latexmk` runs `biber` for the resume's publication list on its own. Without it: `pdflatex`, `biber`, `pdflatex`, `pdflatex`.

The full changelog is in `CHANGELOG.md`, in the download and in the repository.
