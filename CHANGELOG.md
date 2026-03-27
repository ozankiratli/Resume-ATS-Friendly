# Changelog

All notable changes to this project will be documented in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] — 2026-03-26

### Initial release

This is the first stable release of the **drevo** LaTeX resume and cover letter package.

#### Added — `drevoresumecv.cls`
- Custom resume document class based on `moderncv` (classic theme, black color scheme)
- Centered header with support for name prefix, middle name, suffix, title, and contact details
- `details` / `nodetails` class option to toggle contact info in the header
- `cvsection` environment for named, ruled resume sections
- `\cvexperience` — work experience entry with date, title, organization, location, type, and optional bullet list
- `\cveducation` — education entry with degree, institution, location, and optional note
- `\cvskilllist` — tab-aligned skill category rows with configurable label column width
- `\cvhonors` — award and honor entries
- `\cvtalk` — invited talk and presentation entries
- `\cvoutreach` — outreach and service entries with optional bullet list
- `\cvmembership` — simple membership or affiliation line
- `\cvhobby` — hobby entries with optional bullet list
- `\cvsummary` — professional summary block
- `biblatex` integration with author highlighting via `+an` annotations
- Smart multi-page footer: name + email on odd pages; name + email + social links on even pages
- Automatic footer name construction from name parts, with `\shortname` override
- `\linkedin`, `\github`, `\website` commands that populate both the header and footer
- Fine-grained length controls: `\itemsleftindent`, `\itemsrightindent`, `\itemsgap`, `\skillscolumnlength`, `\itemspread`, `\titlespacing`, `\pageonesectionspacing`, `\pagetwosectionspacing`
- `\CPP` command for typographically correct C++ in text
- `\addspacepageone`, `\addspacepagetwo`, `\removeonelinespace` spacing helpers

#### Added — `drevocover.cls`
- Custom cover letter document class based on `moderncv`
- Shared header with `drevoresumecv` — same name, title, and contact display
- `\coverdate`, `\coverrecipient`, `\coveropening`, `\coverclosing` preamble commands
- `\coverparagraph` command for body paragraphs with automatic spacing
- Auto-generated signature from name declarations
- Simple centered footer with name and email
- Configurable spacing: `\coverdateabovespace`, `\coverrecipientspace`, `\coverparskip`, `\coversignatureabovespace`

---

[1.0.0]: https://github.com/ozankiratli/Resume-ATS-Friendly/releases/tag/v1.0.0
