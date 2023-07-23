include $(scriptdir)/gcc.mk
include $(subdir)/Makefile

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
	$(MAKE) -f $(scriptdir)/build.mk subdir=$(subdir)/$(basename $@) basedir=$(subdir)/$(basename $@)

phony += $(lib)
%.a:
	$(Q)mkdir -p $(builddir)/$(subdir)/$(basename $@)
	$(MAKE) -f $(scriptdir)/build.mk subdir=$(subdir)/$(basename $@) basedir=$(subdir)/$(basename $@)

phony += $(dir)
%.dir:
	$(Q)mkdir -p $(builddir)/$(subdir)/$(basename $@)
	$(MAKE) -f $(scriptdir)/build.mk subdir=$(subdir)/$(basename $@) basedir=$(basedir)

$(builddir)/%.o: %.c
	$(CC) -c $< -o $@

$(builddir)/%.o: %.cpp
	$(CC) -c $< -o $@

$(builddir)/%.o: %.S
	$(CC) -c $< -o $@

$(builddir)/%.lds: %.lds.S
	$(CC) -c $< -o $@

info:
	$(Q)echo "topdir   : $(topdir)"
	$(Q)echo "scriptdir: $(scriptdir)"
	$(Q)echo "builddir : $(builddir)"
	$(Q)echo "app      : $(app)"
