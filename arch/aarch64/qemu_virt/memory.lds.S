#define CONFIG_RO_BASE      (0x00000000)
#define CONFIG_RO_LIMIT     (0x10000)

#define CONFIG_RW_BASE      (0x20000000)
#define CONFIG_RW_LIMIT     (0x40000000)

#define CONFIG_PAGE_SIZE    (0x1000)
#define DATA_ALIGN          (16)


OUTPUT_FORMAT("elf64-littleaarch64")
OUTPUT_ARCH(aarch64)
ENTRY(entrypoint)

MEMORY {
    ROM (rx): ORIGIN = CONFIG_RO_BASE, LENGTH = CONFIG_RO_LIMIT - CONFIG_RO_BASE
    RAM (rwx): ORIGIN = CONFIG_RW_BASE, LENGTH = CONFIG_RW_LIMIT - CONFIG_RW_BASE
}

SECTIONS {
    . = CONFIG_RO_BASE;

    ASSERT(. == ALIGN(PAGE_SIZE), "CONFIG_RO_BASE address is not aligned on a page boundary.")

    .text . : {
        __TEXT_START__ = .;

        *entry.o(.text*)
        *(SORT_BY_ALIGNMENT(.text*))
        *(.vectors)

        . = ALIGN(PAGE_SIZE);

        __TEXT_END__ = .;
    } >ROM

    /* .ARM.extab and .ARM.exidx are only added because Clang needs them */
    .ARM.extab . : {
        *(.ARM.extab* .gnu.linkonce.armextab.*)
    } >ROM

    .ARM.exidx . : {
        *(.ARM.exidx* .gnu.linkonce.armexidx.*)
    } >ROM

    .rodata . : {
        __RODATA_START__ = .;

        *(SORT_BY_ALIGNMENT(.rodata*))

        /*
         * No need to pad out the .rodata section to a page boundary. Next is
         * the .data section, which can mapped in ROM with the same memory
         * attributes as the .rodata section.
         *
         * Pad out to 16 bytes though as .data section needs to be 16-byte
         * aligned and lld does not align the LMA to the alignment specified
         * on the .data section.
         */
        __RODATA_END__ = .;

        . = ALIGN(16);
    } >ROM

    . = CONFIG_RW_BASE;

    ASSERT(CONFIG_RW_BASE == ALIGN(PAGE_SIZE), "CONFIG_RW_BASE address is not aligned on a page boundary.")

    .data . : ALIGN(DATA_ALIGN) {
        __DATA_START__ = .;
        *(SORT_BY_ALIGNMENT(.data*))
        __DATA_END__ = .;
    } >RAM AT>ROM

    __DATA_RAM_START__ = __DATA_START__;
    __DATA_RAM_END__ = __DATA_END__;

    .stacks (NOLOAD) : {
        __STACKS_START__ = .;
        *(.normal_stacks)
        __STACKS_END__ = .;	

        /* Allow room for the init section where necessary. */
        OFFSET = ABS(SIZEOF(.init) - (. - __STACKS_START__));

        /* Offset sign */
        SIGN = ABS(OFFSET) & (1 << 63);

        /* Offset mask */
        MASK = ABS(SIGN >> 63) - 1;
        . +=  ABS(OFFSET) & ABS(MASK);
        .  = ALIGN(PAGE_SIZE);
    } >RAM

    .bss (NOLOAD) : ALIGN(BSS_ALIGN) {
        __BSS_START__ = .;
        *(SORT_BY_ALIGNMENT(.bss*))
        *(COMMON)
        __BSS_END__ = .;
    } >RAM

    /*
     * The base address of the coherent memory section must be page-aligned to
     * guarantee that the coherent data are stored on their own pages and are
     * not mixed with normal data. This is required to set up the correct memory
     * attributes for the coherent data page tables.
     */
    .coherent_ram (NOLOAD) : ALIGN(PAGE_SIZE) {
        __COHERENT_RAM_START__ = .;
        *(.coherent_mem)
        __COHERENT_RAM_END_UNALIGNED__ = .;

        /*
         * Memory page(s) mapped to this section will be marked as device
         * memory. No other unexpected data must creep in. Ensure the rest of
         * the current memory page is unused.
         */
        . = ALIGN(PAGE_SIZE);

        __COHERENT_RAM_END__ = .;
    } >RAM

    __RAM_START__ = ADDR(.data);
    __RAM_END__ = .;

    __DATA_ROM_START__ = LOADADDR(.data);
    __DATA_SIZE__ = SIZEOF(.data);

    /*
     * The .data section is the last PROGBITS section so its end marks the end
     * of BL1's actual content in Trusted ROM.
     */
    __ROM_END__ =  __DATA_ROM_START__ + __DATA_SIZE__;

    ASSERT(__ROM_END__ <= CONFIG_RO_LIMIT, "ROM content has exceeded its limit.")

    __BSS_SIZE__ = SIZEOF(.bss);

    __COHERENT_RAM_UNALIGNED_SIZE__ =
    __COHERENT_RAM_END_UNALIGNED__ - __COHERENT_RAM_START__;

    ASSERT(. <= CONFIG_RW_LIMIT, "RW section has exceeded its limit.")
}
