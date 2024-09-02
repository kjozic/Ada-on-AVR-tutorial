# Ada on AVR tutorial

## Introduction

This tutorial will show you how to set up compiler infrastructure, write a minimal runtime system, write a simple test program, and compare it with an equivalent C program.

## Compiler and build system

Download and unpack GCC compiler (`gnat-avr-elf-*.tar.gz`) and GPRbuild tool (`gprbuild-*.tar.gz`) from Alire [builds][1]. Set them on the PATH of your operating system.

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

system.ads consists of 4 sections:

- Configuration pragmas
- Restriction pragmas
- Program unit level restrictions
- System private part

For details of each section please consult following documentation:

- [GNAT Reference Manual][2]
- [GNAT User’s Guide for Native Platforms][3]
- [GNAT User’s Guide Supplement for Cross Platforms][4]
- [GCC source code][5]

### Other system files

Other system files are not necessary for basic functionality. For some instructions (CLI, SEI) you can reference external [builtin functions][6] from the C library which comes with GCC.

For more advanced functionality, like using data from the flash memory, you will have to use assembly code. To use assembly code, you have to define the procedure `Asm` which must be in the package `System.Machine_Code` in the `s-maccod.ads` file. File `s-maccod.ads` must reside in the `adainclude` folder together with `system.ads`.

### Compiling system files

To compile system files, execute the command `avr-gcc -gnatg -c -Ibuild/adainclude/ -I- build/adainclude/*.ads`. To link them into a static library, execute the command `avr-ar rcs libgnat.a *.o`. Move the resulting .o, .ali, and libgnat.a files to the `adalib` folder.

## Test program

## Comparism with C

Equivalent C program is:

```C
#define F_CPU 8'000'000UL

#ifndef __AVR_ATmega32__
#define __AVR_ATmega32__
#endif

#include <avr/interrupt.h>
#include <avr/io.h>
#include <avr/pgmspace.h>

const uint8_t mydata PROGMEM = 171;

void test() {
    DDRB = 0xFF;
    PORTB = pgm_read_byte(&mydata);
    sei();

    while (1) {}
}

int main() {
    test();
}

ISR(TIMER0_OVF_vect) {
}
```

## References

- [1]: https://github.com/alire-project/GNAT-FSF-builds/releases (Alire builds)
- [2]: https://docs.adacore.com/gnat_rm-docs/html/gnat_rm/gnat_rm.html (GNAT Reference Manual)
- [3]: https://docs.adacore.com/gnat_ugn-docs/html/gnat_ugn/gnat_ugn.html (GNAT User’s Guide for Native Platforms)
- [4]: https://docs.adacore.com/live/wave/gnat_ugx/html/gnat_ugx/gnat_ugx.html (GNAT User’s Guide Supplement for Cross Platforms)
- [5]: https://github.com/gcc-mirror/gcc/tree/master/gcc/ada (GCC source code)
- [6]: https://gcc.gnu.org/onlinedocs/gcc/AVR-Built-in-Functions.html (GCC AVR Built-in Functions)
