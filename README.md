# Ada on AVR tutorial

## Introduction

This tutorial will show you how to set up compiler infrastructure, write a minimal runtime system, write a simple test program, and compare it with an equivalent C program.

## Compiler and build system

Download and unpack GCC compiler (`gnat-avr-elf-*.tar.gz`) and GPRbuild tool (`gprbuild-*.tar.gz`) from Alire [builds][1]. Set them on the PATH of your operating system.

## Minimal runtime

Every Ada program requires a runtime system, regardless if it is being run on an operating system or on bare metal. Absolute minimum is a system.ads file in which you describe your environment, or better said, limitations of AVR architecture.

GCC compiler required certain folder structure, so we will organize it like this:

```
\Your Ada project\default.gpr
                 \obj\
                 \src\
                 \build\
                       \adainclude\system.ads
                       \adalib\system.ali
                              \system.o
                              \libgnat.a
```

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
