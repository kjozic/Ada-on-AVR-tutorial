#define F_CPU 8'000'000UL

#ifndef __AVR_ATmega32__
#define __AVR_ATmega32__
#endif

#include <avr/interrupt.h>
#include <avr/io.h>
#include <avr/pgmspace.h>

const uint8_t ValueStoredInFlash PROGMEM = 171;

int main()
{
    DDRB = 0xFF;
    PORTB = pgm_read_byte(&ValueStoredInFlash);
    sei();

    while (1)
    {
    }
}

ISR(TIMER0_OVF_vect)
{
}
