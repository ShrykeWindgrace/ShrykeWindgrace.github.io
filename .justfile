set windows-shell := ["nu", "-c"]

blogExe := if os() == "windows" {"stack exec -- blog"} else {"blog"}

lat := "_latex"

default: lf
all: build blog lf

blog: _latex
    {{blogExe}} clean
    {{blogExe}} build

lf:
    fd -e html -x dos2unix
    fd -e css -x dos2unix
    fd -e xml -x dos2unix

[windows]
build:
    stack build

[linux]
build:
    echo "building should be handled by your 'nix+direnv' environment"

clean:
    rm -rf {{lat}}/*

clean-all: clean
    {{blogExe}} clean

[linux]
_latex:
    #!/usr/bin/env bash
    set -euxo pipefail
    if [ ! -d {{lat}} ]; then
        mkdir {{lat}}
    fi

[windows]
_latex:
    mkdir {{lat}}

