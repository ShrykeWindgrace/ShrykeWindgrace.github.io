.PHONY: default all build blog lf clean

default: blog lf
all: build blog lf

blog: _latex
	-stack exec -- blog clean
	-stack exec -- blog build

lf:
	fd -e html -x dos2unix
	fd -e css -x dos2unix
	fd -e xml -x dos2unix

build:
	stack build

_latex/%.svg : _latex/%.pdf | _latex
	echo _latex/$*.pdf
	pdftocairo -svg _latex/$*.pdf
	mv $*.svg _latex/

_latex/%.pdf : _latex/%.tex | _latex
	echo _latex/$*.tex
	pdflatex -output-directory=_latex _latex/$*.tex

clean:
	rm -r _latex/*

_latex:
	mkdir _latex

