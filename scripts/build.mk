include $(scriptdir)/gcc.mk
include $(subdir)/Makefile

basedir ?=
app := $(addsuffix .elf,$(app-y))
lib := $(addsuffix .a,$(lib-y))
drv := $(addsuffix .a,$(drv-y))
dir := $(addsuffix .dir,$(dir-y))
obj := $(addprefix $(builddir)/$(subdir)/,$(obj-y))

target = $(app) $(lib) $(drv) $(dir) $(obj)

all: $(target)

phony += $(app)
%.elf:
	$(Q)mkdir -p $(builddir)/$(subdir)/$(basename $@)
	$(Q)rm -f $(builddir)/$(subdir)/$(basename $@)/tmp.txt
	$(MAKE) -f $(scriptdir)/build.mk subdir=$(subdir)/$(basename $@) basedir=$(builddir)/$(subdir)/$(basename $@)
	$(Q)sort $(builddir)/$(subdir)/$(basename $@)/tmp.txt > $(builddir)/$(subdir)/$(basename $@)/objects.mk
	$(MAKE) -f $(scriptdir)/Makefile target=$(builddir)/$(subdir)/$(basename $@)/$@ objects=$(builddir)/$(subdir)/$(basename $@)/objects.mk

phony += $(lib)
%.a:
	$(Q)mkdir -p $(builddir)/$(subdir)/$(basename $@)
	$(Q)rm -f $(builddir)/$(subdir)/$(basename $@)/tmp.txt
	$(MAKE) -f $(scriptdir)/build.mk subdir=$(subdir)/$(basename $@) basedir=$(builddir)/$(subdir)/$(basename $@)
	$(Q)sort $(builddir)/$(subdir)/$(basename $@)/tmp.txt > $(builddir)/$(subdir)/$(basename $@)/objects.mk

phony += $(dir)
%.dir:
	$(Q)mkdir -p $(builddir)/$(subdir)/$(basename $@)
	$(MAKE) -f $(scriptdir)/build.mk subdir=$(subdir)/$(basename $@) basedir=$(basedir)

$(builddir)/%.o: %.c
	$(CC) -c $< -o $@
	@echo "obj += $@" >> $(basedir)/tmp.txt

$(builddir)/%.o: %.cpp
	$(CC) -c $< -o $@
	@echo "obj += $@" >> $(basedir)/tmp.txt

$(builddir)/%.o: %.S
	$(CC) -c $< -o $@
	@echo "obj += $@" >> $(basedir)/tmp.txt

$(builddir)/%.lds: %.lds.S
	$(CC) -c $< -o $@
	@echo "lds += $@" >> $(basedir)/tmp.txt

info:
	$(Q)echo "topdir   : $(topdir)"
	$(Q)echo "scriptdir: $(scriptdir)"
	$(Q)echo "builddir : $(builddir)"
	$(Q)echo "app      : $(app)"
