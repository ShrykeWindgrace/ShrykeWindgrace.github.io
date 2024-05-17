default: blog lf

blog:
	-stack exec -- blog clean
	-stack exec -- blog build

lf:
	fd -x dos2unix

build:
	stack build
