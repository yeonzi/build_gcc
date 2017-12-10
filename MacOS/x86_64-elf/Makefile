TARGET           = x86_64-elf
PREFIX           = /opt/local

BINUTILS_VERSION = 2.28
GCC_VERSION      = 7.1.0

GCC_BUILD = gcc-$(GCC_VERSION)
BINUTILS_BUILD = binutils-$(BINUTILS_VERSION)

OPTS = --target=$(TARGET) --prefix=$(PREFIX) --enable-targets=$(TARGET),x86_64-efi-pe --program-prefix=x86_64-elf-

BINUTILS_OPTS = $(OPTS)
GCC_OPTS      = $(OPTS) --enable-languages=c,c++ --enable-long-long --disable-nls --disable-werror

all: gcc

$(BINUTILS_BUILD).stamp: $(BINUTILS_BUILD).build
	touch $@

$(GCC_BUILD).stamp: $(GCC_BUILD).build
	touch $@

binutils: $(BINUTILS_BUILD).stamp

gcc: $(GCC_BUILD).stamp

$(GCC_BUILD).tar.gz:
	ftp ftp://ftp.gnu.org/gnu/gcc/$(GCC_BUILD)/$@

$(BINUTILS_BUILD).tar.gz:
	ftp ftp://ftp.gnu.org/gnu/binutils/$@

.SECONDARY: $(GCC_BUILD).build $(BINUTILS_BUILD).build
.PHONY: $(GCC_BUILD).build $(BINUTILS_BUILD).build

$(BINUTILS_BUILD): $(BINUTILS_BUILD).tar.gz
	tar -xvf $<


$(GCC_BUILD): $(GCC_BUILD).tar.gz
	tar -xvf $<

$(BINUTILS_BUILD).build: $(BINUTILS_BUILD)
	mkdir -p $@
	cd $@ && ../$</configure $(BINUTILS_OPTS)
	make -C $@
	make -C $@ install

$(GCC_BUILD).build: $(GCC_BUILD) $(BINUTILS_BUILD)
	mkdir -p $@
	cd $@ && ../$</configure $(GCC_OPTS)
	make -C $@ all-gcc
	make -C $@ install-gcc

