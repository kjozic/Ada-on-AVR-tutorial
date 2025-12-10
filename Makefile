DEVICE		= atmega32
LINK_ADA	= avr-gcc -mmcu=$(DEVICE)
COMPILE_ADA	= $(LINK_ADA) -c -gnat2022 -flto -gnatf -Os
COMPILE_C	= avr-gcc -Os -Wall -Wextra -Wno-unknown-pragmas -std=c23 -pedantic -mmcu=$(DEVICE)

.PHONY: all clean disasm-c_program disasm-ada_program size-c_program size-ada_program help

all: c_program.hex ada_program.hex

ada_program.o: ada_program.adb ada_program.ads
	$(COMPILE_ADA) -o ada_program.o ada_program.adb

ada_program.elf: ada_program.o
	$(LINK_ADA) -o ada_program.elf ada_program.o

ada_program.hex: ada_program.elf
	avr-objcopy -j .text -j .data -O ihex ada_program.elf ada_program.hex

c_program.elf: c_program.c
	$(COMPILE_C) -o c_program.elf c_program.c

c_program.hex: c_program.elf
	avr-objcopy -j .text -j .data -O ihex c_program.elf c_program.hex

clean:
	rm -f *.hex *.elf *.o *.ali

disasm-ada_program:	ada_program.elf
	avr-objdump -d -z ada_program.elf

disasm-c_program: c_program.elf
	avr-objdump -d -z c_program.elf

size-ada_program: ada_program.elf
	avr-objdump -Pmem-usage ada_program.elf

size-c_program: c_program.elf
	avr-objdump -Pmem-usage c_program.elf

help:
	@echo 'make [target]'
	@echo '    (empty)            - build both firmwares'
	@echo '    all                - same as target (empty)'
	@echo '    clean              - delete all temporary files'
	@echo '    disasm-ada_program - display Ada program code disassembly'
	@echo '    disasm-c_program   - display C program code disassembly'
	@echo '    size-ada_program   - display Ada program code size'
	@echo '    size-c_program     - display C program code size'
	@echo '    help               - display this help'
