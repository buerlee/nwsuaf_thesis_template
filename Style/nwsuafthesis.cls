%---------------------------------------------------------------------------%
%-                                                                         -%
%-                           Document Class                                -%
%-                                                                         -%
%---------------------------------------------------------------------------%
%- Copyright (C) Li Wang <purewangli@gmail.com> 
%- This is free software: you can redistribute it and/or modify it
%- under the terms of the GNU General Public License as published by
%- the Free Software Foundation, either version 3 of the License, or
%- (at your option) any later version.
%---------------------------------------------------------------------------%

%---------------------------------------------------------------------------%
%->> Identification
%---------------------------------------------------------------------------%
\NeedsTeXFormat{LaTeX2e}%
\ProvidesClass{nwsuafthesis}[2014/10/01 v1.0 LaTeX document class]%

%---------------------------------------------------------------------------%
%->> Declare options
%---------------------------------------------------------------------------%
%-
%-> Layout
%-
\newif\ifnwsuaf@singlesided \nwsuaf@singlesidedfalse
\DeclareOption{singlesided}{% enable single-sided printing
    \nwsuaf@singlesidedtrue%
}
\newif\ifnwsuaf@doublesided \nwsuaf@doublesidedfalse
\DeclareOption{doublesided}{% enable double-sided printing
    \nwsuaf@doublesidedtrue%
}
\newif\ifnwsuaf@printcopy \nwsuaf@printcopyfalse
\DeclareOption{printcopy}{% enable print copy layout
    \nwsuaf@doublesidedtrue% auto enable double-sided style
    \nwsuaf@printcopytrue%
}
%-
%-> Draft version info
%-
\newif\ifnwsuaf@versioninfo \nwsuaf@versioninfofalse
\DeclareOption{draftversion}{%
    \nwsuaf@versioninfotrue%
}
%-
%-> Handle non-implemented options
%-
\DeclareOption*{%
    \PassOptionsToClass{\CurrentOption}{ctexbook}%
}
%-
%-> Terminates all options processing
%-
\ProcessOptions\relax%
%---------------------------------------------------------------------------%
%->> Load class information
%---------------------------------------------------------------------------%
\ifnwsuaf@doublesided% if double-sided printing enabled
    \LoadClass[UTF8,a4paper,twoside,zihao=-4]{ctexbook}
\else% if double-sided printing isn't enabled
    \LoadClass[UTF8,a4paper,oneside,zihao=-4]{ctexbook}
\fi
%---------------------------------------------------------------------------%
%->> Required packages
%---------------------------------------------------------------------------%
\RequirePackage{ifxetex}% LaTeX engine detection
\RequirePackage{etoolbox}% a toolbox of programming facilities
\newcommand{\nwsuafifstreq}{\expandafter\ifstrequal\expandafter}% expansion control
\newcommand{\nwsuafifstrbk}{\expandafter\ifblank\expandafter}% expansion control
%---------------------------------------------------------------------------%
%->> Load class configuration
%---------------------------------------------------------------------------%
\AtEndOfPackage{% class cfg loaded after package to make preamble commands take effect
    \makeatletter
    \InputIfFileExists{Style/nwsuafthesis.cfg}{}{}
    \makeatother
}
%---------------------------------------------------------------------------%
%->> Page layout
%---------------------------------------------------------------------------%
%- part one -- horizontal widths
%- left side width + textwidth + right side width = paperwidth
%- binding side width + textwidth + nonbinding side width = paperwidth
%- binding side width of [odd, even] page = [left, right] side width
%- left side width of [odd, even] page = 1.0in (fixed) + hoffset + [odd, even]sidemargin
%- assuming A4 paper (210mm x 297mm)
\setlength{\textwidth}{146.6mm}% set required text width first
\setlength{\hoffset}{0mm}% set horizontal offset
\ifnwsuaf@printcopy% if print copy layout enabled
    \setlength{\oddsidemargin}{12.6mm}% binding side margin
    \setlength{\evensidemargin}{0mm}% ensure uniform binding side width for printing
\else
    \setlength{\oddsidemargin}{6.3mm}% left side margin
    \setlength{\evensidemargin}{6.3mm}% ensure uniform left side width for EThesis
