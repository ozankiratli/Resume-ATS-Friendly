# Changelog

All notable changes to the drevo resume and cover letter classes will be documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

**How to read the version.** What a version number promises here is about your `.tex` file: the commands and class options it uses, and the page they produce.

- The third number (x.x.**c**): something fixed or tidied. Your file compiles unchanged and looks the same, or better where something was wrong.
- The second number (x.**b**.x): a new command, option or length. Your file compiles unchanged, but spacing or layout may shift, so look at the PDF before sending it.
- The first number (**a**.x.x): a command or option renamed, removed, or taking different arguments. Your file needs editing to compile.

A version moves when something changes, never on a schedule.

---

## [1.0.0] - 2026-03-26

**The first stable release of the drevo LaTeX resume and cover letter classes.** Two document classes built on `moderncv` that share one header, so a resume and its cover letter match.

### Added

**`drevoresumecv.cls`**, the resume class:

- **A resume class based on `moderncv`**, classic theme, black color scheme.
- **A centered header** with name prefix, middle name, suffix, title, and contact details. The `details` / `nodetails` class option toggles the contact line.
- **The `cvsection` environment** for named, ruled resume sections.
- **Entry commands**: `\cvexperience` (date, title, organization, location, type, and an optional bullet list), `\cveducation` (degree, institution, location, and an optional note), `\cvskilllist` (tab-aligned skill rows with a configurable label column), `\cvhonors`, `\cvtalk`, `\cvoutreach` (with an optional bullet list), `\cvmembership`, `\cvhobby` (with an optional bullet list), and `\cvsummary`.
- **Publications through `biblatex`**, with your own name highlighted by `+an` annotations.
- **A multi-page footer**: name and email on odd pages; name, email and social links on even pages. The footer name is built from the name parts, and `\shortname` overrides it.
- **`\linkedin`, `\github` and `\website`**, which fill both the header and the footer.
- **Length controls**: `\itemsleftindent`, `\itemsrightindent`, `\itemsgap`, `\skillscolumnlength`, `\itemspread`, `\titlespacing`, `\pageonesectionspacing`, `\pagetwosectionspacing`.
- **Spacing helpers**: `\addspacepageone`, `\addspacepagetwo`, `\removeonelinespace`.
- **`\CPP`**, for a typographically correct C++ in running text.

**`drevocover.cls`**, the cover letter class:

- **A cover letter class based on `moderncv`**, with the same header as `drevoresumecv`: same name, title, and contact display.
- **Preamble commands**: `\coverdate`, `\coverrecipient`, `\coveropening`, `\coverclosing`.
- **`\coverparagraph`** for body paragraphs, spaced automatically.
- **A signature generated from the name declarations**, and a centered footer with name and email.
- **Spacing controls**: `\coverdateabovespace`, `\coverrecipientspace`, `\coverparskip`, `\coversignatureabovespace`.

### Commits

- (d4783fe) Initial commit
- (779487a) Files of a working template added
- (03cb1ba) README update
- (86c7cd2) Update README.md
- (f3c7be6) Update README.md
- (0985219) Small edits and files renamed
- (2e2c5d4) Small edits and files renamed
- (a60cc54) - Multiple errors fixed. - More intuitive commands added. - Headers and footers  moved to cls. - Added matching cover letter template.
- (074aa8b) Minor fixes, website handle added
- (15e02e3) Author annotation
- (7b1f9c5) LICENSE and CHANGELOG

---

[1.0.0]: https://github.com/ozankiratli/Resume-ATS-Friendly/releases/tag/v1.0.0
