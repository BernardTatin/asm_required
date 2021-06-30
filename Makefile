# ----------------------------------------------------------------------
# Makefile
# ----------------------------------------------------------------------

NASM ?= nasm
LD ?= ld

ASINCLUDE = -Iinclude
ASDEFINES = -DWITH_$(LD)
ASOPTIONS = -f  elf64 -g
ASFLAGS   += $(ASINCLUDE) $(ASDEFINES) $(ASOPTIONS)

HELP_EPARATOR = '\#\#\#'
help:							### this text
	@cat  $(MAKEFILE_LIST) | grep -E '^[[:alpha:]][^:]+:' | grep '$(HELP_EPARATOR)' | sed 's/:\(..*\)###/: /'
	@echo 'help done'

%.o: %.asm
	$(NASM) $(ASFLAGS) -l $<.lst -o $@ $<

all: acat ahex cpuid			### all targets

acat: acat.o acat.data.o		### acat: a simple cat
	$(LD) $(LDFLAGS) -o $@ $?

ahex: ahex.o ahex.data.o		### ahex: a simple hexdump
	$(LD) $(LDFLAGS) -o $@ $?

cpuid: cpuid.o cpuid.data.o		### cpuid: a simple cpuid
	$(LD) $(LDFLAGS) -o $@ $?

clean-acat:						### clean acat
	rm -fv acat.o acat.data.o
	rm -fv acat.lst acat.data.lst

clean-ahex:						### clean ahex
	rm -fv ahex.o ahex.data.o
	rm -fv ahex.lst ahex.data.lst

clean-cpuid:					### clean cpuid
	rm -fv cpuid.o cpuid.data.o
	rm -fv cpuid.lst cpuid.data.lst

clean: clean-acat clean-ahex clean-cpuid	### clean all

.PHONY: help all clean-acat clean-ahex clean-cpuid clean

