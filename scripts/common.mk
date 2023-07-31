# common include directories
common-include-dir += -Iinclude

# ================================================================
#                             Warning Level
# ================================================================
# general
general_warnings += -Wall
general_warnings += -Wmissing-include-dirs
general_warnings += -Wunused
general_warnings += -Wdisabled-optimization
general_warnings += -Wvla
general_warnings += -Wshadow
general_warnings += -Wredundant-decls
# general_warnings += Wextra
general_warnings += -Wno-trigraphs
general_warnings += -Wno-missing-field-initializers
general_warnings += -Wno-type-limits
general_warnings += -Wno-sign-compare

# level 1
warning_level_1 += -Wsign-compare
warning_level_1 += -Wtype-limits
warning_level_1 += -Wmissing-field-initializers
# level 2
warning_level_2 += -Wold-style-definition
warning_level_2 += -Wmissing-prototypes
warning_level_2 += -Wmissing-format-attribute
warning_level_2 += -Wundef
warning_level_2 += -Wunused-const-variable=2
# level 3
warning_level_3 += -Wbad-function-cast
warning_level_3 += -Waggregate-return
warning_level_3 += -Wnested-externs
warning_level_3 += -Wcast-align

# ================================================================
#                             apply flags
# ================================================================
asflags-y += $(common-include-dir)
asflags-y += $(general_warnings)
asflags-$(CONFIG_WARNING_LEVEL1) += $(warning_level_1)
asflags-$(CONFIG_WARNING_LEVEL2) += $(warning_level_2)
asflags-$(CONFIG_WARNING_LEVEL3) += $(warning_level_3)
asflags-$(CONFIG_WARNING_AS_ERROR) += -Werror

ppflags-y += $(common-include-dir)
ppflags-y += $(general_warnings)
ppflags-$(CONFIG_WARNING_LEVEL1) += $(warning_level_1)
ppflags-$(CONFIG_WARNING_LEVEL2) += $(warning_level_2)
ppflags-$(CONFIG_WARNING_LEVEL3) += $(warning_level_3)
ppflags-$(CONFIG_WARNING_AS_ERROR) += -Werror

ccflags-y += $(common-include-dir)
ccflags-y += $(general_warnings)
ccflags-$(CONFIG_WARNING_LEVEL1) += $(warning_level_1)
ccflags-$(CONFIG_WARNING_LEVEL2) += $(warning_level_2)
ccflags-$(CONFIG_WARNING_LEVEL3) += $(warning_level_3)
ccflags-$(CONFIG_WARNING_AS_ERROR) += -Werror

cxxflags-y += $(common-include-dir)
cxxflags-y += $(general_warnings)
cxxflags-$(CONFIG_WARNING_LEVEL1) += $(warning_level_1)
cxxflags-$(CONFIG_WARNING_LEVEL2) += $(warning_level_2)
cxxflags-$(CONFIG_WARNING_LEVEL3) += $(warning_level_3)
cxxflags-$(CONFIG_WARNING_AS_ERROR) += -Werror
