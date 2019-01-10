#!/usr/bin/env bash

# Verify microdegree name
# $MICRODEGREE_NAME
# $MICRODEGREE_DESCRIPTION
# $MICRODEGREE_GITHUB_REPO
# $MICRODEGREE_PACKAGE_NAME

# Create project dir
export PROJECT_PATH='project'
mkdir -p $PROJECT_PATH
echo 'sbt.version=1.2.7' >> project/build.properties
echo 'addSbtPlugin("com.47deg" % "sbt-microsites" % "0.7.23")' >> project/plugins.sbt

# Create slides dir
export SLIDES_PATH='slides'
mkdir -p $SLIDES_PATH

# Create docs dir
export DOCS_PATH='docs'
mkdir -p $DOCS_PATH

# Create source dirs
export SCALA_CODE_PATH="src/main/scala/com/microtau/microdegree/$MICRODEGREE_PACKAGE_NAME"
export TUT_DOCS_PATH='src/main/tut/docs/'
export RESOURCES_PATH='src/main/resources/microsite/'
mkdir -p $SCALA_CODE_PATH
mkdir -p $TUT_DOCS_PATH
mkdir -p $RESOURCES_PATH/data/
mkdir -p $RESOURCES_PATH/img/
mkdir -p $RESOURCES_PATH/js/
mkdir -p $RESOURCES_PATH/slides/

# Create setup files
mkdir setup-scripts
cat > setup-scripts/ubuntu.sh << 'EOF'
#!/bin/bash

# Install git & jq
sudo apt install -y git jq

# Install python
sudo apt install -y python3.7

# Install java 8
sudo apt install -y openjdk-8-jdk

# Install pandoc
sudo apt install -y pandoc pandoc-citeproc

# Install R & Dependencies
sudo apt install -y r-base
sudo apt install -y libcurl4-openssl-dev libssl-dev libxml2-dev r-cran-xml
echo "install.packages(c('rmarkdown', 'tinytex', 'reticulate'))" | R --vanilla --quiet
echo "install.packages('devtools', dependencies = TRUE, repos = 'http://cran.us.r-project.org')" | R --vanilla --quiet
echo "devtools::install_github('cboettig/knitcitations')" | R --vanilla --quiet

# Install pdflatex
sudo apt install -y texlive-latex-base texlive-fonts-recommended texlive-fonts-extra texlive-latex-extra

# Install SBT
sudo apt install wget
wget https://dl.bintray.com/sbt/debian/sbt-1.2.7.deb
sudo dpkg -i sbt-1.2.7.deb
rm -r sbt-1.2.7.deb
sbt about

# Install Ruby and Jekyll
sudo apt install ruby ruby-dev build-essential
export GEM_HOME=$HOME/gems
export PATH=$HOME/gems/bin:$PATH
gem install jekyll bundler

EOF

# Create example docs config json
cat > docs/config.json << EOF
{
  "0-module": {
    "title": "Example: Hello World",
    "author": "micro-tau"
  }
}
EOF

# Create example slides config json
cat > slides/config.json << EOF
{
  "0-0": {
    "title": "Example: Hello World",
    "author": "micro-tau"
  }
}
EOF

# Create base README.md files
cat > README.md << EOF
## About this microdegree
___

