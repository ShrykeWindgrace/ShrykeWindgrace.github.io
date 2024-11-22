default: blog lf
all: build blog lf

blog:
	-stack exec -- blog clean
	-stack exec -- blog build

lf:
	fd -e html -x dos2unix
	fd -e css -x dos2unix

build:
	stack build

_latex/%.svg : _latex/%.pdf
	echo _latex/$*.pdf
	pdftocairo -svg _latex/$*.pdf
	mv $*.svg _latex/

_latex/%.pdf : _latex/%.tex
	echo _latex/$*.tex
	pdflatex -output-directory=_latex _latex/$*.tex

clean:
	rm -r _latex/*
