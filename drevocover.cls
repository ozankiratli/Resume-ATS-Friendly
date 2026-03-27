%% start of file `drevocover.cls'.
%% Copyright 2022-2025 Ozan L. Z. Kiratli (ozankiratli@protonmail.com).
%
% This work may be distributed and/or modified under the
% conditions of the LaTeX Project Public License version 1.3c,
% available at http://www.latex-project.org/lppl/.
%
% This work uses customized snippets from moderncvheadiii and moderncvbodyi

%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
% Identification
%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{drevocover}[2025/02/14 evo's custom cover letter class]

\LoadClass[11pt, letterpaper, oneside]{moderncv}

\moderncvtheme{classic}
\moderncvcolor{black}
\nopagenumbers{}

\RequirePackage[margin=0.5in]{geometry}
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage[default]{sourcesanspro}
\RequirePackage{import}
\RequirePackage{multicol}
\RequirePackage{enumitem}
\RequirePackage{xcolor}
\RequirePackage{amssymb}
\RequirePackage{array}
\RequirePackage{ifthen}
\RequirePackage{lastpage}
\RequirePackage{tabto}
\RequirePackage{fancyhdr}

\pagestyle{fancy}

% details options: "details" (default) or "nodetails"
\@initializeif{\if@details}\@detailsfalse
\DeclareOption{details}{\@detailstrue}
\DeclareOption{nodetails}{\@detailsfalse}

\DeclareOption*{}% avoid choking on unknown options
\ExecuteOptions{details}
\ProcessOptions*\relax% \ProcessOptions* processes the options in the order provided (i.e., with the later ones possibly overriding the former ones), while \ProcessOptions processes them in the order of the package


\DeclareRobustCommand{\ebseries}{\fontseries{eb}\selectfont}
\DeclareTextFontCommand{\texteb}{\ebseries}
\DeclareRobustCommand{\sbseries}{\fontseries{sb}\selectfont}
\DeclareTextFontCommand{\textsb}{\sbseries}
\DeclareRobustCommand{\elseries}{\fontseries{el}\selectfont}
\DeclareTextFontCommand{\textel}{\elseries}
\DeclareRobustCommand{\lseries}{\fontseries{l}\selectfont}
\DeclareTextFontCommand{\textl}{\lseries}

\renewcommand*{\namefont}{\huge\bfseries\upshape}
\renewcommand*{\titlefont}{\LARGE\mdseries\scshape}
\renewcommand*{\addressfont}{\small\mdseries\upshape}
\renewcommand*{\quotefont}{\large\slshape}

\renewcommand*{\sectionfont}{\Large\mdseries\scshape}
\renewcommand*{\hintfont}{}

\renewcommand*{\namestyle}[1]{{\namefont\textcolor{color1}{#1}}}
\renewcommand*{\titlestyle}[1]{{\titlefont\textcolor{color2!85}{#1}}}
\renewcommand*{\addressstyle}[1]{{\addressfont\textcolor{color2}{#1}}}
\renewcommand*{\quotestyle}[1]{{\quotefont\textcolor{color1}{#1}}}
\renewcommand*{\addresssymbol}{{{\color[HTML]{909090}\small\faHome}}~}

\definecolor{lightgrey}{RGB}{192,192,192}

\newlength{\titlespacing}
\setlength{\titlespacing}{0pt}

\newcommand*{\nameprefix}[1]{\def\@nameprefix{#1}}
\newcommand*{\middlename}[1]{\def\@middlename{#1}}
\newcommand*{\namesuffix}[1]{\def\@namesuffix{#1}}

\newcommand{\removeonelinespace}{\vspace{-1em}}

%make "C++" look pretty when used in text by touching up the plus signs
\newcommand{\CPP}{C\nolinebreak[4]\hspace{-.05em}\raisebox{.05ex}{\footnotesize\textbf{++}}~}


%-------------------------------------------------------------------------------
% Head definition
%-------------------------------------------------------------------------------

\@initializecommand{\makeheaddetailssymbol}{%
    {~~~{\rmfamily\textbullet}~~~}}%
\@initializebox{\makeheaddetailsbox}%
\@initializebox{\makeheaddetailstempbox}%
\@initializelength{\makeheaddetailswidth}%
\@initializelength{\makeheaddetailsboxwidth}%
\@initializeif{\if@firstmakeheaddetailselement}\@firstmakeheaddetailselementtrue%
\newcommand*{\addtomakeheaddetails}[2][\makeheaddetailssymbol]{%
  \if@firstmakeheaddetailselement%
    \savebox{\makeheaddetailstempbox}{\usebox{\makeheaddetailsbox}#2}%
  \else%
    \savebox{\makeheaddetailstempbox}{\usebox{\makeheaddetailsbox}#1#2}\fi%
  \settowidth{\makeheaddetailsboxwidth}{\usebox{\makeheaddetailstempbox}}%
  \ifnum\makeheaddetailsboxwidth<\makeheaddetailswidth%
    \savebox{\makeheaddetailsbox}{\usebox{\makeheaddetailstempbox}}%
    \@firstmakeheaddetailselementfalse%
  \else%
    \flushmakeheaddetails\\%
    \savebox{\makeheaddetailsbox}{#2}%
    \savebox{\makeheaddetailstempbox}{#2}%
    \settowidth{\makeheaddetailsboxwidth}{\usebox{\makeheaddetailsbox}}%
    \@firstmakeheaddetailselementfalse\fi}
\@initializecommand{\flushmakeheaddetails}{%
  \ifnum\makeheaddetailsboxwidth>0%
    \strut\usebox{\makeheaddetailsbox}%
    \savebox{\makeheaddetailsbox}{}%
    \savebox{\makeheaddetailstempbox}{}%
    \setlength{\makeheaddetailsboxwidth}{0pt}\fi}

\@initializecommand{\makehead}{%
  \setlength{\makeheaddetailswidth}{0.9\textwidth}%
  \hfil%
  \parbox{\makeheaddetailswidth}{%
    \centering%
    \namestyle{%
  \@ifundefined{@nameprefix}{}{{\@nameprefix~}}%
  \@firstname%
  \@ifundefined{@middlename}{}{~\@middlename}%
  ~\@lastname%
  \@ifundefined{@namesuffix}{}{, \@namesuffix}%
}%
    \ifthenelse{\equal{\@title}{}}{}{\titlestyle{\\\vspace*{.2em}\@title}\\}%
    \if@details{%
      \vspace*{.2em}%
      \addressfont\color{color2}%
      \ifthenelse{\isundefined{\@addressstreet}}{}{\addtomakeheaddetails{\addresssymbol\@addressstreet}%
        \ifthenelse{\equal{\@addresscity}{}}{}{\addtomakeheaddetails[~--~]{\@addresscity}}% if \addresstreet is defined, \addresscity and \addresscountry will always be defined but could be empty
        \ifthenelse{\equal{\@addresscountry}{}}{}{\addtomakeheaddetails[~--~]{\@addresscountry}}}% address stays on same line
      \ifthenelse{\isundefined{\@born}}{}{\addtomakeheaddetails{\bornsymbol\@born}}%
      \collectionloop{phones}{% the key holds the phone type (=symbol command prefix), the item holds the number
        \addtomakeheaddetails{\csname\collectionloopkey phonesymbol\endcsname\collectionloopitem}}%
      \ifthenelse{\isundefined{\@email}}{}{\addtomakeheaddetails{\emailsymbol\emaillink{\@email}}}%
      \ifthenelse{\isundefined{\@homepage}}{}{\addtomakeheaddetails{\homepagesymbol\httpslink{\@homepage}}}%
      \collectionloop{socials}{
        \addtomakeheaddetails{\csname\collectionloopkey socialsymbol\endcsname\collectionloopitem}}%
      \ifthenelse{\isundefined{\@extrainfo}}{}{\addtomakeheaddetails{\@extrainfo}}%
\flushmakeheaddetails}\fi}}%

%-------------------------------------------------------------------------------
% Resume head definition
%-------------------------------------------------------------------------------
% lengths
\@initializelength{\quotewidth}
\renewcommand*{\recomputecvheadlengths}{%
  \setlength{\quotewidth}{0.65\textwidth}}

% commands
\renewcommand*{\makecvhead}{% TODO: use \@initializecommand, which requires modifying its definition to handle \pae
  % recompute lengths (in case we are switching from letter to resume, or vice versa)
  %\recomputecvlengths%
  \makehead%
  % optional quote
  \ifthenelse{\isundefined{\@quote}}%
    {}%
    {{\centering\begin{minipage}{\quotewidth}\centering\quotestyle{\@quote}\end{minipage}\\}}%
  \par}

%-------------------------------------------------------------------------------
%                Cover letter spacing parameters
%-------------------------------------------------------------------------------
\newlength{\coverdateabovespace}
\setlength{\coverdateabovespace}{0pt}  % Space above date

\newlength{\coverrecipientspace}
\setlength{\coverrecipientspace}{1em}  % Space above and below recipient

\newlength{\coverparskip}
\setlength{\coverparskip}{1em}  % Space between paragraphs (also after opening, before closing)

\newlength{\coversignatureabovespace}
\setlength{\coversignatureabovespace}{2em}  % Space above signature (default: 2x paragraph spacing)

%-------------------------------------------------------------------------------
%                Cover letter commands (set before \begin{document})
%-------------------------------------------------------------------------------
\newcommand*{\coverdate}[1]{\def\@coverdate{#1}}
\newcommand*{\coverrecipient}[1]{\def\@coverrecipient{#1}}
\newcommand*{\coveropening}[1]{\def\@coveropening{#1}}
\newcommand*{\coverclosing}[1]{\def\@coverclosing{#1}}
\newcommand*{\coverparagraph}[1]{%
  #1\par%
  \vspace{\coverparskip}%
}

% Auto-generate signature from name
\newcommand*{\@coversignature}{%
  \@ifundefined{@nameprefix}{}{~\@nameprefix~}%
  \@firstname%
  \@ifundefined{@middlename}{}{~\@middlename}%
  \@ifundefined{@familyname}{}{~\@familyname}%
  \@ifundefined{@namesuffix}{}{, \@namesuffix}%
}

%-------------------------------------------------------------------------------
%                Generate cover letter content
%-------------------------------------------------------------------------------
\newcommand*{\makecoverheader}{%
  % Date
  \vspace*{\coverdateabovespace}%
  \@ifundefined{@coverdate}{}{\@coverdate\par}%
  
  % Recipient
  \@ifundefined{@coverrecipient}{}{%
    \vspace{\coverrecipientspace}%
    \@coverrecipient%
    \vspace{\coverrecipientspace}%
  }%
  
  % Opening
  \@ifundefined{@coveropening}{}{\@coveropening\par}%
  \vspace{\coverparskip}
}


\newcommand*{\makecoversignature}{%
  % Closing
  \vspace{\coverparskip}%
  \@ifundefined{@coverclosing}{}{\@coverclosing\par}%
  % Signature
  \vspace{\coversignatureabovespace}%
  \@coversignature%
}

%-------------------------------------------------------------------------------
%                Automatic fancy footer generation
%-------------------------------------------------------------------------------


\newcommand*{\shortname}[1]{\def\@shortname{#1}}

% Helper to extract first character
\def\@firstchar#1#2\@nil{#1}

% Helper command to extract initials from middle names
\def\@extractmiddleinitials#1{%
  \expandafter\@extractmiddleinitials@aux#1 \@nil%
}

\def\@extractmiddleinitials@aux#1 #2\@nil{%
  \if\relax\detokenize{#1}\relax% If #1 is empty
  \else%
    ~\expandafter\@firstchar#1\@nil.% Extract first character and add period
    \if\relax\detokenize{#2}\relax% If no more names
    \else%
      \@extractmiddleinitials@aux#2\@nil% Recurse
    \fi%
  \fi%
}

% Command to get display name for footer
\newcommand*{\@getfootername}{%
  \@ifundefined{@shortname}{%
    % If no shortname, build it automatically
    \@firstname%
    \@ifundefined{@middlename}{}{%
      \@extractmiddleinitials{\@middlename}%
    }%
    \@ifundefined{@familyname}{}{~\@familyname}%
  }{%
    % Use shortname if defined
    \@shortname%
  }%
  % Add suffix if exists
  \@ifundefined{@namesuffix}{}{, \@namesuffix}%
}

\newcommand*{\website}[1]{%
  %\def\@websiteurl{#1}%
  \homepage{#1}%
}

\newcommand*{\github}[1]{%
  \social[github]{#1}% Automatically set \social as well
}
\newcommand*{\linkedin}[1]{%
  \social[linkedin]{#1}% Automatically set \social as well
}


% Setup fancy footer
\newcommand*{\setupfancyfooter}{%
  \fancyhf{}% Clear all headers and footers
  
  % Center footer odd pages (CO): Name and email
  \fancyfoot[C]{%
    \vspace{-14pt}%
    {\footnotesize{\textsc{\@getfootername}}}%
    \@ifundefined{@email}{}{%
      \quad\textbullet\quad%
      {\footnotesize\textsc{\href{mailto:\@email}{\@email}}}%
    }%
  } 
}

%-------------------------------------------------------------------------------
%                Set paragraph spacing for document body
%-------------------------------------------------------------------------------
\AtBeginDocument{%
  \setupfancyfooter%
}

\AtEndPreamble{%
  \AtBeginDocument{%
    \setlength{\parskip}{\coverparskip}%
    \setlength{\parindent}{0pt}%
    \makecvtitle%
    \vspace*{\titlespacing}%
    \makecoverheader%
  }%
}

\AtEndDocument{%
  \makecoversignature%
}

\endinput














%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
% Required packages
%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
% Settings and Declarations
%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
% Fonts and Styles
%-------------------------------------------------------------------------------



%-------------------------------------------------------------------------------
% Body definitions
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
% Resume body definitions
%-------------------------------------------------------------------------------
