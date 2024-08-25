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
