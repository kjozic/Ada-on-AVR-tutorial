# Ada on AVR tutorial

## Introduction

This tutorial will show you how to set up compiler infrastructure, write a minimal runtime system, write a simple test program, and compare it with an equivalent C program.

## Needed software

- GCC compiler
- make
- AVRDUDE (optional for flashing the MCU)
- Simulide (optional for simulations)

## Compiler and build system

Download and unpack GCC compiler (`gnat-avr-elf-*.tar.gz`) from [Alire builds](https://github.com/alire-project/GNAT-FSF-builds/releases). Set it to the PATH of your operating system.

## Folder structure

All files should be located in the same folder without any subfolders.

## Minimal runtime system (RTS)

Every Ada program requires a runtime system, regardless if it is being run on an operating system or on bare metal. Absolute minimum is a `system.ads` file in which you describe your environment.

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

For more advanced functionality, like using data from the flash memory, you will have to use assembly code. To use assembly code, you have to define the procedure `Asm` which must be in the package `System.Machine_Code` in the `s-maccod.ads` file.

## Test program

Test program is implemented in Ada and in C.
Although the test program is rather small, it demonstrates the following functionalities:

- Access variables from flash memory
- Implement an empty interrupt handler
- Use the GCC C library's built-in functions

## Build and use programs

Build test program (both versions):

```bash
make
```

Clean builds:

```bash
make clean
```

Get help:

```bash
make help
```

Get EEPROM, flash, and RAM usage:

```bash
make size-ada_program
make size-c_program
```

Disassemble code:

```bash
make disasm-ada_program
make disasm-c_program
```

Flash .hex file to the MCU:

```bash
avrdude -c usbasp -p m32 -U lfuse:w:0xff:m -U hfuse:w:0xc9:m -U flash:w:ada_program.hex:i
avrdude -c usbasp -p m32 -U lfuse:w:0xff:m -U hfuse:w:0xc9:m -U flash:w:c_program.hex:i
```

## Program sizes

| Language | Flash usage | RAM usage |
|----------|-------------|-----------|
| Ada      | 132         | 0         |
| C        | 132         | 0         |

If we compare sizes, we can see that Ada uses the same number of bytes as a C program. The same compiler generates code from both languages, and the resulting code will be very similar if not identical (as we can see in this example). If there is a concern about code size and performance in critical sections (interrupt handlers), it is possible to disable Ada generated checks with the usage of an appropriate pragma.

## Simulations

Open `simulation.sim1` in Simulide, load appropriate .hex file and start simulation.

## Learning resources

- For more complete Run Time System, library, and examples, you can visit [Rolf Ebert's GitHub page](https://github.com/RREE).
- For more detailed studies, you can visit [Adacore's learning resources](https://learn.adacore.com/index.html).
- Real world [example](https://gitlab.com/davor405550/dir-frequency-display) of program for audio systems
