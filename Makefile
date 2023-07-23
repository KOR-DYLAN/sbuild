export topdir 		:= $(PWD)
export scriptdir	:= scripts

O					?= build
export builddir 	?= $(O)

V					?=1
ifeq ($(V),1)
export Q 			:= @
endif

all: build

phony += build
build: library driver app

phony += app
app:
	$(MAKE) -f $(scriptdir)/build.mk subdir=app

phony += arch
arch:
	$(MAKE) -f $(scriptdir)/build.mk subdir=arch

phony += driver
driver:
	$(MAKE) -f $(scriptdir)/build.mk subdir=driver

phony += library
library:
	$(MAKE) -f $(scriptdir)/build.mk subdir=library

phony += info
info:

clean:
	rm -rf $(builddir)

.PHONY: $(phony)
