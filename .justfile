set windows-shell := ["nu", "-c"]

blogExe := if os() == "windows" {"stack exec -- blog"} else {"blog"}

default: lf
all: build blog lf

blog: _latex
	{{blogExe}} clean
	{{blogExe}} build

lf:
	fd -e html -x dos2unix
	fd -e css -x dos2unix
	fd -e xml -x dos2unix

build:
	stack build

clean:
	rm -rf _latex/*

clean-all: clean
	{{blogExe}} clean

_latex:
	mkdir _latex
