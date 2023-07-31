-include .config
include $(scriptdir)/gcc.mk
include $(scriptdir)/common.mk
include $(objects)

ldflags := $(addprefix -Wl,$(ldflags-y))
arflags := rcs

all: $(target)

$(builddir)/%.elf: $(obj) $(lds)
ifeq ($(lds),)
	@printf "%-10s $@\n" "[LD]"
	$(Q)$(CC) $(ldflags) -Wl,-Map=$(basename $@).map -o $@ $(obj)
else
	@printf "%-10s $@\n" "[LD]"
	$(Q)$(CC) $(ldflags) -Wl,-Map=$(basename $@).map -Wl,--script,$(lds) -o $@ $(obj)
	$(Q)$(CROSS_COMPILE)$(SZ) $@
endif

ifeq ($(CONFIG_EXPORT_ASM),y)
	@printf "%-10s $(basename $@).asm\n" "[OD]"
	$(Q)$(CROSS_COMPILE)$(OD) -d $@ > $(basename $@).asm
endif

ifeq ($(CONFIG_EXPORT_BIN),y)
	@printf "%-10s $(basename $@).bin\n" "[OC]"
	$(Q)$(CROSS_COMPILE)$(OC) -O binary $@ $(basename $@).bin
endif

$(builddir)/%.a: $(obj)
	@printf "%-10s $@\n" "[AR]"
	$(Q)$(AR) $(arflags) -o $@ $(obj)

.PHONY += $(target)