export topdir 		:= $(PWD)
export scriptdir	:= scripts

O					?= build
export builddir 	?= $(O)

V					?=0
ifeq ($(V),0)
export Q 			:= @
endif

MAKEFLAGS 			+= --no-print-directory

all: build

phony += build
build: library driver arch app

phony += app
app:
	$(Q)$(MAKE) -f $(scriptdir)/build.mk subdir=app

phony += arch
arch:
	$(Q)$(MAKE) -f $(scriptdir)/build.mk subdir=arch

phony += driver
driver:
	$(Q)$(MAKE) -f $(scriptdir)/build.mk subdir=driver

phony += library
library:
	$(Q)$(MAKE) -f $(scriptdir)/build.mk subdir=library

phony += info
info:

clean:
	rm -rf $(builddir)

.PHONY: $(phony)
