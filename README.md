# Microdegree Scaffold

This repository contains scaffold-code to create micro-tau microdegrees. 

## Create a microdegree

[Ubuntu] is MicroTau's OS of choice for developing and maintaining microdregrees. Windows devs might consider using the [Windows Subsystem for Linux]. This instructions assume you will be using a debian-based linux distro. 

[Ubuntu]: https://www.ubuntu.com/ 
[Windows Subsystem for Linux]: https://docs.microsoft.com/en-us/windows/wsl/about

Create the working directory for the microdegree and define the properties in a `microdegree.props` file. Consider an example microdegree named `microdegree-example`. Create the working dir:

```commandline
$ mkdir microdegree-example
$ cd microdegree-example
```

Now create a `microdegree.props` file with the following content:
```text
#!/usr/bin/env bash

export MICRODEGREE_NAME="Microdegree Example"
export MICRODEGREE_DESCRIPTION="This an example microdegree"
export MICRODEGREE_GITHUB_REPO="microdegree-example"
export MICRODEGREE_PACKAGE_NAME="example"
```

Some considerations:
* `MICRODEGREE_NAME` variable is used as a title in the microsite. Consider setting a name with less than 4 words.
* `MICRODEGREE_DESCRIPTION` variable will be shown as a header. Thus, consider using a short description. 
* `MICRODEGREE_GITHUB_REPO` must exactly match the name of the gitub repository. This is used to publish this microdegree into github pages.
* `MICRODEGREE_PACKAGE_NAME` is used for scala related source files.


With this in place, you can bootstrap the microdegree:

1. Load the environment variables.
    * `source microdegree.props`
2. Install bootstrap dependencies.
    * `sudo apt install curl wget`
3. Run the bootstrap script:
    * `curl -sSL https://raw.githubusercontent.com/micro-tau/microdegree-scaffold/master/create-microdegree.sh | sh`

Note that this script creates all the files needed to run the microdegree site. For more configuration options, see the official [microsite] documentation.

[microsite]: https://github.com/47deg/sbt-microsites

A working understanding the project directory structure: 

```text
|- docs/                : Contains the source .rmd files that eventually are converted into .md, .html, and .pdf files. 
|   |- 0-module.rmd     : Example module 0.
|   |- config.json      : Contains the config info for each .rmd file in this dir.
|- slides/              : Contains the source .md files for to generate the `reveal.js` slides.
|   |- 0-0.md           : Example of module 0 session 0 markdown file.
|   |- config.json      : Contains the config info for each .md file in this dir.
|- references.bib       : A bibtex file that contains all the references.
|- menu.yml             : A config document that used by the microdegree site to serve content (all files must be register here).
|- publish              : Script used to publish either a local version of the site or to github-pages.
|- README.md            : Markdown file with a detailed description of the microdegree, used as a landing page. 
```

To run the microdegree in local mode follow these steps:

1. Install the microdegree dependencies:
    * `source ./setup-scripts/ubuntu.sh`
    * **Note** that you might want to copy-paste the `GEM_HOME` env variable and add to path `$GEM_HOME/bin` into your commandline config file (e.g., `.bashrc`, `.zshrc`) for future usage of jekyll.
2. Run the microsite in local mode:
    * `./publish.sh --local`

Congrats! You got your first microdegree up and running. 

## Developing a microdegree

### Admin
To be defined.

### Developer Practice
To be defined.

### Content Creation
To be defined.

## Publishing a microdegree
To be defined. 