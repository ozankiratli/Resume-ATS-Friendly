%% start of file `drevocv.cls'.
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
\ProvidesClass{drevocv}[2025/02/21 evo's custom CV class]

\LoadClass[11pt, letterpaper, twoside]{moderncv}

\moderncvtheme{classic}
\moderncvcolor{black}
\nopagenumbers{}

% details options: "details" (default) or "nodetails"
\@initializeif{\if@details}\@detailsfalse
\DeclareOption{details}{\@detailstrue}
\DeclareOption{nodetails}{\@detailsfalse}

\DeclareOption*{}% avoid choking on unknown options
\ExecuteOptions{details}
\ProcessOptions*\relax% \ProcessOptions* processes the options in the order provided (i.e., with the later ones possibly overriding the former ones), while \ProcessOptions processes them in the order of the package

%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
% Required packages
%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------

\RequirePackage[margin=0.5in]{geometry}
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage[default]{sourcesanspro}
\RequirePackage{import}
\RequirePackage{needspace}
\RequirePackage{setspace}
\RequirePackage{multicol}
\RequirePackage{enumitem}
\RequirePackage{xcolor}
\RequirePackage{amssymb}
\RequirePackage{array}
\RequirePackage{ifthen}
\RequirePackage{lastpage}
\RequirePackage{tabto}
\RequirePackage{fancyhdr}
\RequirePackage[backend=biber,style=apa,natbib=false,maxbibnames=99]{biblatex}

\pagestyle{fancy}

%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------
% Settings and Declarations
%-------------------------------------------------------------------------------
%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------
% Fonts and Styles
%-------------------------------------------------------------------------------

\DeclareRobustCommand{\ebseries}{\fontseries{eb}\selectfont}
\DeclareTextFontCommand{\texteb}{\ebseries}
\DeclareRobustCommand{\sbseries}{\fontseries{sb}\selectfont}
\DeclareTextFontCommand{\textsb}{\sbseries}
\DeclareRobustCommand{\elseries}{\fontseries{el}\selectfont}
\DeclareTextFontCommand{\textel}{\elseries}
\DeclareRobustCommand{\lseries}{\fontseries{l}\selectfont}
\DeclareTextFontCommand{\textl}{\lseries}

\renewcommand*{\bibfont}{\small}

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

\newlength{\pageonesectionspacing}
\setlength{\pageonesectionspacing}{0pt}

\newlength{\pagetwosectionspacing}
\setlength{\pagetwosectionspacing}{0pt}

\newlength{\itemsleftindent}
\setlength{\itemsleftindent}{2em}

\newlength{\itemsrightindent}
\setlength{\itemsrightindent}{0pt}

\newlength{\itemsrightcorrection}
\setlength{\itemsrightcorrection}{1.45693pt}

\newlength{\itemslistgapbefore}
\setlength{\itemslistgapbefore}{3pt}

\newlength{\itemslistgapafter}
\setlength{\itemslistgapafter}{3pt}

\newlength{\itemsgap}
\setlength{\itemsgap}{.2em}

\newlength{\skillscolumnlength}
\setlength{\skillscolumnlength}{2in}

\newcommand*{\itemspread}{0.95}

\newcommand*{\nameprefix}[1]{\def\@nameprefix{#1}}
\newcommand*{\middlename}[1]{\def\@middlename{#1}}
\newcommand*{\namesuffix}[1]{\def\@namesuffix{#1}}

\newcommand{\removeonelinespace}{\vspace{-1em}}

%make "C++" look pretty when used in text by touching up the plus signs
\newcommand{\CPP}{C\nolinebreak[4]\hspace{-.05em}\raisebox{.05ex}{\footnotesize\textbf{++}}~}


\newcommand{\addspacepageone}{\vspace*{\pageonesectionspacing}}
\newcommand{\addspacepagetwo}{\vspace*{\pagetwosectionspacing}}

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
    {{\centering\begin{minipage}{\quotewidth}\centering\quotestyle{\@quote}\end{minipage}\\[2.5em]}}%
  \par}


%-------------------------------------------------------------------------------
% Body definitions
%-------------------------------------------------------------------------------
% styles
\renewcommand*{\sectionstyle}[1]{{\sectionfont\textcolor{color1}{#1}}}
\renewcommand*{\hintstyle}[1]{{\hintfont\textcolor{color0}{#1}}}

%-------------------------------------------------------------------------------
% Resume body definitions
%-------------------------------------------------------------------------------
% lengths

\@initializelength{\baseletterheight}
\settoheight{\baseletterheight}{\sectionstyle{o}}
\setlength{\baseletterheight}{\baseletterheight-0.95ex}

\RenewDocumentCommand{\section}{sm}{%
  \par\addvspace{1.40ex}%
  \phantomsection{}% reset the anchor for hyperrefs
  \addcontentsline{toc}{section}{#2}%
  \begin{tabular}{@{}p{\hintscolumnwidth}@{\hspace{\separatorcolumnwidth}}p{\maincolumnwidth}@{}}%
    \strut\raggedleft\raisebox{\baseletterheight}{\color{color1}\rule{\hintscolumnwidth}{0.95ex}} & \strut\sectionstyle{#2}%
  \end{tabular}%
  \par\nobreak\addvspace{0.35ex}\@afterheading% to avoid a pagebreak after the heading
}

\NewDocumentEnvironment{cvsection}{m}{%
  \needspace{1\baselineskip}%
  \section{#1}%
}{}

% Control biblatex spacing
\setlength{\bibitemsep}{0.2em}  % Space between bibliography items
\setlength{\bibnamesep}{0em}    % Space between name groups
\setlength{\bibinitsep}{0em}    % Space after initials

\defbibenvironment{bibliography}
  {\list
     {\printtext[labelnumberwidth]{%
        \printfield{labelprefix}%
        \printfield{labelnumber}}}
     {\setlength{\labelwidth}{0pt}%          % No label width
      \setlength{\labelsep}{0pt}%            % No label separation
      \setlength{\leftmargin}{0pt}%          % Start at left margin
      \setlength{\itemindent}{0pt}%          % First line at margin
      \setlength{\itemsep}{0.2em}%           % Space between items
      \setlength{\parsep}{0pt}%
      \setlength{\topsep}{0pt}%
      % Hanging indent for wrapped lines
      \setlength{\listparindent}{\dimexpr-\itemsleftindent-\bulletspace\relax}%
      \setlength{\itemindent}{\dimexpr-\itemsleftindent-\bulletspace\relax}%
      \advance\leftmargin \dimexpr\itemsleftindent+\bulletspace\relax}%              % Indent continuation lines
      \sloppy%
      \clubpenalty4000%
      \widowpenalty4000}
  {\endlist}
  {\item}

\newcommand*{\cvsummary}[2][\itemsgap]{
  {#2}
  \par\addvspace{#1}
}

% Renew cvitem for bullet items
\renewcommand*{\cvlistitem}[1]{\item #1}

\newcommand*{\cvexperience}[7][\itemsgap]{%
  \setlist[itemize]{itemsep=-1pt,topsep=1pt}%
  {\bfseries #3} {\textcolor{lightgrey}{\hrulefill{}}} {#2}\\%
  {\small #4}, {\itshape \small #5}{\hfill #6}%
  \ifx&#7&%
  \else{%
    \small%
    \vspace*{-3pt}
    \begin{itemize}[label={\textbullet},% 
	before=\vspace{\itemslistgapbefore},% 
	after=\vspace{\itemslistgapafter},%
	leftmargin=\dimexpr\itemsleftindent+\leftmargin\relax,% Add to default left margin
	rightmargin=\dimexpr\itemsrightindent+\itemsrightcorrection\relax%
      ]%
      \setstretch{\itemspread}%
      #7%
    \end{itemize}%
  }\fi%
  \par\addvspace{#1}%
}

\newcommand*{\cveducation}[6][\itemsgap]{%
  \setlist[itemize]{itemsep=-1pt,topsep=1pt}%
  \setstretch{\itemspread}%
  {\bfseries #3}, {\small #4}, {\itshape \small #5} {\textcolor{lightgrey}{\hrulefill{}}}{#2}%
  \ifx&#6&%
  \else{%
    \small%
    \par
    \vspace*{-1pt}%
    \hspace*{\itemsleftindent+\bulletspace}
    #6%
    \vspace*{1pt}%
  }\fi%
  \par\addvspace{#1}%
}

\newcommand*{\cvskilllist}[3][\itemsgap]{%
  {\bfseries #2:} \tabto{\skillscolumnlength}%
  \parbox[t]{\dimexpr\textwidth-\skillscolumnlength\relax}{%
    \setstretch{\itemspread}%  
    \small#3%
  }%
  \par\addvspace{#1}%
}

\newcommand*{\cvhonors}[6][\itemsgap]{%
  \setlist[itemize]{itemsep=-1pt,topsep=1pt}%
  {\setstretch{\itemspread}%
  {\bfseries #3} {\textcolor{lightgrey}{\hrulefill{}}} {#2}%
  \vspace*{-2pt}\\%
  \ifx&#4&%
  \else{%
      \hspace*{\itemsleftindent+\bulletspace}%
      \small#4%
      \vspace*{-2pt}\\%
  }\fi%
  \hspace*{\itemsleftindent+\bulletspace}%
  {\small #5}, {\itshape \small #6} }%
  \par\addvspace{#1}%
}

\newcommand*{\cvmembership}[3][\itemsgap]{%
  {#3} {\textcolor{lightgrey}{\hrulefill{}}} {#2}%
  \par\addvspace{#1}%
}

\newcommand*{\cvtalk}[6][\itemsgap]{%
  \setlist[itemize]{itemsep=-1pt,topsep=1pt}%
  \setstretch{\itemspread}%
  {\bfseries#3} {\textcolor{lightgrey}{\hrulefill{}}} {#2}\vspace*{-1pt}\\%
  \hspace*{\itemsleftindent+\bulletspace}%
  {\small {#4}. {\itshape #5}. {(#6)}}%
  \par\addvspace{#1}%
}

\newcommand*{\cvoutreach}[5][\itemsgap]{%
  \setlist[itemize]{itemsep=-3pt,topsep=-1pt}%
  \setstretch{\itemspread}%
  {\bfseries#3}, {\itshape \small #4} {\textcolor{lightgrey}{\hrulefill{}}} {#2} \vspace*{3pt}%
  \ifx&#5&%
  \else{%
    \hspace*{\itemsleftindent}%
      \small%
      \vspace{-3pt}%
      \begin{itemize}[label={\textbullet},%
	before=\vspace{-1pt},%
	after=\vspace{\itemslistgapafter},%
	leftmargin=\dimexpr\itemsleftindent+\leftmargin\relax,% 
	rightmargin=\dimexpr\itemsrightindent+\itemsrightcorrection\relax%
	]%
        #5%
      \end{itemize}%
  }\fi%
  \par\addvspace{#1}
}

\newcommand*{\cvhobby}[4][\itemsgap]{%
  \setlist[itemize]{itemsep=-3pt,topsep=-1pt}%
  \setstretch{\itemspread}%
  {{\bfseries#3} {\textcolor{lightgrey}{\hrulefill{}}} {#2}} \vspace*{3pt}%
  \ifx&#4&%
  \else{%
    \hspace*{\itemsleftindent}%
      \small%
      \vspace*{-3pt}%
      \begin{itemize}[label={\textbullet},%
	before=\vspace{-1pt},%
	after=\vspace{\itemslistgapafter},%
	leftmargin=\dimexpr\itemsleftindent+\leftmargin\relax,% 
	rightmargin=\dimexpr\itemsrightindent+\itemsrightcorrection\relax%
	]%
        #4%
      \end{itemize}%
  }\fi%
  \par\addvspace{#1}%
}

%-------------------------------------------------------------------------------
%                Automatic fancy footer generation
%-------------------------------------------------------------------------------
% Allow user to optionally set short name (for complex cad      \quad\textbullet\quad%

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

\newcommand*{\github}[1]{%
  \def\@githubhandle{#1}%
  \social[github]{#1}% Automatically set \social as well
}
\newcommand*{\linkedin}[1]{%
  \def\@linkedinhandle{#1}%
  \social[linkedin]{#1}% Automatically set \social as well
}


\newcommand*{\@printsocials}{%
  \def\@socialsep{}%
  \@ifundefined{@linkedinhandle}{}{%
    {\scriptsize\faLinkedinIn{~~}\url{https://www.linkedin.com/in/\@linkedinhandle}}%
    \def\@socialsep{\quad\textbullet\quad}%
  }%
  \@ifundefined{@githubhandle}{}{%
    \@socialsep%
    {\scriptsize\faGithub{~~}\url{https://www.github.com/\@githubhandle}}%
  }%
}

% Setup fancy footer
\newcommand*{\setupfancyfooter}{%
  \fancyhf{}% Clear all headers and footers
  
  % Right footer: page numbers
  \fancyfoot[R]{\vspace{-14pt}{\small{\thepage/\pageref*{LastPage}}}}
  
  % Center footer odd pages (CO): Name and email
  \fancyfoot[CO]{%
    \vspace{-14pt}%
    {\footnotesize{\textsc{\@getfootername}}}%
    \@ifundefined{@email}{}{%
      \quad\textbullet\quad%
      {\footnotesize\textsc{\href{mailto:\@email}{\@email}}}%
    }%
  }
  
  % Center footer even pages (CE): Name, email, and socials
  \fancyfoot[CE]{%
    \vspace{-23pt}%
    {\footnotesize{\textsc{\@getfootername}}}%
    \@ifundefined{@email}{}{%
      \quad\textbullet\quad%
      {\footnotesize\textsc{\href{mailto:\@email}{\@email}}}%
    }%
    \\{\vspace{-2pt}}%
    \@printsocials%
  }
}

\newlength{\bulletspace}

% Automatically setup footer after \begin{document}
\AtBeginDocument{%
  \setupfancyfooter%
  \settowidth{\bulletspace}{\textbullet}% Width of bullet symbol
  \addtolength{\bulletspace}{\labelsep}% Add the space after bullet
}

% Call it slightly later
\AtEndPreamble{%
  \AtBeginDocument{%
    \makecvtitle%
    \vspace*{\titlespacing}%
  }%
}

\endinput

