\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{evo_cv}[2024/06/20 Dr. evo's custom CV class]
\LoadClass{moderncv}
\ExecuteOptions{letterpaper,11pt,twoside}
%\RequirePackage{bookmark}
\RequirePackage{ifthen}

\moderncvtheme{classic}
\moderncvcolor{black}

%\nopagenumbers{}
%\usepackage{ragged2e
\moderncvhead[\moderncvstyleheadoptions]{6}
\moderncvbody{6}
%\usepackage[colorlinks=false]{hyperref}
\PassOptionsToPackage{pdfpagelabels=false}{hyperref} 
\usepackage[margin=0.5in]{geometry}
\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage[default]{sourcesanspro}
\usepackage{import}
\usepackage{multicol}
\usepackage{enumitem}
\usepackage{xcolor}
\usepackage{amssymb}
\usepackage{array}
\usepackage{lastpage}
\usepackage{tabto}
\usepackage{fancyhdr}
\pagestyle{fancy}

\DeclareRobustCommand{\ebseries}{\fontseries{eb}\selectfont}
\DeclareTextFontCommand{\texteb}{\ebseries}

\DeclareRobustCommand{\sbseries}{\fontseries{sb}\selectfont}
\DeclareTextFontCommand{\textsb}{\sbseries}

\DeclareRobustCommand{\elseries}{\fontseries{el}\selectfont}
\DeclareTextFontCommand{\textel}{\elseries}

\DeclareRobustCommand{\lseries}{\fontseries{l}\selectfont}
\DeclareTextFontCommand{\textl}{\lseries}

%\usepackage[backend=biber,style=apa,natbib=false,maxbibnames=99]{biblatex}
%\addbibresource{MyPublications.bib}
%\renewcommand*{\bibfont}{\small}

\makeatletter
\@ifundefined{thepage}{\def\thepage{\arabic{page}}}{}%
\makeatother

\definecolor{lightgrey}{RGB}{192,192,192}

\newcommand{\CPP}{C\nolinebreak[4]\hspace{-.05em}\raisebox{.05ex}{\footnotesize\textbf{++}}}

\newcommand*{\cvsummary}[2][.1em]{
  {#2}
  \par\addvspace{#1}
}

\newcommand*{\cvexperience}[6][.1em]{
  \setlist[itemize]{itemsep=-2pt,topsep=0pt}
  {\bfseries #3}, {\small #4}, {\itshape \small #5} %
  {\textcolor{lightgrey}{\hrulefill{}}}
  {#2} \\
  \ifx&#6&%
  \else{\
      \begin{minipage}{0.97\linewidth}%
	\small#6%
  \end{minipage}}\fi%
  \par\addvspace{#1}
}

\newcommand*{\cveducation}[6][.1em]{
  \setlist[itemize]{itemsep=-2pt,topsep=0pt}
  {\bfseries #3}, {\small #4}, {\itshape \small #5} {\textcolor{lightgrey}{\hrulefill{}}} {#2}\\
  \ifx&#6&%
  \else{\
    \begin{minipage}{0.97\linewidth}%
      \small#6%
    \end{minipage}}\fi%
  \par\addvspace{#1}
}

\newcommand*{\cvskilllist}[3][.1em]{
  {\bfseries #2:} \tabto{2in} {\small #3} %
  \par\addvspace{#1}
}

\newcommand*{\cvhonors}[5][.1em]{
  \setlist[itemize]{itemsep=-2pt,topsep=0pt}
  {\bfseries #3} {\textcolor{lightgrey}{\hrulefill{}}} {#2}\\
  {\small #4}, {\itshape \small #5}
  \par\addvspace{#1}
}

\newcommand*{\cvmembership}[3][.1em]{
  {#3} {\textcolor{lightgrey}{\hrulefill{}}} {#2}
  \par\addvspace{#1}
}

\newcommand*{\cvtalk}[6][.1em]{
  \setlist[itemize]{itemsep=-2pt,topsep=0pt}
  {``#3''} {\textcolor{lightgrey}{\hrulefill{}}} {#2}\\
  {\small {#4}. {\itshape #5}. {(#6)}}
  \par\addvspace{#1}
}

\newcommand*{\cvoutreach}[5][.1em]{
  \setlist[itemize]{itemsep=-2pt,topsep=0pt}
    {\bfseries #3}, {\itshape \small #4} {\textcolor{lightgrey}{\hrulefill{}}} {#2}\\
  \ifx&#5&%
  \else{\
    \begin{minipage}{0.97\linewidth}%
      \small#5%
    \end{minipage}}\fi%
  \par\addvspace{#1}
}

\newcommand*{\cvhobby}[4][.1em]{
  \setlist[itemize]{itemsep=-2pt,topsep=0pt}
  {{\bfseries #3} {\textcolor{lightgrey}{\hrulefill{}}} {#2}}\\
  \ifx&#4&%
  \else{\
    \begin{minipage}{0.97\linewidth}%
      \small#4%
    \end{minipage}}\fi%
  \par\addvspace{#1}
}

\newcommand{\removeonelinespace}{\vspace{-1em}}


\newcommand{\nameTitle}[1]{%
  \def\varNameTitle{#1}%
}
\newcommand{\getNameTitle}{\varNameTitle}



\newcommand{\firstName}[1]{%
  \def\varFirstName{#1}%
}
\newcommand{\getFirstName}{\varFirstName}

\newcommand{\lastName}[1]{%
  \def\varLastName{#1}%
}
\newcommand{\getLastName}{\varLastName}

%\newcommand{\@emptytest}{}

\newcommand{\nameSuffix}[1]{%
  \def\varNameSuffix{#1}%
}
\newcommand{\getNameSuffix}{\varNameSuffix}

\newcommand{\emailaddress}[1]{%
  \def\varEmail{#1}%
}
\newcommand{\getEmail}{\varEmail}

\newcommand{\profession}[1]{%
  \def\varProfession{#1}%
}
\newcommand{\getProfession}{\textsc{\varProfession}}

\newcommand{\makeFamilyName}{%
  \ifx\varNameSuffix\empty
    \getLastName%
  \else
    \getLastName, \getNameSuffix%
  \fi
}

\newcommand{\footnoteName}{%
    \ifx\varNameSuffix\empty
      \footnotesize{\getNameTitle~\textsc{\getFirstName~\getLastName}}%
    \else
      \footnotesize{\getNameTitle~\textsc{\getFirstName~\getLastName},~\getNameSuffix}%
    \fi
} 

\newcommand{\footnoteLineOne}{%
  \footnoteName%
  \quad\textbullet\quad%
  {\footnotesize\textsc{\href{mailto:\getEmail}{\getEmail}}}%
}

\newcommand{\socialOne}[2]{%
  \def\varSocialOneIcon{#1}%
  \def\varSocialOneFullLink{#2}%
}

\newcommand{\socialTwo}[2]{%
  \def\varSocialTwoIcon{#1}%
  \def\varSocialTwoFullLink{#2}%
}

\firstname{\getNameTitle~\getFirstName}
\familyname{\makeFamilyName}
\email{\getEmail}
\title{\getProfession}

\fancyfoot[R]{\vspace{-14pt}{\small{\thepage/\pageref*{LastPage}}}}

\fancyfoot[CO]{%
  \vspace{-14pt}%
  \footnoteLineOne%
}

\fancyfoot[CE]{%
  \vspace{-23pt}%
  \footnoteLineOne%
  \\{\vspace{-2pt}}
  {\scriptsize\varSocialOneIcon{~~}\url{\varSocialOneFullLink}}
  \quad\textbullet\quad
  {\scriptsize\varSocialTwoIcon{~~}\url{\varSocialTwoFullLink}}
}

%\newcommand{\getSocialPlatformOne}{\varSocialPlatform
%\newcommand{\getSocialHandleOne}{\varSocialHandleOne}

%\newcommand{\footnoteLineTwo}{%
%  \footnoteName%
%  \quad\textbullet\quad%
%  {\footnotesize\textsc{\href{mailto:\getEmail}{\getEmail}}}%
%}
