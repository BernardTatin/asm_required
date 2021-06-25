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
	-p|--project: project name, i.e. entry point, output name
	--ld|--gcc: use ld or gcc for linking
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
link=WITH_LD

# decrypt parameters
while [ $# -ne 0 ]
do
	case $1 in
		-h|--help)
			dohelp
			;;
		-o|--output)
			p=$1
			shift
			[ $# -eq 0 ] && onerror 1 "parameter $p needs a file name"
			output=$1
			;;
		-p|--project)
			p=$1
			shift
			[ $# -eq 0 ] && onerror 1 "parameter $p needs a name"
			output=$1
			entrysrc=$1
			sources="$sources $1.asm"
			objects="${objects} ${entrysrc}.o"
			;;
		-r|--run)
			dorun=1
			;;
		--ld)
			link=WITH_LD
			;;
		--gcc)
			link=WITH_GCC
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

#cat <<NASM
#nasm -D${link} -f  elf64 -g -Iinclude/ \
	#-l ${entrysrc}.lst ${sources} \
	#|| onerror 2 "nasm failed"
#NASM

for s in ${sources}
do
	cat <<NASM
nasm -D${link} -f  elf64 -g -Iinclude/ \
	-l ${s}.lst ${s} \
	|| onerror 2 "nasm ${s} failed"
NASM
nasm -D${link} -f  elf64 -g -Iinclude/ \
	-l ${s}.lst ${s} \
	|| onerror 2 "nasm ${s} failed"
done
#nasm -D${link} -f  elf64 -g -Iinclude/ \
	#-l ${entrysrc}.lst ${sources} \
	#|| onerror 2 "nasm failed"

if [ ${link} = 'WITH_LD' ]
then
	cat <<LD
	ld -o ${output} ${objects} -Map=${output}.map --xref
LD
	ld -o ${output} ${objects} -Map=${output}.map --cref  \
		|| onerror 3 "ld failed"
fi
if [ ${link} = 'WITH_GCC' ]
then
	gcc -m64 -fno-pie -no-pie -o ${output} ${objects}  \
		|| onerror 3 "ld failed"
fi
[ ${dorun} -eq 1 ] && ./${output}

exit 0
