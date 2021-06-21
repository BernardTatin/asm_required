#!/bin/sh

script=$(basename $0)

onerror() {
	exitcode=$1
	shift
	echo "$@"
	exit ${exitcode}
}

dohelp() {
	cat <<DOHELP
${script} [-h|--help]: this text
${script} [OPTIONS] file ...
OPTIONS:
	-o file|--output file: name of output file
	-r|--run: run aftetr linking
DOHELP
	exit 0
}

# no paramaters, run help
[ $# -eq 0 ] && dohelp

sources=
entrysrc=
objects=
output=a.out
dorun=0

# decrypt parameters
while [ $# -ne 0 ]
do
	case $1 in
		-h|--help)
			dohelp
			;;
		-o|--output)
			shift
			[ $# -eq 0 ] && onerror 1 "parameter $1 needs a file name"
			output=$1
			;;
		-r|--run)
			dorun=1
			;;
		*)
			sources="$sources $1"
			entrysrc=$(basename $1 .asm)
			objects="${objects} ${entrysrc}.o"
			;;
	esac
	shift
done

echo "sources : $sources"
echo "objects : $objects"
echo "output  : $output"

nasm -g -l ${entrysrc}.lst -f  elf64 ${sources} || onerror 2 "nasm failed"

ld -o ${output} ${objects} || onerror 3 "ld failed"
# gcc -m64 -fno-pie -no-pie -o ${output} ${objects} || onerror 3 "ld failed"
[ ${dorun} -eq 1 ] && ./${output}

exit 0
