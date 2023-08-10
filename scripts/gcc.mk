# ================================================================
#                             COMMON
# ================================================================
ifneq ($(CONFIG_CROSS_COMPILE),)
	CROSS_COMPILE := $(CONFIG_CROSS_COMPILE)
endif
AS		:= $(CROSS_COMPILE)gcc
CPP		:= $(CROSS_COMPILE)gcc -E
CC		:= $(CROSS_COMPILE)gcc
CXX		:= $(CROSS_COMPILE)g++
AR		:= $(CROSS_COMPILE)ar
LD		:= $(CROSS_COMPILE)ld
OC		:= $(CROSS_COMPILE)objcopy
OD		:= $(CROSS_COMPILE)objdump
NM		:= $(CROSS_COMPILE)nm
SZ		:= $(CROSS_COMPILE)size
STRIP	:= $(CROSS_COMPILE)strip
READELF	:= $(CROSS_COMPILE)readelf

# build type
ifeq ($(CONFIG_BUILD_TYPE_DEBUG),y)
	asflags-y += -g -Wa,-gdwarf-4
	ccflags-y += -g -gdwarf-4
	cxxflags-y += -g -gdwarf-4
else
	ccflags-y += -O2
	cxxflags-y += -O2
endif

# ================================================================
#                             Warning Level
# ================================================================
compiler_warning += -Wunused-but-set-variable
compiler_warning += -Wmaybe-uninitialized
compiler_warning += -Wpacked-bitfield-compat
compiler_warning += -Wshift-overflow=2
compiler_warning += -Wlogical-op


# ================================================================
#                             ARM
# ================================================================
# set arm arch version
ifeq ($(CONFIG_ARM_ARCH_MINOR),0)
	ccflags-$(CONFIG_ARCH_ARM) += -march=arm$(CONFIG_ARM_ARCH_MAJOR)-a
else
	ccflags-$(CONFIG_ARCH_ARM) += -march=arm$(CONFIG_ARM_ARCH_MAJOR).$(CONFIG_ARM_ARCH_MINOR)-a
endif

# set arm instruction set
ifeq ($(CONFIG_AARCH32_INSTRUCTION_SET_ARM),y)
	ccflags += -marm
else ifeq ($(CONFIG_AARCH32_INSTRUCTION_SET_ARM),y)
	ccflags += -mthumb
endif
