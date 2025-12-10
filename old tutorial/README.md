# Ada on AVR tutorial

## Introduction

This tutorial will show you how to set up compiler infrastructure, write a minimal runtime system, write a simple test program, and compare it with an equivalent C program.

## Compiler and build system

Download and unpack GCC compiler (`gnat-avr-elf-*.tar.gz`) and GPRbuild tool (`gprbuild-*.tar.gz`) from [Alire builds](https://github.com/alire-project/GNAT-FSF-builds/releases). Set them on the PATH of your operating system.

**Note:** Please use GCC and GPRbuild from the same source because there is a high probability that GPRbuild won't recognize your GCC compiler if installed from different source.

## Folder structure

We will organize our folders like this:

```text
\Your Ada project\default.gpr
                 \obj\
                 \src\
                 \build\
                       \adainclude\system.ads
                       \adalib\system.ali
                              \system.o
                              \libgnat.a
```

## Minimal runtime system (RTS)

Every Ada program requires a runtime system, regardless if it is being run on an operating system or on bare metal. Absolute minimum is a `system.ads` file in which you describe your environment, or better said, limitations of AVR architecture.

### system.ads

system.ads consists of the following sections:

- Configuration pragmas
- Restriction pragmas
- Program unit level restrictions
- System private part

For details of each section please consult following documentation:

- [GNAT Reference Manual](https://docs.adacore.com/gnat_rm-docs/html/gnat_rm/gnat_rm.html)
- [GNAT User’s Guide for Native Platforms](https://docs.adacore.com/gnat_ugn-docs/html/gnat_ugn/gnat_ugn.html)
- [GNAT User’s Guide Supplement for Cross Platforms](https://docs.adacore.com/live/wave/gnat_ugx/html/gnat_ugx/gnat_ugx.html)
- [GCC source code](https://github.com/gcc-mirror/gcc/tree/master/gcc/ada)

### Other system files

Other system files are not necessary for basic functionality. For some instructions (CLI, SEI) you can reference external [builtin functions](https://gcc.gnu.org/onlinedocs/gcc/AVR-Built-in-Functions.html) from the C library which comes with GCC.

For more advanced functionality, like using data from the flash memory, you will have to use assembly code. To use assembly code, you have to define the procedure `Asm` which must be in the package `System.Machine_Code` in the `s-maccod.ads` file. File `s-maccod.ads` must reside in the `adainclude` folder together with `system.ads`.

### Compiling system files

To compile system files, execute the command `avr-gcc -gnatg -c -Ibuild/adainclude/ -I- build/adainclude/*.ads`. To link them into a static library, execute the command `avr-ar rcs libgnat.a *.o`. Move the resulting .o, .ali, and libgnat.a files to the `adalib` folder.

## Test program

Although the test program is rather small, it demonstrates the following functionalities:

- Access variables from flash memory
- Implement an interrupt handler
- Use the GCC C library's built-in functions
- Use the C runtime to set up interrupt vector table and startup code

To build a test program, you have to write a `default.gpr` file and execute the `gprbuild` command. To clean files from the build stage, execute the `gprclean` command.

### default.gpr file which does not optimize executable file size

This is a minimal configuration that produces a correct, but non-optimal executable file. For .gpr file structure and switches, please consult [GPR Tools User's Guide](https://docs.adacore.com/gprbuild-docs/html/gprbuild_ug.html) and [GNAT User’s Guide for Native Platforms](https://docs.adacore.com/gnat_ugn-docs/html/gnat_ugn/gnat_ugn.html).

```text
project Default is
    for Source_Dirs use ("src");
    for Object_Dir use "obj";
    for Main use ("main.adb");
    for Runtime("Ada") use "build";
    for Target use "avr-elf";

    package Builder is
        for Executable_Suffix use ".elf";
    end Builder;

    package Compiler is
        for Default_Switches ("Ada") use ("-Os", "-mmcu=atmega32", "-gnat2022");
    end Compiler;

    package Linker is
        for Default_Switches ("Ada") use ("-lgcc", "-mmcu=atmega32");
    end Linker;
end Default;
```

**NOTE:** Compiler based on the `-mmcu` switch uses C run time library (CRT) to set up interrupt vector table and startup code (in this case it used `crtatmega32.o` which comes with the compiler).

### default.gpr file which produces minimal compiled executable file

Because AVR is a constrained architecture, you will probably want to produce a small executable file.

```text
project Default is
    for Source_Dirs use ("src");
    for Object_Dir use "obj";
    for Main use ("main.adb");
    for Runtime("Ada") use "build";
    for Target use "avr-elf";

    package Builder is
        for Executable_Suffix use ".elf";
    end Builder;

    package Compiler is
        for Default_Switches ("Ada") use ("-Os", "-mmcu=atmega32", "-ffunction-sections", "-fdata-sections", "-gnat2022");
    end Compiler;

    package Binder is
        for Default_Switches ("Ada") use ("-minimal");
    end Binder;

    package Linker is
        for Default_Switches ("Ada") use ("-lgcc", "-mmcu=atmega32", "-Wl,--gc-sections", "-Wl,--relax");
    end Linker;
end Default;
```

**NOTE:** Never use the `-nostdlib` compiler switch (although almost all tutorials on the Internet recommend that) because GCC won't insert code for interrupt vector table and startup code.

### Final actions before flashing the MCU

Get EEPROM, flash, and RAM usage:

```bash
avr-objdump -Pmem-usage obj/main.elf
```

Disassemble code:

```bash
avr-objdump -d obj/main.elf
```

Convert .elf to .hex file:

```bash
avr-objcopy -j .text -j .data -O ihex obj/main.elf main.hex
```

Flash .hex file to the MCU:

```bash
avrdude -c usbasp -p m32 -U lfuse:w:0xff:m -U hfuse:w:0xc9:m -U flash:w:main.hex:i
```

## Comparism with C program

### Equivalent C program

```C
#define F_CPU 8'000'000UL

#ifndef __AVR_ATmega32__
#define __AVR_ATmega32__
#endif

#include <avr/interrupt.h>
#include <avr/io.h>
#include <avr/pgmspace.h>

const uint8_t mydata PROGMEM = 171;

int main() {
    DDRB = 0xFF;
    PORTB = pgm_read_byte(&mydata);
    sei();

    while (1) {}
}

ISR(TIMER0_OVF_vect) {
}
```

Compile it with the command: `avr-gcc -Os -Wall -Wextra -std=c23 -pedantic -mmcu=atmega32 -Wl,--gc-sections -Wl,--relax -ffunction-sections -fdata-sections -o main.elf compare.c`.

### Program sizes

| Language | Flash usage | RAM usage |
|----------|-------------|-----------|
| Ada      | 176         | 2         |
| C        | 126         | 0         |

If we compare sizes, we can see that Ada uses only 48 bytes more in flash storage and 2 bytes more in RAM. If we compare disassembled  code, we can see that the interrupt vector table is the same (except they have different offsets) and that our code is identical. The only difference is that Ada has more startup code, which is a consequence of the way Ada elaboration works.

If you are worried about Ada performance, don't be because the same compiler generates code from both languages, and the resulting code will be very similar if not identical (as we can see in this example). If you are concerned about code size and performance in critical sections (interrupt handlers), you can always disable Ada generated checks with the usage of an appropriate pragma.

## Learning resources

For more complete Run Time System, library, and examples, you can visit [Rolf Ebert's GitHub page](https://github.com/RREE).

For more detailed studies, you can visit [Adacore's learning resources](https://learn.adacore.com/index.html).
