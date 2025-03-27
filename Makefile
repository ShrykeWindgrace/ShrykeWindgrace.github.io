.PHONY: default all build blog lf clean deprecate

default: deprecate blog lf
all:  deprecate build blog lf

blog: deprecate _latex
	-stack exec -- blog clean
	-stack exec -- blog build

lf: deprecate
	fd -e html -x dos2unix
	fd -e css -x dos2unix
	fd -e xml -x dos2unix

build: deprecate
	stack build

_latex/%.svg :  deprecate _latex/%.pdf | _latex
	echo _latex/$*.pdf
	pdftocairo -svg _latex/$*.pdf
	mv $*.svg _latex/

_latex/%.pdf :  deprecate _latex/%.tex | _latex
	echo _latex/$*.tex
	pdflatex -output-directory=_latex _latex/$*.tex

clean: deprecate
	rm -r _latex/*

_latex: deprecate
	mkdir _latex

deprecate:
	echo "please switch to using 'just'"
