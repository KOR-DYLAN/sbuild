-include .config
include $(scriptdir)/gcc.mk
include $(scriptdir)/common.mk
include $(subdir)/Makefile

basedir 	?=
shipped 	?=
app 		:= $(addsuffix .elf,$(app-y))
lib 		:= $(addsuffix .a,$(lib-y))
drv 		:= $(addsuffix .a,$(drv-y))
dir 		:= $(addsuffix .dir,$(dir-y))
lds 		:= $(addprefix $(builddir)/$(subdir)/,$(lds-y))
obj 		:= $(addprefix $(builddir)/$(subdir)/,$(obj-y))
dep 		:= $(addsuffix .d,$(obj))
inc			:= $(addprefix -I$(basedir),$(inc-y)) $(addprefix -I$(basedir),$(sub-inc-y))
asflags		:= $(asflags-y) $(sub-asflags-y)
ppflags		:= $(ppflags-y) $(sub-ppflags-y)
ccflags		:= $(ccflags-y) $(sub-ccflags-y)
cxxflags	:= $(cxxflags-y) $(sub-cxxflags-y)
arflags		:= $(arflags-y) $(sub-arflags-y)
ldflags		:= $(ldflags-y) $(sub-ldflags-y)
recipe 		:= $(app) $(lib) $(drv) $(dir) $(obj) $(lds)

$(foreach var,$(obj),$(shell echo "obj += $(var)" >> $(basedir)/tmp.txt))

# make_target macro defines
# Arguments:
#   $(1) = target Makefile
#   $(2) = subdir
#   $(3) = basedir
#   $(4) = objects
#   $(5) = lds
#   $(6) = target
# Sample:
#	$(call make_target,file,subdir,basedir,objects,lds,target)
#   
define make_target
$(Q)$(MAKE) -f $(1) subdir=$(2) basedir=$(3) objects=$(4) lds=$(5) target=$(6) shipped=$(shipped) sub-inc-y='$(sub-inc-y)' sub-asflags-y='$(sub-asflags-y)' sub-ppflags-y='$(sub-ppflags-y)' sub-ccflags-y='$(sub-ccflags-y)' sub-cxxflags-y='$(sub-cxxflags-y)' sub-arflags-y='$(sub-arflags-y)' sub-ldflags-y='$(sub-ldflags-y)'
endef

all: $(recipe)

phony += $(app)
%.elf:
	$(Q)mkdir -p $(builddir)/$(subdir)/$(basename $@)
	$(Q)rm -f $(builddir)/$(subdir)/$(basename $@)/tmp.txt
	$(call make_target,$(scriptdir)/build.mk,$(subdir)/$(basename $@),$(builddir)/$(subdir)/$(basename $@),,)
	$(Q)sort $(builddir)/$(subdir)/$(basename $@)/tmp.txt > $(builddir)/$(subdir)/$(basename $@)/objects.mk
	$(call make_target,$(scriptdir)/Makefile,,,$(builddir)/$(subdir)/$(basename $@)/objects.mk,$(lds),$(builddir)/$(subdir)/$(basename $@)/$@)

phony += $(lib)
%.a:
	$(Q)mkdir -p $(builddir)/$(subdir)/$(basename $@)
	$(Q)rm -f $(builddir)/$(subdir)/$(basename $@)/tmp.txt
	$(call make_target,$(scriptdir)/build.mk,$(subdir)/$(basename $@),$(builddir)/$(subdir)/$(basename $@),,,)
	$(Q)sort $(builddir)/$(subdir)/$(basename $@)/tmp.txt > $(builddir)/$(subdir)/$(basename $@)/objects.mk
	$(call make_target,$(scriptdir)/Makefile,,,$(builddir)/$(subdir)/$(basename $@)/objects.mk,,$(builddir)/$(subdir)/$(basename $@)/$@)

phony += $(dir)
%.dir:
	$(Q)mkdir -p $(builddir)/$(subdir)/$(basename $@)
	$(call make_target,$(scriptdir)/build.mk,$(subdir)/$(basename $@),$(basedir),,,)

$(builddir)/%.o: %.c
	@printf "%-10s $<\n" "[CC]"
	$(Q)$(CC) $(inc) $(ccflags) -c $< -o $@ -MMD -MP

$(builddir)/%.o: %.cpp
	@printf "%-10s $<\n" "[CXX]"
	$(Q)$(CC) $(inc) $(cxxflags) -c $< -o $@ -MMD -MP

$(builddir)/%.o: %.S
	@printf "%-10s $<\n" "[AS]"
	$(Q)$(CC) $(inc) -D__ASM__ -x assembler-with-cpp $(asflags) -c $< -o $@ -MMD -MP

$(builddir)/%.lds: %.lds.S
	@printf "%-10s $<\n" "[CPP]"
	$(Q)$(CPP) $(inc) $(ppflags) -P -x assembler-with-cpp -D__LINKER__ -o $@ $< -MMD -MP

-include $(dep)
