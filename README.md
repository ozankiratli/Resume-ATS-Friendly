# drevo — ATS-Friendly LaTeX Resume & Cover Letter

[![License: LPPL 1.3c](https://img.shields.io/badge/License-LPPL%201.3c-blue.svg)](http://www.latex-project.org/lppl/)
[![Version](https://img.shields.io/badge/version-v1.0.0-green.svg)](https://github.com/ozankiratli/Resume-ATS-Friendly/releases/tag/v1.0.0)

A modern, ATS-friendly LaTeX document class for resumes/CVs and cover letters, built on top of [moderncv](https://ctan.org/pkg/moderncv). Designed to maximize readability by Applicant Tracking Systems while still producing a clean, professional-looking document.

---

## ✨ Features

- **ATS-friendly** — avoids tables and complex layouts that confuse parsers; uses semantic, linear text flow
- **Two document classes** — `drevoresumecv` for resumes/CVs, `drevocover` for cover letters
- **Specialized section commands** — purpose-built commands for experience, education, skills, honors, talks, outreach, and more
- **Auto-generated smart footer** — name, email, and social links built automatically from preamble declarations
- **Multi-page aware** — smart footer shows page numbers and full socials on even pages
- **Flexible name formatting** — supports prefix (Dr., Prof.), middle name, and suffix (Jr., Ph.D.)
- **Biblatex integration** — publications section with author highlighting out of the box
- **Highly customizable** — fine-grained length controls for spacing, indentation, column widths

---

## 📋 Prerequisites

You need a LaTeX distribution with the following packages available:

- `moderncv`
- `sourcesanspro`
- `biblatex` with `biber` backend (resume class only)
- `geometry`, `inputenc`, `fontenc`
- `multicol`, `enumitem`, `xcolor`, `amssymb`, `array`, `ifthen`
- `lastpage`, `tabto`, `fancyhdr`, `needspace`, `setspace`, `import`

All of these are included in a standard **TeX Live** or **MiKTeX** installation.

### Recommended Compiler

```
lualatex  →  biber  →  lualatex  →  lualatex
```

Or with `pdflatex`:

```
pdflatex  →  biber  →  pdflatex  →  pdflatex
```

---

## 📁 File Structure

```
Resume-ATS-Friendly/
├── drevoresumecv.cls     # Resume/CV document class
├── drevocover.cls        # Cover letter document class
├── Resume.tex            # Example resume
├── CoverLetter.tex       # Example cover letter
├── MyPublications.bib    # Example bibliography file
├── Resume.pdf            # Compiled example resume
└── CoverLetter.pdf       # Compiled example cover letter
```

---

## 🚀 Quick Start

### Resume

```latex
\documentclass[details]{drevoresumecv}

% Personal info
\firstname{Jane}
\middlename{A.}
\lastname{Doe}
\title{Software Engineer}
\email{jane.doe@example.com}
\phone[mobile]{+1~(555)~123~4567}
\address{New York}{NY}{USA}

% Social links (also auto-populate the footer)
\linkedin{janedoe}
\github{janedoe}
\website{janedoe.dev}

% Bibliography for publications
\addbibresource{MyPublications.bib}

\begin{document}

\begin{cvsection}{Experience}
  \cvexperience{2022 -- Present}{Senior Engineer}{Acme Corp.}{New York, NY}{Full-time}{
    \cvlistitem{Led migration of monolithic app to microservices.}
    \cvlistitem{Reduced deployment time by 40\%.}
  }
\end{cvsection}

\begin{cvsection}{Education}
  \cveducation{2018 -- 2022}{B.S. Computer Science}{State University}{New York, NY}{GPA: 3.9/4.0}{}
\end{cvsection}

\begin{cvsection}{Skills}
  \cvskilllist{Languages}{Python, C++, Rust, Go}
  \cvskilllist{Tools}{Docker, Kubernetes, Git, CI/CD}
\end{cvsection}

\end{document}
```

### Cover Letter

```latex
\documentclass[details]{drevocover}

\firstname{Jane}
\lastname{Doe}
\email{jane.doe@example.com}

\coverdate{March 26, 2026}
\coverrecipient{Hiring Manager \\ Acme Corp. \\ New York, NY}
\coveropening{Dear Hiring Manager,}
\coverclosing{Sincerely,}

\begin{document}

\coverparagraph{
  I am writing to express my interest in the Senior Engineer position at Acme Corp...
}

\coverparagraph{
  My experience in distributed systems aligns well with your requirements...
}

\end{document}
```

---

## 📖 Command Reference

### Preamble — Personal Info

These commands are shared by both classes and must be set before `\begin{document}`.

| Command | Description |
|---|---|
| `\firstname{text}` | First name |
| `\middlename{text}` | Middle name(s) — optional |
| `\lastname{text}` | Last name |
| `\nameprefix{text}` | Name prefix, e.g. `Dr.` — optional |
| `\namesuffix{text}` | Name suffix, e.g. `Jr.`, `Ph.D.` — optional |
| `\shortname{text}` | Override auto-generated footer name — optional |
| `\title{text}` | Professional title shown under name |
| `\email{address}` | Email address |
| `\phone[type]{number}` | Phone number; `type` is `mobile`, `fixed`, or `fax` |
| `\address{street}{city}{country}` | Mailing address |
| `\linkedin{handle}` | LinkedIn username (sets social + footer) |
| `\github{handle}` | GitHub username (sets social + footer) |
| `\website{url}` | Personal website, without `https://` |

---

### `drevoresumecv` — Resume Commands

#### `\cvsummary`

A short professional summary at the top of the resume.

```latex
\cvsummary{
  Experienced software engineer with 6+ years building distributed systems...
}
```

| Argument | Description |
|---|---|
| `[gap]` | Optional — vertical space after (default: `\itemsgap`) |
| `{text}` | Summary text |

---

#### `\cvexperience`

Work experience entry with optional bullet list.

```latex
\cvexperience{2022 -- Present}{Senior Engineer}{Acme Corp.}{New York, NY}{Full-time}{
  \cvlistitem{Designed and deployed a real-time data pipeline handling 1M events/day.}
  \cvlistitem{Mentored 3 junior engineers.}
}
```

| Argument | Description |
|---|---|
| `[gap]` | Optional — vertical space after |
| `{date}` | Date range, e.g. `Jan 2020 -- Mar 2022` |
| `{title}` | Job title (bold) |
| `{organization}` | Company or institution name |
| `{location}` | City, State or City, Country |
| `{type}` | Employment type, e.g. `Full-time`, `Internship` |
| `{items}` | Bullet list using `\cvlistitem{...}`; pass empty `{}` to omit |

---

#### `\cveducation`

Education entry with optional note line.

```latex
\cveducation{2018 -- 2022}{B.S. Computer Science}{State University}{New York, NY}{GPA: 3.9/4.0}{}
```

| Argument | Description |
|---|---|
| `[gap]` | Optional — vertical space after |
| `{date}` | Graduation year or date range |
| `{degree}` | Degree and field (bold) |
| `{institution}` | University or school |
| `{location}` | City, State |
| `{note}` | Additional info, e.g. thesis title or GPA; pass `{}` to omit |

---

#### `\cvskilllist`

A labeled skill row with a tab-aligned value column.

```latex
\cvskilllist{Programming}{Python, Rust, Go, C++}
\cvskilllist{Tools}{Docker, Kubernetes, Terraform}
```

| Argument | Description |
|---|---|
| `[gap]` | Optional — vertical space after |
| `{label}` | Category label (bold) |
| `{skills}` | Comma-separated skill list |

The label column width is controlled by `\skillscolumnlength` (default `2in`).

---

#### `\cvhonors`

Award or honor entry.

```latex
\cvhonors{2023}{Best Paper Award}{IEEE Conference}{Optional subtitle}{MIT Press}{Boston, MA}
```

| Argument | Description |
|---|---|
| `[gap]` | Optional — vertical space after |
| `{date}` | Year or date |
| `{title}` | Award title (bold) |
| `{subtitle}` | Optional subtitle; pass `{}` to omit |
| `{organization}` | Awarding organization |
| `{location}` | City, State |

---

#### `\cvtalk`

Invited talk or presentation entry.

```latex
\cvtalk{2024}{Scaling ML Systems}{Jane Doe, John Smith}{International AI Conference}{Chicago, IL}
```

| Argument | Description |
|---|---|
| `[gap]` | Optional — vertical space after |
| `{date}` | Year or date |
| `{title}` | Talk title (bold) |
| `{authors}` | Presenter names |
| `{venue}` | Conference or event name |
| `{location}` | City, State |

---

#### `\cvoutreach`

Outreach or service entry with optional bullet list.

```latex
\cvoutreach{2023 -- Present}{Workshop Organizer}{Graduate Women in CS}{
  \cvlistitem{Organized monthly networking events for 50+ participants.}
}
```

| Argument | Description |
|---|---|
| `[gap]` | Optional — vertical space after |
| `{date}` | Date range |
| `{title}` | Role or event title (bold) |
| `{organization}` | Host organization |
| `{items}` | Bullet list using `\cvlistitem{...}`; pass `{}` to omit |

---

#### `\cvmembership`

Simple membership or affiliation line.

```latex
\cvmembership{2020 -- Present}{ACM, IEEE, SIAM}
```

| Argument | Description |
|---|---|
| `[gap]` | Optional — vertical space after |
| `{date}` | Date range |
| `{text}` | Membership description |

---

#### `\cvhobby`

Hobby or personal interest entry with optional bullet list.

```latex
\cvhobby{}{Rock Climbing}{
  \cvlistitem{Lead climber, 5.11 grade.}
}
```

| Argument | Description |
|---|---|
| `[gap]` | Optional — vertical space after |
| `{date}` | Date (often left empty `{}`) |
| `{title}` | Hobby name (bold) |
| `{items}` | Bullet list; pass `{}` to omit |

---

#### `cvsection` Environment

Wraps any block in a named section with a decorative rule.

```latex
\begin{cvsection}{Publications}
  \nocite{*}
  \printbibliography[heading=none]
\end{cvsection}
```

---

#### Publications with Author Highlighting

In your `.bib` file, annotate your own name:

```bibtex
@article{doe2024,
  author+an = {1=highlight},
  author = {Doe, Jane and Smith, John},
  ...
}
```

The highlighted author will be rendered in **bold**.

---

### `drevocover` — Cover Letter Commands

These must be set in the preamble (before `\begin{document}`).

| Command | Description |
|---|---|
| `\coverdate{text}` | Date shown at top of letter |
| `\coverrecipient{text}` | Recipient block; use `\\` for line breaks |
| `\coveropening{text}` | Salutation, e.g. `Dear Hiring Manager,` |
| `\coverclosing{text}` | Closing, e.g. `Sincerely,` |

In the document body, use `\coverparagraph{text}` for each paragraph:

```latex
\coverparagraph{First paragraph of body...}
\coverparagraph{Second paragraph...}
```

The signature is generated automatically from your name declarations. The date, recipient, opening, and closing are also inserted automatically.

---

## ⚙️ Class Options

Both classes accept:

| Option | Description |
|---|---|
| `details` | *(default)* Show address, phone, email, and socials in the header |
| `nodetails` | Hide contact details from the header (name and title only) |

```latex
\documentclass[nodetails]{drevoresumecv}
```

---

## 🎨 Customization

### Spacing Controls (`drevoresumecv`)

Override these lengths in your preamble after `\documentclass`:

```latex
\setlength{\titlespacing}{0pt}         % Space after header before first section
\setlength{\pageonesectionspacing}{0pt} % Extra space between sections on page 1
\setlength{\pagetwosectionspacing}{0pt} % Extra space between sections on page 2+
\setlength{\itemsleftindent}{2em}       % Left indent for bullet items
\setlength{\itemsrightindent}{0pt}      % Right indent for bullet items
\setlength{\itemslistgapbefore}{3pt}    % Gap before bullet list
\setlength{\itemslistgapafter}{3pt}     % Gap after bullet list
\setlength{\itemsgap}{.2em}             % Default gap after each cv entry
\setlength{\skillscolumnlength}{2in}    % Width of skill label column
\renewcommand{\itemspread}{0.95}        % Line spread inside bullet lists
```

### Spacing Controls (`drevocover`)

```latex
\setlength{\coverdateabovespace}{0pt}       % Space above date
\setlength{\coverrecipientspace}{1em}       % Space around recipient block
\setlength{\coverparskip}{1em}             % Space between paragraphs
\setlength{\coversignatureabovespace}{2em}  % Space above signature
```

### Helper Commands

```latex
\addspacepageone   % Insert \pageonesectionspacing of vertical space
\addspacepagetwo   % Insert \pagetwosectionspacing of vertical space
\removeonelinespace % Remove 1em of vertical space (fine-tuning)
\CPP               % Pretty-print C++ in text
```

---

## 📄 License

This work is distributed under the [LaTeX Project Public License, version 1.3c](http://www.latex-project.org/lppl/).

Copyright 2022–2026 Ozan L. Z. Kiratli.

---

## 🙏 Acknowledgments

Built on top of [moderncv](https://ctan.org/pkg/moderncv) by Xavier Danaux, with customized snippets from `moderncvheadiii` and `moderncvbodyi`.
