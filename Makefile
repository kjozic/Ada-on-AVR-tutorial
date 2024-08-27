BIN 		= /home/kreso/bin/gnat-avr-elf-linux64-14.1.0-3/bin
DEVICE      = atmega32
COMPILE     = $(BIN)/avr-gcc -Os --RTS=build -mmcu=$(DEVICE)

.PHONY: all clean check flash disasm size help

all: main.hex main.eep

main.o: src/main.adb src/main.ads
	$(COMPILE) -c -ffunction-sections -fdata-sections -gnat2022 src/main.adb

program.o: src/program.adb src/program.ads
	$(COMPILE) -c -ffunction-sections -fdata-sections -gnat2022 src/program.adb

a.out: main.o program.o
	$(COMPILE) -Wl,--gc-sections -Wl,--relax -o main.elf main.o program.o

main.hex: a.out
	$(BIN)/avr-objcopy -j .text -j .data -O ihex a.out main.hex

main.eep: a.out
	$(BIN)/avr-objcopy -j .eeprom --no-change-warnings --change-section-lma .eeprom=0 -O ihex a.out main.eep

clean:
	rm -f main.hex main.eep *.ali *.o a.out

flash:
	avrdude -c usbasp -p m32 -U lfuse:w:0xff:m -U hfuse:w:0xc9:m -U flash:w:main.hex:i -U eeprom:w:main.eep:i

disasm:	a.out
	$(BIN)/avr-objdump -d a.out

size:
	$(BIN)/avr-objdump -Pmem-usage a.out

help:
	@echo 'make [target]'
	@echo '    (empty) - build firmware'
	@echo '    all     - same as target (empty)'
	@echo '    clean   - delete all temporary files'
	@echo '    flash   - combine firmware with bootloader, transfer it to MPU and flash it to MCU'
	@echo '    disasm  - display code disassembly'
	@echo '    size    - display code size'
	@echo '    help    - display this help'