[![Join the chat at https://gitter.im/micro-tau/${MICRODEGREE_GITHUB_REPO}](https://badges.gitter.im/micro-tau/${MICRODEGREE_GITHUB_REPO}.svg)](https://gitter.im/micro-tau/${MICRODEGREE_GITHUB_REPO}?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

<p align="justify">
This is an example-micodegree. Edit this text and add an accurate description.
</p>

## Who should apply

Specify who should apply to this microdegree.

## Requirements

Specify the requirements (e.g., alumni-profile, software specs, dependencies).

## What you will learn

Detailed explanation of the contents of this microdegree.

### Syllabus

#### Module 0: Example Module
This module is given as an example. Feel free to delete it.

* 0-0: **Example Session** - this is an example session (each session has one slide). Feel free to delete it.
    * topic 1
    * topic 2

#### Module 1: Introduction

[ add module description ]

* 1-1: **[ add session 1 title ]** - [ add session 1 description ]
    * topic 1
    * topic 2
* 1-2: **[ add session 2 title ]** - [ add session 2 description ]
    * topic 1
    * topic 2

EOF

cat > src/main/tut/docs.md << EOF
---
layout: docs
title:  "Documentation"
section: "docs"
position: 2
---
{% include_relative docs/index.md %}
EOF

cat > src/main/tut/docs/index.md << EOF
# $MICRODEGREE_NAME - Docs

Welcome to the **$MICRODEGREE_NAME Documentation** site!

EOF

cat > docs/0-module.rmd << 'EOF'
# Example Section

```{r setup, include=FALSE}
reticulate::use_python("/usr/bin/python3.7")
```

This is an example document to show the usage of [r-markdown] and [scala-tut].

[r-markdown]: https://rmarkdown.rstudio.com/
[scala-tut]: https://tpolecat.github.io/tut/

R markdown allows us to run multiple code snippets (e.g., R, python) while still using the convenient markdown language.
This enables us to create fully reproducible documents and research papers.
Since r-markdown is based on [pandoc], we can easily leverage this document-engine for the scala-based microsite tooling
we are using for the microdegrees. This means that we can add the `tut` tag to the code snippets to evaluate scala code as well.

[pandoc]: https://pandoc.org/

Moreover, we can seamlessly add citations using bibtex:

> "Epictetus once said, 'Wealth consist not in having great possessions, but in having few wants'.
The spirit is also reflected in Markdown. It is entirely possible to succeed with simplicity."

[@xie2018r]

The complete reference will be added in the end of this document based on the information contained in the `references.bib` file.

## Code Snippets!

### Python code

Consider the following python code snippet.

```{python}

def factorial(n: int) -> int:
  return 1 if n == 0 else n * factorial(n-1)

number = 10

print(f"The factorial of {number} is {factorial(number)}")
```

The `print` statements are shown in a code block.

We can use python libs:

```{python}
import pandas as pd
import numpy as np

data = {"dice1": np.random.randint(0, 6, 100), "dice2": np.random.randint(0, 6, 100)}
df = pd.DataFrame(data)

print(df.groupby("dice1", as_index=False)["dice1"].agg({"frequency":"count"}))
```

### R code

In the other hand, the R code shows the last line output.

```{r}
1+1
```

### Scala & Tut

We can have regular scala code snippets with the default formatting.

```scala
println("hello world")
```

Or we can use the `tut` tag to evaluate the code.

```tut
println("hello world")
```

## References

EOF

cat > references.bib << 'EOF'

@book{xie2018r,
  title={R Markdown: The Definitive Guide},
  author={Xie, Yihui and Allaire, JJ and Grolemund, Garrett},
  year={2018},
  publisher={CRC Press}
}

EOF

cat > template.tex << 'EOF'
\documentclass[$if(fontsize)$$fontsize$,$endif$$if(lang)$$babel-lang$,$endif$$if(papersize)$$papersize$paper,$endif$$for(classoption)$$classoption$$sep$,$endfor$]{$documentclass$}
$if(fontfamily)$
\usepackage[$for(fontfamilyoptions)$$fontfamilyoptions$$sep$,$endfor$]{$fontfamily$}
$else$
\usepackage{lmodern}
$endif$
$if(linestretch)$
\usepackage{setspace}
\setstretch{$linestretch$}
$endif$
\usepackage{amssymb,amsmath}
\usepackage{ifxetex,ifluatex}
\usepackage{fixltx2e} % provides \textsubscript
\ifnum 0\ifxetex 1\fi\ifluatex 1\fi=0 % if pdftex
  \usepackage[$if(fontenc)$$fontenc$$else$T1$endif$]{fontenc}
  \usepackage[utf8]{inputenc}
$if(euro)$
  \usepackage{eurosym}
$endif$
\else % if luatex or xelatex
  \ifxetex
    \usepackage{mathspec}
  \else
    \usepackage{fontspec}
  \fi
  \defaultfontfeatures{Ligatures=TeX,Scale=MatchLowercase}
$if(euro)$
  \newcommand{\euro}{€}
$endif$
$if(mainfont)$
    \setmainfont[$for(mainfontoptions)$$mainfontoptions$$sep$,$endfor$]{$mainfont$}
$endif$
$if(sansfont)$
    \setsansfont[$for(sansfontoptions)$$sansfontoptions$$sep$,$endfor$]{$sansfont$}
$endif$
$if(monofont)$
    \setmonofont[Mapping=tex-ansi$if(monofontoptions)$,$for(monofontoptions)$$monofontoptions$$sep$,$endfor$$endif$]{$monofont$}
$endif$
$if(mathfont)$
    \setmathfont(Digits,Latin,Greek)[$for(mathfontoptions)$$mathfontoptions$$sep$,$endfor$]{$mathfont$}
$endif$
$if(CJKmainfont)$
    \usepackage{xeCJK}
    \setCJKmainfont[$for(CJKoptions)$$CJKoptions$$sep$,$endfor$]{$CJKmainfont$}
$endif$
\fi
% use upquote if available, for straight quotes in verbatim environments
\IfFileExists{upquote.sty}{\usepackage{upquote}}{}
% use microtype if available
\IfFileExists{microtype.sty}{%
\usepackage{microtype}
\UseMicrotypeSet[protrusion]{basicmath} % disable protrusion for tt fonts
}{}
$if(geometry)$
\usepackage[$for(geometry)$$geometry$$sep$,$endfor$]{geometry}
$endif$
\usepackage{hyperref}
$if(colorlinks)$
\PassOptionsToPackage{usenames,dvipsnames}{color} % color is loaded by hyperref
$endif$
\hypersetup{unicode=true,
$if(title-meta)$
            pdftitle={$title-meta$},
$endif$
$if(author-meta)$
            pdfauthor={$author-meta$},
$endif$
$if(keywords)$
            pdfkeywords={$for(keywords)$$keywords$$sep$; $endfor$},
$endif$
$if(colorlinks)$
            colorlinks=true,
            linkcolor=$if(linkcolor)$$linkcolor$$else$Maroon$endif$,
            citecolor=$if(citecolor)$$citecolor$$else$Blue$endif$,
            urlcolor=$if(urlcolor)$$urlcolor$$else$Blue$endif$,
$else$
            pdfborder={0 0 0},
$endif$
            breaklinks=true}
\urlstyle{same}  % don't use monospace font for urls
$if(lang)$
\ifnum 0\ifxetex 1\fi\ifluatex 1\fi=0 % if pdftex
  \usepackage[shorthands=off,$for(babel-otherlangs)$$babel-otherlangs$,$endfor$main=$babel-lang$]{babel}
$if(babel-newcommands)$
  $babel-newcommands$
$endif$
\else
  \usepackage{polyglossia}
  \setmainlanguage[$polyglossia-lang.options$]{$polyglossia-lang.name$}
$for(polyglossia-otherlangs)$
  \setotherlanguage[$polyglossia-otherlangs.options$]{$polyglossia-otherlangs.name$}
$endfor$
\fi
$endif$
$if(natbib)$
\usepackage$if(natbiboptions)$[$for(natbiboptions)$$natbiboptions$$sep$,$endfor$]$endif${natbib}
\bibliographystyle{$if(biblio-style)$$biblio-style$$else$plainnat$endif$}
$endif$
$if(biblatex)$
\usepackage$if(biblio-style)$[style=$biblio-style$]$endif${biblatex}
$if(biblatexoptions)$\ExecuteBibliographyOptions{$for(biblatexoptions)$$biblatexoptions$$sep$,$endfor$}$endif$
$for(bibliography)$
\addbibresource{$bibliography$}
$endfor$
$endif$
$if(listings)$
\usepackage{listings}
\newcommand{\passthrough}[1]{#1}
$endif$
$if(lhs)$
\lstnewenvironment{code}{\lstset{language=Haskell,basicstyle=\small\ttfamily}}{}
$endif$
$if(highlighting-macros)$
$highlighting-macros$
$endif$
$if(verbatim-in-note)$
\usepackage{fancyvrb}
\VerbatimFootnotes % allows verbatim text in footnotes
$endif$
$if(tables)$
\usepackage{longtable,booktabs}
$endif$
$if(graphics)$
\usepackage{graphicx,grffile}
\makeatletter
\def\maxwidth{\ifdim\Gin@nat@width>\linewidth\linewidth\else\Gin@nat@width\fi}
\def\maxheight{\ifdim\Gin@nat@height>\textheight\textheight\else\Gin@nat@height\fi}
\makeatother
% Scale images if necessary, so that they will not overflow the page
% margins by default, and it is still possible to overwrite the defaults
% using explicit options in \includegraphics[width, height, ...]{}
\setkeys{Gin}{width=\maxwidth,height=\maxheight,keepaspectratio}
$endif$
$if(links-as-notes)$
% Make links footnotes instead of hotlinks:
\renewcommand{\href}[2]{#2\footnote{\url{#1}}}
$endif$
$if(strikeout)$
\usepackage[normalem]{ulem}
% avoid problems with \sout in headers with hyperref:
\pdfstringdefDisableCommands{\renewcommand{\sout}{}}
$endif$
$if(indent)$
$else$
\IfFileExists{parskip.sty}{%
\usepackage{parskip}
}{% else
\setlength{\parindent}{0pt}
\setlength{\parskip}{6pt plus 2pt minus 1pt}
}
$endif$
\setlength{\emergencystretch}{3em}  % prevent overfull lines
\providecommand{\tightlist}{%
  \setlength{\itemsep}{0pt}\setlength{\parskip}{0pt}}
$if(numbersections)$
\setcounter{secnumdepth}{5}
$else$
\setcounter{secnumdepth}{0}
$endif$
$if(subparagraph)$
$else$
% Redefines (sub)paragraphs to behave more like sections
\ifx\paragraph\undefined\else
\let\oldparagraph\paragraph
\renewcommand{\paragraph}[1]{\oldparagraph{#1}\mbox{}}
\fi
\ifx\subparagraph\undefined\else
\let\oldsubparagraph\subparagraph
\renewcommand{\subparagraph}[1]{\oldsubparagraph{#1}\mbox{}}
\fi
$endif$
$if(dir)$
\ifxetex
  % load bidi as late as possible as it modifies e.g. graphicx
  $if(latex-dir-rtl)$
  \usepackage[RTLdocument]{bidi}
  $else$
  \usepackage{bidi}
  $endif$
\fi
\ifnum 0\ifxetex 1\fi\ifluatex 1\fi=0 % if pdftex
  \TeXXeTstate=1
  \newcommand{\RL}[1]{\beginR #1\endR}
  \newcommand{\LR}[1]{\beginL #1\endL}
  \newenvironment{RTL}{\beginR}{\endR}
  \newenvironment{LTR}{\beginL}{\endL}
\fi
$endif$

%%% Use protect on footnotes to avoid problems with footnotes in titles
\let\rmarkdownfootnote\footnote%
\def\footnote{\protect\rmarkdownfootnote}

$if(compact-title)$
%%% Change title format to be more compact
\usepackage{titling}

% Create subtitle command for use in maketitle
\newcommand{\subtitle}[1]{
  \posttitle{
    \begin{center}\large#1\end{center}
    }
}

\setlength{\droptitle}{-2em}
$endif$

$if(title)$
  \title{$title$}
  $if(compact-title)$
  \pretitle{\vspace{\droptitle}\centering\huge}
  \posttitle{\par}
  $endif$
$else$
  \title{}
  $if(compact-title)$
  \pretitle{\vspace{\droptitle}}
  \posttitle{}
  $endif$
$endif$
$if(subtitle)$
\subtitle{$subtitle$}
$endif$
$if(author)$
  \author{$for(author)$$author$$sep$ \\ $endfor$}
  $if(compact-title)$
  \preauthor{\centering\large\emph}
  \postauthor{\par}
  $endif$
$else$
  \author{}
  $if(compact-title)$
  \preauthor{}\postauthor{}
  $endif$
$endif$
$if(date)$
  $if(compact-title)$
  \predate{\centering\large\emph}
  \postdate{\par}
  $endif$
  \date{$date$}
$else$
  \date{}
  $if(compact-title)$
  \predate{}\postdate{}
  $endif$
$endif$

$for(header-includes)$
$header-includes$
$endfor$

\begin{document}
$if(title)$
\maketitle
$endif$
$if(abstract)$
\begin{abstract}
$abstract$
\end{abstract}
$endif$

$for(include-before)$
$include-before$

$endfor$
$if(toc)$
{
$if(colorlinks)$
\hypersetup{linkcolor=$if(toccolor)$$toccolor$$else$black$endif$}
$endif$
\setcounter{tocdepth}{$toc-depth$}
\tableofcontents
}
$endif$
$if(lot)$
\listoftables
$endif$
$if(lof)$
\listoffigures
$endif$
$body$

$if(natbib)$
$if(bibliography)$
$if(biblio-title)$
$if(book-class)$
\renewcommand\bibname{$biblio-title$}
$else$
\renewcommand\refname{$biblio-title$}
$endif$
$endif$
\bibliography{$for(bibliography)$$bibliography$$sep$,$endfor$}

$endif$
$endif$
$if(biblatex)$
\printbibliography$if(biblio-title)$[title=$biblio-title$]$endif$

$endif$
$for(include-after)$
$include-after$

$endfor$

\end{document}
EOF


cat > src/main/tut/slides.md << EOF
---
layout: docs
title:  "Slides"
section: "slides"
position: 3
---

# $MICRODEGREE_NAME - Slides

Welcome to the **$MICRODEGREE_NAME Slides** site!
EOF

cat > slides/0-0.md << EOF

### whoami

Jane Doe

@[jdoe]

[jdoe]: https://en.wikipedia.org/wiki/John_Doe

------

### Agenda

1. first
2. second
3. third

------

### Your title

your content

------

EOF

# Setup layout
cat > menu.yml << EOF
options:

    #############################
    # DOCUMENTATION (path = docs/*.html)
    #############################

  - title: Welcome!
    url: docs.html
    menu_type: docs

  - title: M0 - Example Module
    url: docs/0-module.html
    menu_type: docs

    #############################
    # SLIDES (path = microsite/slides/*.html)
    #############################

  - title: Welcome!
    url: slides.html
    menu_type: slides

  - title: 0-0 - Example Session
    url: microsite/slides/0-0.html
    menu_type: slides

    #############################
    # PDFS (path = microsite/pdf/*.pdf)
    #############################

  - title: Welcome!
    url: pdfs.html
    menu_type: pdfs

  - title: M0 - Example PDF
    url: microsite/pdf/0-module.pdf
    menu_type: pdfs

EOF

# Setup mathjax
cat > $RESOURCES_PATH/js/mathjax-config.js << EOF
MathJax.Hub.Config({
    tex2jax: {
        inlineMath: [ ['$','$'], ["\\(","\\)"] ],
        processEscapes: true
    }
});

MathJax.Ajax.loadComplete("http://localhost:8080/$MICRODEGREE_GITHUB_REPO/js/mathjax-config.js");
EOF

# Setup reveal.js
export REVEALJS_DOWNLOAD_URL='https://github.com/hakimel/reveal.js/archive/master.zip'
wget $REVEALJS_DOWNLOAD_URL -O reveal.js.zip
unzip reveal.js.zip -d $RESOURCES_PATH/slides
mv $RESOURCES_PATH/slides/reveal.js-master $RESOURCES_PATH/slides/reveal.js
rm reveal.js.zip

# Create build.sbt file
cat > build.sbt << EOF
import sbt._
import microsites._

enablePlugins(MicrositesPlugin)

lazy val root = (project in file(".")).
  settings(
    inThisBuild(List(
      organization := "com.microtau",
      scalaVersion := "2.12.8",
      version      := "0.0.0-SNAPSHOT"
    )),
    name := "$MICRODEGREE_GITHUB_REPO",
    micrositeName := "$MICRODEGREE_NAME",
    micrositeDescription      := "$MICRODEGREE_DESCRIPTION",
    micrositeBaseUrl          := "/$MICRODEGREE_GITHUB_REPO",
    micrositeDocumentationUrl := "/$MICRODEGREE_GITHUB_REPO/docs.html",
    micrositeAuthor           := "micro-tau",
    micrositeGitterChannel    := true,
    micrositeGitterChannelUrl := "micro-tau/$MICRODEGREE_GITHUB_REPO",
    micrositeHomepage         := "https://microtau.github.io/$MICRODEGREE_GITHUB_REPO",
    micrositeGithubOwner      := "micro-tau",
    micrositeGithubRepo       := "$MICRODEGREE_GITHUB_REPO",
    micrositeHighlightLanguages ++= Seq("haskell", "fsharp", "scala", "python", "java"),
    micrositeCDNDirectives    := CdnDirectives(
      jsList = List(
        "https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.5/MathJax.js?config=TeX-MML-AM_CHTML,https://microtau.github.io/$MICRODEGREE_GITHUB_REPO/js/mathjax-config.js"
      )
    ),
    micrositePalette := Map(
        "brand-primary"     -> "#E05236",
        "brand-secondary"   -> "#3F3242",
        "brand-tertiary"    -> "#2D232F",
        "gray-dark"         -> "#453E46",
        "gray"              -> "#837F84",
        "gray-light"        -> "#E3E2E3",
        "gray-lighter"      -> "#F4F3F4",
        "white-color"       -> "#FFFFFF"
    ),
    libraryDependencies ++= {
      val scalaTestVersion = "3.0.5"
      Seq(
        "org.scalatest" %% "scalatest" % scalaTestVersion
      )
    }
)
EOF

# Create the publish script
cat > publish << 'EOF'
#!/bin/bash

makeSlides () {
  while read -r slide
  do
    echo "Generating reveal.js slide for: ${slide}"
    session=$(sed -e 's/^"//' -e 's/"$//' <<< "$slide")
    title=$(cat slides/config.json | jq -r --arg v "$session" '."\($v)".title')
    author=$(cat slides/config.json | jq -r --arg v "$session" '."\($v)".author')
    pandoc \
            --from markdown+tex_math_single_backslash+inline_code_attributes \
            --standalone --mathjax \
            --variable colorlinks=true \
            --to revealjs \
            --output src/main/resources/microsite/slides/${session}.html \
            -V theme:night \
            "--metadata=title:\"${title}\"" \
            "--metadata=author:\"${author}\"" \
            slides/${session}.md
  done < <(cat slides/config.json | jq 'keys | .[]')
}

makeDocs () {
  while read -r rdoc
  do
    doc=$(sed -e 's/^"//' -e 's/"$//' <<< "$rdoc")
    title=$(cat docs/config.json | jq -r --arg v "$doc" '."\($v)".title')
    author=$(cat docs/config.json | jq -r --arg v "$doc" '."\($v)".author')
    echo "Generating documentation for: ${doc}"
    printf "rmarkdown::render('$PWD/docs/$doc.rmd', clean=FALSE, run_pandoc=FALSE)" | R --vanilla --quiet
    pandoc +RTS -K512m -RTS docs/${doc}.utf8.md \
        --to markdown_github \
        --from markdown+autolink_bare_uris+ascii_identifiers+tex_math_single_backslash \
        --output docs/${doc}.md \
        --standalone \
        '--metadata=bibliography:"references.bib"'
    echo -e "---\nlayout: docs\ntitle: \"${title}\"\nsection: \"docs\" \nauthor: \"${author}\"\n---\n" | cat - docs/${doc}.md > docs/temp
    sed -i -e 's/``` tut/```tut/g' docs/temp
    sed -i -e 's/``` scala/```scala/g' docs/temp
    sed -i -e 's/``` python/```python/g' docs/temp
    mv docs/temp src/main/tut/docs/${doc}.md
    if [[ -d "docs/${doc}_files" ]]; then
        rm -rf src/main/tut/docs/${doc}_files
        mv docs/${doc}_files src/main/tut/docs/${doc}_files
    fi
    rm docs/${doc}.knit.md docs/${doc}.utf8.md docs/${doc}.md
  done < <(cat docs/config.json | jq 'keys | .[]')
}

makePdfs () {
  while read -r mdoc
  do
    module="$(basename ${mdoc} .md)"
    title=$(cat docs/config.json | jq -r --arg v "$module" '."\($v)".title')
    author=$(cat docs/config.json | jq -r --arg v "$module" '."\($v)".author')
    echo "Generating pdf for: ${module}"
    if [[ ! -d "src/main/resources/microsite/pdf" ]]; then
        mkdir -p src/main/resources/microsite/pdf
    fi
    pdf_path="${PWD}/src/main/resources/microsite/pdf/${module}.pdf"
    file_path="${PWD}/target/scala-2.12/resource_managed/main/jekyll/docs/${module}.md"
    resources_path="target/scala-2.12/resource_managed/main /jekyll/docs/${module}_files"
    pandoc +RTS -K512m -RTS ${file_path} \
            --to latex \
            --from markdown+autolink_bare_uris+ascii_identifiers+tex_math_single_backslash \
            --output ${pdf_path} \
            --template template.tex \
            --highlight-style tango \
            --latex-engine xelatex \
            --variable mainfont="Linux Libertine O" \
            --variable graphics=yes \
            "--metadata=title:\"${title}\"" \
            --variable 'geometry:margin=1.5in' \
            --variable urlcolor=blue \
            --variable fontsize=11pt \
            --variable 'compact-title:yes'
  done < <(find target/scala-2.12/resource_managed/main/jekyll/docs -name "*.md")
}

resetState () {
  rm -rf target/
  rm -rf _site
}

micrositeFiles () {
  cp menu.yml src/main/resources/microsite/data/menu.yml
  echo -e "---\nlayout: home\ntitle: \"Microdegree\"\nsection: \"home\" \nposition: 1\n---\n" | cat - README.md > src/main/tut/index.md
}

while [[ ! $# -eq 0 ]]
do
    case "$1" in
        --help | -h)
            echo "publish [OPTIONS]"
            echo "  -h --help  : displays the help menu."
            echo "  -l --local : builds the microsite and runs the local service with jekyll."
            echo "  -s --site  : builds the microsite and publish the site into Github pages."
            exit
            ;;
        --local | -l)
            echo "Running microsite in local mode..."
            micrositeFiles
            resetState
            makeSlides
            makeDocs
            sbt makeMicrosite
            makePdfs
            resetState
            sbt makeMicrosite
            jekyll serve -s target/site
            exit
            ;;
        --site | -s)
            echo "Publishing microsite..."
            micrositeFiles
            resetState
            makeSlides
            makeDocs
            sbt makeMicrosite
            makePdfs
            resetState
            sbt makeMicrosite
            sbt ghpagesPushSite
            exit
            ;;
    esac
    shift
done

EOF

# Create LICENSE file
cat > LICENSE.md << EOF
Attribution-ShareAlike 4.0 International

=======================================================================

Creative Commons Corporation ("Creative Commons") is not a law firm and
does not provide legal services or legal advice. Distribution of
Creative Commons public licenses does not create a lawyer-client or
other relationship. Creative Commons makes its licenses and related
information available on an "as-is" basis. Creative Commons gives no
warranties regarding its licenses, any material licensed under their
terms and conditions, or any related information. Creative Commons
disclaims all liability for damages resulting from their use to the
fullest extent possible.

Using Creative Commons Public Licenses

Creative Commons public licenses provide a standard set of terms and
conditions that creators and other rights holders may use to share
original works of authorship and other material subject to copyright
and certain other rights specified in the public license below. The
following considerations are for informational purposes only, are not
exhaustive, and do not form part of our licenses.

     Considerations for licensors: Our public licenses are
     intended for use by those authorized to give the public
     permission to use material in ways otherwise restricted by
     copyright and certain other rights. Our licenses are
     irrevocable. Licensors should read and understand the terms
     and conditions of the license they choose before applying it.
     Licensors should also secure all rights necessary before
     applying our licenses so that the public can reuse the
     material as expected. Licensors should clearly mark any
     material not subject to the license. This includes other CC-
     licensed material, or material used under an exception or
     limitation to copyright. More considerations for licensors:
	wiki.creativecommons.org/Considerations_for_licensors

     Considerations for the public: By using one of our public
     licenses, a licensor grants the public permission to use the
     licensed material under specified terms and conditions. If
     the licensor's permission is not necessary for any reason--for
     example, because of any applicable exception or limitation to
     copyright--then that use is not regulated by the license. Our
     licenses grant only permissions under copyright and certain
     other rights that a licensor has authority to grant. Use of
     the licensed material may still be restricted for other
     reasons, including because others have copyright or other
     rights in the material. A licensor may make special requests,
     such as asking that all changes be marked or described.
     Although not required by our licenses, you are encouraged to
     respect those requests where reasonable. More_considerations
     for the public:
	wiki.creativecommons.org/Considerations_for_licensees

=======================================================================

Creative Commons Attribution-ShareAlike 4.0 International Public
License

By exercising the Licensed Rights (defined below), You accept and agree
to be bound by the terms and conditions of this Creative Commons
Attribution-ShareAlike 4.0 International Public License ("Public
License"). To the extent this Public License may be interpreted as a
contract, You are granted the Licensed Rights in consideration of Your
acceptance of these terms and conditions, and the Licensor grants You
such rights in consideration of benefits the Licensor receives from
making the Licensed Material available under these terms and
conditions.


Section 1 -- Definitions.

  a. Adapted Material means material subject to Copyright and Similar
     Rights that is derived from or based upon the Licensed Material
     and in which the Licensed Material is translated, altered,
     arranged, transformed, or otherwise modified in a manner requiring
     permission under the Copyright and Similar Rights held by the
     Licensor. For purposes of this Public License, where the Licensed
     Material is a musical work, performance, or sound recording,
     Adapted Material is always produced where the Licensed Material is
     synched in timed relation with a moving image.

  b. Adapter's License means the license You apply to Your Copyright
     and Similar Rights in Your contributions to Adapted Material in
     accordance with the terms and conditions of this Public License.

  c. BY-SA Compatible License means a license listed at
     creativecommons.org/compatiblelicenses, approved by Creative
     Commons as essentially the equivalent of this Public License.

  d. Copyright and Similar Rights means copyright and/or similar rights
     closely related to copyright including, without limitation,
     performance, broadcast, sound recording, and Sui Generis Database
     Rights, without regard to how the rights are labeled or
     categorized. For purposes of this Public License, the rights
     specified in Section 2(b)(1)-(2) are not Copyright and Similar
     Rights.

  e. Effective Technological Measures means those measures that, in the
     absence of proper authority, may not be circumvented under laws
     fulfilling obligations under Article 11 of the WIPO Copyright
     Treaty adopted on December 20, 1996, and/or similar international
     agreements.

  f. Exceptions and Limitations means fair use, fair dealing, and/or
     any other exception or limitation to Copyright and Similar Rights
     that applies to Your use of the Licensed Material.

  g. License Elements means the license attributes listed in the name
     of a Creative Commons Public License. The License Elements of this
     Public License are Attribution and ShareAlike.

  h. Licensed Material means the artistic or literary work, database,
     or other material to which the Licensor applied this Public
     License.

  i. Licensed Rights means the rights granted to You subject to the
     terms and conditions of this Public License, which are limited to
     all Copyright and Similar Rights that apply to Your use of the
     Licensed Material and that the Licensor has authority to license.

  j. Licensor means the individual(s) or entity(ies) granting rights
     under this Public License.

  k. Share means to provide material to the public by any means or
     process that requires permission under the Licensed Rights, such
     as reproduction, public display, public performance, distribution,
     dissemination, communication, or importation, and to make material
     available to the public including in ways that members of the
     public may access the material from a place and at a time
     individually chosen by them.

  l. Sui Generis Database Rights means rights other than copyright
     resulting from Directive 96/9/EC of the European Parliament and of
     the Council of 11 March 1996 on the legal protection of databases,
     as amended and/or succeeded, as well as other essentially
     equivalent rights anywhere in the world.

  m. You means the individual or entity exercising the Licensed Rights
     under this Public License. Your has a corresponding meaning.


Section 2 -- Scope.

  a. License grant.

       1. Subject to the terms and conditions of this Public License,
          the Licensor hereby grants You a worldwide, royalty-free,
          non-sublicensable, non-exclusive, irrevocable license to
          exercise the Licensed Rights in the Licensed Material to:

            a. reproduce and Share the Licensed Material, in whole or
               in part; and

            b. produce, reproduce, and Share Adapted Material.

       2. Exceptions and Limitations. For the avoidance of doubt, where
          Exceptions and Limitations apply to Your use, this Public
          License does not apply, and You do not need to comply with
          its terms and conditions.

       3. Term. The term of this Public License is specified in Section
          6(a).

       4. Media and formats; technical modifications allowed. The
          Licensor authorizes You to exercise the Licensed Rights in
          all media and formats whether now known or hereafter created,
          and to make technical modifications necessary to do so. The
          Licensor waives and/or agrees not to assert any right or
          authority to forbid You from making technical modifications
          necessary to exercise the Licensed Rights, including
          technical modifications necessary to circumvent Effective
          Technological Measures. For purposes of this Public License,
          simply making modifications authorized by this Section 2(a)
          (4) never produces Adapted Material.

       5. Downstream recipients.

            a. Offer from the Licensor -- Licensed Material. Every
               recipient of the Licensed Material automatically
               receives an offer from the Licensor to exercise the
               Licensed Rights under the terms and conditions of this
               Public License.

            b. Additional offer from the Licensor -- Adapted Material.
               Every recipient of Adapted Material from You
               automatically receives an offer from the Licensor to
               exercise the Licensed Rights in the Adapted Material
               under the conditions of the Adapter's License You apply.

            c. No downstream restrictions. You may not offer or impose
               any additional or different terms or conditions on, or
               apply any Effective Technological Measures to, the
               Licensed Material if doing so restricts exercise of the
               Licensed Rights by any recipient of the Licensed
               Material.

       6. No endorsement. Nothing in this Public License constitutes or
          may be construed as permission to assert or imply that You
          are, or that Your use of the Licensed Material is, connected
          with, or sponsored, endorsed, or granted official status by,
          the Licensor or others designated to receive attribution as
          provided in Section 3(a)(1)(A)(i).

  b. Other rights.

       1. Moral rights, such as the right of integrity, are not
          licensed under this Public License, nor are publicity,
          privacy, and/or other similar personality rights; however, to
          the extent possible, the Licensor waives and/or agrees not to
          assert any such rights held by the Licensor to the limited
          extent necessary to allow You to exercise the Licensed
          Rights, but not otherwise.

       2. Patent and trademark rights are not licensed under this
          Public License.

       3. To the extent possible, the Licensor waives any right to
          collect royalties from You for the exercise of the Licensed
          Rights, whether directly or through a collecting society
          under any voluntary or waivable statutory or compulsory
          licensing scheme. In all other cases the Licensor expressly
          reserves any right to collect such royalties.


Section 3 -- License Conditions.

Your exercise of the Licensed Rights is expressly made subject to the
following conditions.

  a. Attribution.

       1. If You Share the Licensed Material (including in modified
          form), You must:

            a. retain the following if it is supplied by the Licensor
               with the Licensed Material:

                 i. identification of the creator(s) of the Licensed
                    Material and any others designated to receive
                    attribution, in any reasonable manner requested by
                    the Licensor (including by pseudonym if
                    designated);

                ii. a copyright notice;

               iii. a notice that refers to this Public License;

                iv. a notice that refers to the disclaimer of
                    warranties;

                 v. a URI or hyperlink to the Licensed Material to the
                    extent reasonably practicable;

            b. indicate if You modified the Licensed Material and
               retain an indication of any previous modifications; and

            c. indicate the Licensed Material is licensed under this
               Public License, and include the text of, or the URI or
               hyperlink to, this Public License.

       2. You may satisfy the conditions in Section 3(a)(1) in any
          reasonable manner based on the medium, means, and context in
          which You Share the Licensed Material. For example, it may be
          reasonable to satisfy the conditions by providing a URI or
          hyperlink to a resource that includes the required
          information.

       3. If requested by the Licensor, You must remove any of the
          information required by Section 3(a)(1)(A) to the extent
          reasonably practicable.

  b. ShareAlike.

     In addition to the conditions in Section 3(a), if You Share
     Adapted Material You produce, the following conditions also apply.

       1. The Adapter's License You apply must be a Creative Commons
          license with the same License Elements, this version or
          later, or a BY-SA Compatible License.

       2. You must include the text of, or the URI or hyperlink to, the
          Adapter's License You apply. You may satisfy this condition
          in any reasonable manner based on the medium, means, and
          context in which You Share Adapted Material.

       3. You may not offer or impose any additional or different terms
          or conditions on, or apply any Effective Technological
          Measures to, Adapted Material that restrict exercise of the
          rights granted under the Adapter's License You apply.


Section 4 -- Sui Generis Database Rights.

Where the Licensed Rights include Sui Generis Database Rights that
apply to Your use of the Licensed Material:

  a. for the avoidance of doubt, Section 2(a)(1) grants You the right
     to extract, reuse, reproduce, and Share all or a substantial
     portion of the contents of the database;

  b. if You include all or a substantial portion of the database
     contents in a database in which You have Sui Generis Database
     Rights, then the database in which You have Sui Generis Database
     Rights (but not its individual contents) is Adapted Material,

     including for purposes of Section 3(b); and
  c. You must comply with the conditions in Section 3(a) if You Share
     all or a substantial portion of the contents of the database.

For the avoidance of doubt, this Section 4 supplements and does not
replace Your obligations under this Public License where the Licensed
Rights include other Copyright and Similar Rights.


Section 5 -- Disclaimer of Warranties and Limitation of Liability.

  a. UNLESS OTHERWISE SEPARATELY UNDERTAKEN BY THE LICENSOR, TO THE
     EXTENT POSSIBLE, THE LICENSOR OFFERS THE LICENSED MATERIAL AS-IS
     AND AS-AVAILABLE, AND MAKES NO REPRESENTATIONS OR WARRANTIES OF
     ANY KIND CONCERNING THE LICENSED MATERIAL, WHETHER EXPRESS,
     IMPLIED, STATUTORY, OR OTHER. THIS INCLUDES, WITHOUT LIMITATION,
     WARRANTIES OF TITLE, MERCHANTABILITY, FITNESS FOR A PARTICULAR
     PURPOSE, NON-INFRINGEMENT, ABSENCE OF LATENT OR OTHER DEFECTS,
     ACCURACY, OR THE PRESENCE OR ABSENCE OF ERRORS, WHETHER OR NOT
     KNOWN OR DISCOVERABLE. WHERE DISCLAIMERS OF WARRANTIES ARE NOT
     ALLOWED IN FULL OR IN PART, THIS DISCLAIMER MAY NOT APPLY TO YOU.

  b. TO THE EXTENT POSSIBLE, IN NO EVENT WILL THE LICENSOR BE LIABLE
     TO YOU ON ANY LEGAL THEORY (INCLUDING, WITHOUT LIMITATION,
     NEGLIGENCE) OR OTHERWISE FOR ANY DIRECT, SPECIAL, INDIRECT,
     INCIDENTAL, CONSEQUENTIAL, PUNITIVE, EXEMPLARY, OR OTHER LOSSES,
     COSTS, EXPENSES, OR DAMAGES ARISING OUT OF THIS PUBLIC LICENSE OR
     USE OF THE LICENSED MATERIAL, EVEN IF THE LICENSOR HAS BEEN
     ADVISED OF THE POSSIBILITY OF SUCH LOSSES, COSTS, EXPENSES, OR
     DAMAGES. WHERE A LIMITATION OF LIABILITY IS NOT ALLOWED IN FULL OR
     IN PART, THIS LIMITATION MAY NOT APPLY TO YOU.

  c. The disclaimer of warranties and limitation of liability provided
     above shall be interpreted in a manner that, to the extent
     possible, most closely approximates an absolute disclaimer and
     waiver of all liability.


Section 6 -- Term and Termination.

  a. This Public License applies for the term of the Copyright and
     Similar Rights licensed here. However, if You fail to comply with
     this Public License, then Your rights under this Public License
     terminate automatically.

  b. Where Your right to use the Licensed Material has terminated under
     Section 6(a), it reinstates:

       1. automatically as of the date the violation is cured, provided
          it is cured within 30 days of Your discovery of the
          violation; or

       2. upon express reinstatement by the Licensor.

     For the avoidance of doubt, this Section 6(b) does not affect any
     right the Licensor may have to seek remedies for Your violations
     of this Public License.

  c. For the avoidance of doubt, the Licensor may also offer the
     Licensed Material under separate terms or conditions or stop
     distributing the Licensed Material at any time; however, doing so
     will not terminate this Public License.

  d. Sections 1, 5, 6, 7, and 8 survive termination of this Public
     License.


Section 7 -- Other Terms and Conditions.

  a. The Licensor shall not be bound by any additional or different
     terms or conditions communicated by You unless expressly agreed.

  b. Any arrangements, understandings, or agreements regarding the
     Licensed Material not stated herein are separate from and
     independent of the terms and conditions of this Public License.


Section 8 -- Interpretation.

  a. For the avoidance of doubt, this Public License does not, and
     shall not be interpreted to, reduce, limit, restrict, or impose
     conditions on any use of the Licensed Material that could lawfully
     be made without permission under this Public License.

  b. To the extent possible, if any provision of this Public License is
     deemed unenforceable, it shall be automatically reformed to the
     minimum extent necessary to make it enforceable. If the provision
     cannot be reformed, it shall be severed from this Public License
     without affecting the enforceability of the remaining terms and
     conditions.

  c. No term or condition of this Public License will be waived and no
     failure to comply consented to unless expressly agreed to by the
     Licensor.

  d. Nothing in this Public License constitutes or may be interpreted
     as a limitation upon, or waiver of, any privileges and immunities
     that apply to the Licensor or You, including from the legal
     processes of any jurisdiction or authority.


=======================================================================

Creative Commons is not a party to its public
licenses. Notwithstanding, Creative Commons may elect to apply one of
its public licenses to material it publishes and in those instances
will be considered the “Licensor.” The text of the Creative Commons
public licenses is dedicated to the public domain under the CC0 Public
Domain Dedication. Except for the limited purpose of indicating that
material is shared under a Creative Commons public license or as
otherwise permitted by the Creative Commons policies published at
creativecommons.org/policies, Creative Commons does not authorize the
use of the trademark "Creative Commons" or any other trademark or logo
of Creative Commons without its prior written consent including,
without limitation, in connection with any unauthorized modifications
to any of its public licenses or any other arrangements,
understandings, or agreements concerning use of licensed material. For
the avoidance of doubt, this paragraph does not form part of the
public licenses.

Creative Commons may be contacted at creativecommons.org.
EOF

# Create the pull-request template
mkdir .github
cat > .github/PULL_REQUEST_TEMPLATE.md << EOF

### What does this PR do?
...your answer...

### Is there any relevant context?
...your answer...

### Where should the reviewer focus their attention?
...your answer...

### Are there any additional testing steps?
...your answer...

### Self-evaluation key points
- [] Does the PR title contains the issue/ticket number?
- [] Does your code follows the single-responsibility principle?
- [] Does your code builds/compiles/runs and passes all the tests?
- [] Did you included/added/updated tests? If not, explain yourself here:

EOF

# Create .gitignore file
cat > .gitignore << EOF
*~
*.lock
*.DS_Store
*.swp
*.out

# rails specific
*.sqlite3
config/database.yml
log/*
tmp/*

# java specific
*.class

# python specific
*.pyc

# xcode/iphone specific
build/*
*.pbxuser
*.mode2v3
*.mode1v3
*.perspective
*.perspectivev3
*~.nib

# akka specific
logs/*

# sbt specific
target/
project/boot
lib_managed/*
project/build/target
project/build/lib_managed
project/build/src_managed
project/plugins/lib_managed
project/plugins/target
project/plugins/src_managed
project/plugins/project

core/lib_managed
core/target
pubsub/lib_managed
pubsub/target

# eclipse specific
.metadata
jrebel.lic
.settings
.classpath
.project

.ensime*
*.sublime-*
.cache

# intellij
*.eml
*.iml
*.ipr
*.iws
.*.sw?
.idea

# paulp script
/.lib/

_site/
src/main/resources/microsite/slides/*.html

.mypy_cache*
.vscode
EOF

# Create CONTRIBUTING files
touch CONTRIBUTING.md