\fi
\setlength{\marginparwidth}{35pt}% width of margin notes
\setlength{\marginparsep}{10pt}% width of space between body text and margin notes
%- part two -- vertical heights
%- top height + textheight + bottom height = paperheight
%- top height = 1.0in (fixed) + voffset + topmargin + headheight + headsep 
\setlength{\textheight}{246.2mm}% set required text height first
\setlength{\voffset}{-17.4mm}% set vertical offset
\setlength{\topmargin}{20pt}% vertical margin above header
\setlength{\headheight}{12pt}% header height
\setlength{\headsep}{17.5pt}% vertical margin between header and body text
\setlength{\footskip}{29.5pt}% vertical margin between footer and body text
%- specifies the amount of space between paragraphs.
\setlength{\parskip}{0.5ex plus 0.25ex minus 0.25ex}
%- line spacing
\linespread{1.5}% line space setting
\raggedbottom% prevent adding vertical white space in strange places
%- default pagestyle is page number at bottom without headers and footers
\pagestyle{plain}

%---------------------------------------------------------------------------%
%->> Style control commands
%---------------------------------------------------------------------------%
%- redefine cleardoublepage to have page style argument
\renewcommand{\cleardoublepage}[1][plain]{%
    \clearpage\if@twoside\ifodd\c@page\else%
    \thispagestyle{#1}%
    \hbox{}\newpage\if@twocolumn\hbox{}\newpage\fi\fi\fi%
}

%- underline
\ifxetex% use underline from xeCJKfntef
    \renewcommand{\CJKunderlinecolor}{\color[rgb]{0,0,0}}% set underline color
    \renewcommand{\uline}[1]{\CJKunderline{#1}}% unified name
\else% use underline from ulem
    \RequirePackage{ulem}%
\fi

\newcommand{\ulenhance}[2][1pt]{% enhanced underline
    \def\ULthickness{#1}% set thickness
    \uline{#2}}

\newcommand{\ulhshift}{-4em}% horizontal shift on underline

\newcommand{\ulextend}[2][350pt]{% extend underline length
    \hbox to #1{\hfill\hspace*{\ulhshift}#2\hfill}}
%---------------------------------------------------------------------------%
%->> Titlepage
%---------------------------------------------------------------------------%
%-
%-> Chinese item commands
%-
\def\nwsuaf@value@schoollogo{}
\newcommand{\schoollogo}[2]{\def\nwsuaf@value@schoollogo{\includegraphics[#1]{#2}}}
\def\nwsuaf@value@title{}
\def\nwsuaf@value@titlemark{}
\renewcommand{\title}[2][\nwsuaf@value@title]{%
    \def\nwsuaf@value@title{#2}
    %\def\nwsuaf@value@titlemark{\MakeUppercase{#1}}}
    \def\nwsuaf@value@titlemark{#1}}
\renewcommand{\author}[1]{\def\nwsuaf@value@author{#1}}
\def\nwsuaf@value@advisor{}
\renewcommand{\@title}{\nwsuaf@value@titlemark}
\def\nwsuaf@value@author{}
\newcommand{\advisor}[1]{\def\nwsuaf@value@advisor{#1}}
\def\nwsuaf@value@advisorsec{}
\newcommand{\advisorsec}[1]{\def\nwsuaf@value@advisorsec{#1}}
\def\nwsuaf@value@degree{}
\newcommand{\degree}[1]{\def\nwsuaf@value@degree{#1}}
\def\nwsuaf@value@degreetype{}
\newcommand{\degreetype}[1]{\def\nwsuaf@value@degreetype{#1}}
\def\nwsuaf@value@major{}
\newcommand{\major}[1]{\def\nwsuaf@value@major{#1}}
\def\nwsuaf@value@institute{}
\newcommand{\institute}[1]{\def\nwsuaf@value@institute{#1}}
\def\nwsuaf@value@researchfield{}
\newcommand{\researchfield}[1]{\def\nwsuaf@value@researchfield{#1}}
\def\nwsuaf@value@graduatedate{}
\newcommand{\graduatedate}[1]{\def\nwsuaf@value@graduatedate{#1}}
\def\nwsuaf@value@graduateyear{}
\newcommand{\graduateyear}[1]{\def\nwsuaf@value@graduateyear{#1}}

\def\nwsuaf@value@classificationcode{}
\newcommand{\classificationcode}[1]{\def\nwsuaf@value@classificationcode{#1}}
\def\nwsuaf@value@schoolcode{}
\newcommand{\schoolcode}[1]{\def\nwsuaf@value@schoolcode{#1}}
\def\nwsuaf@value@udc{}
\newcommand{\udc}[1]{\def\nwsuaf@value@udc{#1}}
\def\nwsuaf@value@studentid{}
\newcommand{\studentid}[1]{\def\nwsuaf@value@studenid{#1}}
\def\nwsuaf@value@confidential{}
\newcommand{\confidential}[1]{\def\nwsuaf@value@confidential{#1}}
\def\nwsuaf@value@fundation{}
\newcommand{\fundation}[1]{\def\nwsuaf@value@fundation{#1}}

%-
%-> Redefine Chinese style
%-
\renewcommand{\maketitle}{%

    \cleardoublepage

    \thispagestyle{empty}
    \zihao{5}

    {% top 
        {\nwsuaf@label@classification}\ulenhance{\ulextend[40pt]{\quad\quad\nwsuaf@value@classificationcode}}\hfill{}{\nwsuaf@label@schoolcode}{\nwsuaf@value@schoolcode}

        {\nwsuaf@label@ucd}\ulenhance{\ulextend[40pt]{\quad\quad\nwsuaf@value@udc}}\hfill{}{\nwsuaf@label@studentid}{\nwsuaf@value@studenid}

        {\nwsuaf@label@confidential}\ulenhance{\ulextend[40pt]{\quad\quad\nwsuaf@value@confidential}}\hfill{}
    }

    \vspace*{\stretch{4}}

    % middle
    \begin{center}
        \linespread{1.5}

        % school logo
        {\nwsuaf@value@schoollogo}

        \vspace*{\stretch{2}}

        % statement 
        {\Large\bfseries\itshape{\ulenhance{\nwsuaf@value@graduateyear}{届攻读博士学位研究生学位（毕业）论文}}}

        \vspace*{\stretch{3}}

        % title
        {\LARGE\bfseries\sffamily\ulenhance[1.5pt]{\ \nwsuaf@value@title\ }}

        \vspace*{\stretch{5}}

        % info
        \def\tabcolsep{1pt}
        \def\arraystretch{1.5}

        {\large
            \begin{tabular}{lr}
                \nwsuaf@label@major & \ulenhance[1.2pt]{\ulextend[220pt]{\nwsuaf@value@major}}\\
                \nwsuaf@label@researchfield & \ulenhance[1.2pt]{\ulextend[220pt]{\nwsuaf@value@researchfield}}\\
                \nwsuaf@label@author & \ulenhance[1.2pt]{\ulextend[220pt]{\nwsuaf@value@author}}\\
                \nwsuaf@label@advisor & \ulenhance[1.2pt]{\ulextend[220pt]{\nwsuaf@value@advisor}}\\
                \nwsuaf@label@graduatedate & \ulenhance[1.2pt]{\ulextend[220pt]{\nwsuaf@value@graduatedate}}\\
            \end{tabular}
        }

        \vspace*{\stretch{4.5}}

        % info
        {中国\quad 陕西\quad 杨凌}

        \vspace*{\stretch{3.5}}
    \end{center}

    \clearpage

    \if@twoside
        \thispagestyle{empty}
        \ifnwsuaf@versioninfo
            \vspace*{\stretch{1}}
            \begin{footnotesize}
                \noindent
                Draft Version (\today)
            \end{footnotesize}
        \fi
        \cleardoublepage[empty]
    \else
        \ifnwsuaf@versioninfo
            \thispagestyle{empty}
            \vspace*{\stretch{1}}
            \begin{footnotesize}
                \noindent
                Draft Version (\today)
            \end{footnotesize}
            \cleardoublepage[empty]
        \fi
    \fi
}
%-
%-> English item commands
%-
\def\nwsuaf@value@englishtitle{}
\newcommand{\englishtitle}[1]{\def\nwsuaf@value@englishtitle{#1}}
\def\nwsuaf@value@englishauthor{}
\newcommand{\englishauthor}[1]{\def\nwsuaf@value@englishauthor{#1}}
\def\nwsuaf@value@englishadvisor{}
\newcommand{\englishadvisor}[1]{\def\nwsuaf@value@englishadvisor{#1}}
\def\nwsuaf@value@englishdegree{}
\newcommand{\englishdegree}[1]{\edef\nwsuaf@value@englishdegree{\zap@space#1 \@empty}}% expand and remove space
\def\nwsuaf@value@englishdegreetype{}
\newcommand{\englishdegreetype}[1]{\def\nwsuaf@value@englishdegreetype{#1}}
\def\nwsuaf@value@englishthesistype{}
\newcommand{\englishthesistype}[1]{\def\nwsuaf@value@englishthesistype{#1}}
\def\nwsuaf@value@englishmajor{}
\newcommand{\englishmajor}[1]{\def\nwsuaf@value@englishmajor{#1}}
\def\nwsuaf@value@englishinstitute{}
\newcommand{\englishinstitute}[1]{\def\nwsuaf@value@englishinstitute{#1}}
\def\nwsuaf@value@englishgraduatedate{}
\newcommand{\englishgraduatedate}[1]{\def\nwsuaf@value@englishgraduatedate{#1}}
\def\nwsuaf@value@englishresearchfield{}
\newcommand{\englishresearchfield}[1]{\def\nwsuaf@value@englishresearchfield{#1}}
\def\nwsuaf@value@englishconfidential{}
\newcommand{\englishconfidential}[1]{\def\nwsuaf@value@englishconfidential{#1}}

%-
%-> Redefine English style
%-
\newcommand{\makeenglishtitle}{%
    \cleardoublepage
    \thispagestyle{empty}
     \zihao{-4}   

    % top
    {
        {\nwsuaf@label@englishclassification}\ulenhance{{\nwsuaf@value@classificationcode}}\hfill{}{\nwsuaf@label@englishschoolcode}{\nwsuaf@value@schoolcode}

        {\nwsuaf@label@englishucd}\ulenhance{\nwsuaf@value@udc}\hfill{}{\nwsuaf@label@englishstudentid} {\nwsuaf@value@studenid}

        {\nwsuaf@label@englishconfidential}\ulenhance{\nwsuaf@value@englishconfidential}\hfill{}
    }

    \vspace*{\stretch{2}}

    % middle
    \begin{center}
        \linespread{1.5}
        
        {\large Dissertation for Doctor Degreee \\ Northwest A\&F University in\, \ulenhance{\nwsuaf@value@graduateyear}}

        \vspace*{50pt}

        {\LARGE\bfseries\nwsuaf@value@englishtitle }


        \vspace*{\stretch{4.5}}

        {\large
            \begin{flushleft}
            {\hspace{3em}\nwsuaf@label@englishmajor}{\nwsuaf@value@englishmajor}\\
            {\hspace{3em}\nwsuaf@label@englishresearchfield}{\nwsuaf@value@englishresearchfield}\\
            {\hspace{3em}\nwsuaf@label@englishauthor}{\nwsuaf@value@englishauthor}\\
            {\hspace{3em}\nwsuaf@label@englishadvisor}{\nwsuaf@value@englishadvisor}\\
            {\hspace{3em}\nwsuaf@label@englishgraduatedate}{\nwsuaf@value@englishgraduatedate}\\
            \end{flushleft}
        }

        \vspace*{\stretch{2}}

        {\bfseries\Large Yangling \quad Shaanxi \quad China}

        \vspace*{\stretch{3}}
    \end{center}

    \clearpage
    \if@twoside
      \thispagestyle{empty}
      \cleardoublepage[empty]
    \fi
}

%---------------------------------------------------------------------------%
%->> Fundation declaration 
%---------------------------------------------------------------------------%
\newcommand{\makefundationdeclaration}{%
    \cleardoublepage
    \thispagestyle{empty}
    {
        \linespread{1.5}
        \zihao{-4}

        \vspace*{2ex}

        \begin{center}
            {\zihao{4}\bfseries\sffamily 论文资助基金项目}
        \end{center}

        \begin{center}
            {\nwsuaf@value@fundation}
        \end{center}

    }
    \clearpage
    \if@twoside
        \thispagestyle{empty}
        \cleardoublepage[empty]
    \fi
}


%---------------------------------------------------------------------------%
%->> Author's declaration
%---------------------------------------------------------------------------%
\newcommand{\makedeclaration}{%
    \cleardoublepage
    \thispagestyle{empty}
    {
        \linespread{1.5}
        \zihao{-4}

        \vspace*{2ex}

        \begin{center}
            {\zihao{4}\bfseries\sffamily \nwsuaf@value@declare@studentcreate}
        \end{center}

        {\nwsuaf@value@declare@studentcreativity}

        \vspace*{3ex}

        {\hfill{} {\nwsuaf@value@declare@s \hspace*{14em}}}

        {\hfill{} {\nwsuaf@value@declare@d \hspace*{14em}}}

        \vspace*{12ex}

        \begin{center}
            {\zihao{4}\bfseries\sffamily \nwsuaf@value@declare@advisorcreate}
        \end{center}
        {\nwsuaf@value@declare@advisorcreativity}

        \vspace*{3ex}

        {\hfill{} {\nwsuaf@value@declare@s \hspace*{14em}}}

        {\hfill{} {\nwsuaf@value@declare@d \hspace*{14em}}}

    }
    \clearpage
    \if@twoside
        \thispagestyle{empty}
        \cleardoublepage[empty]
    \fi
}

\newcommand{\makedeclarationrights}{%
    \cleardoublepage
    \thispagestyle{empty}
    {
        \linespread{1.5}
        \zihao{-4}

        \vspace*{2ex}

        \begin{center}
            {\zihao{4}\bfseries\sffamily \nwsuaf@value@declare@right}
        \end{center}

        {\nwsuaf@value@declare@rights}

        \vspace*{3ex}

        {\hfill{} {\nwsuaf@value@declare@s \hspace*{10em} \nwsuaf@value@declare@t \hspace*{9em}}}

        {\hfill{} {\nwsuaf@value@declare@d \hspace*{10em} \nwsuaf@value@declare@d \hspace*{9em}}}

        \vspace*{3ex}
    }
    \clearpage
    \if@twoside
        \thispagestyle{empty}
        \cleardoublepage[empty]
    \fi
}
%---------------------------------------------------------------------------%
%->> New environments
%---------------------------------------------------------------------------%
%- define chinese keywords
\newcommand{\keywords}[1]{%
    \vspace{\baselineskip}
    \noindent {\bfseries \nwsuaf@label@keywords} #1}
%- define engish keywords
\newcommand{\englishkeywords}[1]{%
    \vspace{\baselineskip}
    \noindent {\bfseries \nwsuaf@label@englishkeywords} #1}
%---------------------------------------------------------------------------%
%->> Configure table of contents
%---------------------------------------------------------------------------%
%- define spacing and length
\def\@dotsep{1.5mu}% spacing for dots
\def\@pnumwidth{2em}% spacing between titles and page numbers
\def\@tocrmarg{2em}% right margin indentation
\def\@chaptervspace{1ex}% spacing between chapter titles
%- redefine dottedtocline from classes.dtx and latex.ltx
\renewcommand*{\@dottedtocline}[5]{% [<level>,<indent>,<numwidth>,<title>,<page>]
    \ifnum #1>\c@tocdepth \else
        \vskip \z@ \@plus.2\p@
        {\leftskip #2\relax \rightskip \@tocrmarg \parfillskip -\rightskip
        \parindent #2\relax\@afterindenttrue
        \interlinepenalty\@M
        \leavevmode \zihao{-4}\sffamily
        \@tempdima #3\relax
        \advance\leftskip \@tempdima \null\nobreak\hskip -\leftskip
        {#4}\nobreak
        \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}\hfill
        \nobreak
        \hb@xt@\@pnumwidth{\hfil\normalfont \normalcolor #5}%
        \par\penalty\@highpenalty}%
    \fi
}
%- redefine l@part from book.cls to add dotted toc line
\renewcommand*{\l@part}[2]{% [<title>,<page>]
    \ifnum \c@tocdepth >-2\relax
        \addpenalty{-\@highpenalty}%
        \addvspace{2.25em \@plus\p@}%
        \setlength\@tempdima{3em}%
        \begingroup
            \parindent \z@ \rightskip \@pnumwidth
            \parfillskip -\@pnumwidth
            {\leavevmode
            \zihao{4}\sffamily #1
            \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}% add dotted toc line
            \hfil \hb@xt@\@pnumwidth{\hss #2}}\par
            \nobreak
            \global\@nobreaktrue
            \everypar{\global\@nobreakfalse\everypar{}}%
        \endgroup
    \fi
}
%- redefine l@chapter from book.cls to add dotted toc line
\renewcommand*{\l@chapter}[2]{% [<title>,<page>]
    \ifnum \c@tocdepth >\m@ne
        \addpenalty{-\@highpenalty}%
        \vskip \@chaptervspace \@plus\p@
        \setlength\@tempdima{1.5em}%
        \begingroup
            \parindent \z@ \rightskip \@pnumwidth
            \parfillskip -\@pnumwidth
            \leavevmode \zihao{4}\sffamily
            \advance\leftskip\@tempdima
            \hskip -\leftskip
            #1\nobreak
            \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}% add dotted toc line
            \hfil \nobreak\hb@xt@\@pnumwidth{\hss #2}\par
            \penalty\@highpenalty
        \endgroup
    \fi
}
%---------------------------------------------------------------------------%
\endinput

