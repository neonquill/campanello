/******************************************************************************
Copyright (c) 2011, David Watson
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the owner nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL DAVID WATSON BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
******************************************************************************/

#include <avr/power.h>
#include <avr/sleep.h>
#include <avr/pgmspace.h>

#include "songs.h"

// Pin 2 == interrupt 0.
const int button_pin = 2;
const int button_interrupt = 0;

// Pin 3 == interrupt 1.
const int button2_pin = 3;
const int button2_interrupt = 1;

const int led_pin = 13;
const int motor_pin[8] = {7, 6, A5, A4, A3, A2, A1, A0};
const long ring_duration[8] = {40, 40, 40, 40, 40, 20, 40, 40};

// Debounce variables.
const long debounce = 100;  // The debounce time.

volatile unsigned long time = 0;  // The last time the button was pressed.
volatile int trigger = 0;  // A flag indicating we've seen a change.

volatile unsigned long time2 = 0;  // The last time button2 went low.
volatile int trigger2 = 0;  // A flag indicating button2 triggered.

// Masks to specify which pins we're controlling on which ports.
// Conveniently we can just mask the song bits without any math.
const unsigned char portc_mask = 0x3F;
const unsigned char portd_mask = 0xC0;

void
setup() {
  int i;
  
  Serial.begin(9600);
  
  // Setup the button pin with a pullup resistor.
  pinMode(button_pin, INPUT);
  digitalWrite(button_pin, HIGH);
  pinMode(button2_pin, INPUT);
  digitalWrite(button2_pin, HIGH);
  
  attachInterrupt(button_interrupt, button_trigger, FALLING);
  attachInterrupt(button2_interrupt, button2_trigger, FALLING);
  
  // Setup the output pins.
  pinMode(led_pin, OUTPUT);
  for (i = 0; i < 8; i++) {
    pinMode(motor_pin[i], OUTPUT);
    digitalWrite(motor_pin[i], LOW);
  }

  // Set the sleep mode to idle.  This should still allow serial comms.
  set_sleep_mode(SLEEP_MODE_IDLE);
  
  // Disable anything we don't need for the entire sketch.
  // Disable the analog to digital converter.
  ADCSRA &= ~(_BV(ADEN));
  
  // Disable the analog comparator.
  ACSR |= _BV(ACD);
  
  // XXX ??? Turn off the brown out detector?
  
  // Turn off power to the modules we don't need for the entire sketch.
  // Could also use the power_X_disable() macros.
  // This turns of A/D, TWI, SPI, and timers 1 and 2.
  PRR |= (_BV(PRADC) | _BV(PRTWI) | _BV(PRSPI) | _BV(PRTIM1) |
          _BV(PRTIM2));
}

void
loop() {

  Serial.println("Going to sleep.");
  // Delay to make sure the serial data finishes.
  delay(100);
  // Go to sleep, we'll be woken up when a button is pressed.
  sleep();
  Serial.println("Waking up!");

  if (trigger) {
    if (digitalRead(button_pin) == LOW) {
      play_song(doorbell_song);
    }
    trigger = 0;
  }
  
  if (trigger2) {
    // This might help prevent a 2nd trigger if we hold and release.
    // XXX Should we bother?
    if (digitalRead(button2_pin) == LOW) {
      play_song(mountain_song);
    }
    trigger2 = 0;
  }
  
  // Check to see if there is data to read.
  while (Serial.available() > 1) {
    process_serial_command();
  }
}

void
button_trigger() {
  unsigned long now = millis();
  
  if (now - time > debounce) {
    trigger = 1;
  }
  time = now;
}

void
button2_trigger() {
  unsigned long now = millis();

  Serial.println("%");  
  if (now - time2 > debounce) {
    trigger2 = 1;
  }
  time2 = now;
}

// process_serial_command should only be called if there are 2 bytes available!
void
process_serial_command(void) {
  char cmd;
  byte arg;
  
  cmd = Serial.read();
  arg = Serial.read();
  
  Serial.print("Processing command: ");
  Serial.print(cmd, HEX);
  Serial.print(" with arg ");
  Serial.println(arg, HEX);
  
  switch (cmd) {
    case 'S':
      if (arg < num_songs) {
        Serial.print("Playing song ");
        Serial.println(arg, DEC);
        play_song(songs[arg]);
      } else {
        Serial.println("ERROR: Song index out of range!");
      }
      break;

    case 'N':
      play_note(arg, 0);
      break;

    default:
      Serial.print("ERROR: Unknown command! ");
      Serial.println(cmd, HEX);
      break;

  }
}

void
play_note(unsigned char notes, unsigned char pause) {
  unsigned char portc;
  unsigned char portd;
  unsigned long wait;
  
  portc = notes & portc_mask;
  portd = notes & portd_mask;
    
  PORTC |= portc;
  PORTD |= portd;

  // Mechanical spacing isn't constant, adjust motor on times.
  // XXX Abstract this out.
  delay(20);
  bitClear(PORTC, 5);
  delay(20);
  PORTC &= ~portc_mask;
  PORTD &= ~portd_mask;

  // XXX wait = next - millis();
  if (pause > 40) {
    wait = pause - 40;  // XXX
    //Serial.print("Waiting: ");
    //Serial.println(wait);
    delay(wait);
  }
}

void
play_song(const unsigned char *s) {
  unsigned char notes;
  unsigned char pause;

  while (1) {
    notes = pgm_read_byte(s);
    s++;
    pause = pgm_read_byte(s);
    s++;
    
    //Serial.println(notes, BIN);
    //Serial.println(pause, DEC);
    
    if (notes == 0 && pause == 0) {
      Serial.println("All done!");
      break;
    }

    play_note(notes, pause);
  }
}

void
sleep() {
  // Disable timer0.
  // This can't be done globally, since delay() depends on it.
  power_timer0_disable();  // or use:   PRR |= _BV(PRTIM0)

  sleep_mode();
  
  // Re-enable timer0.
  power_timer0_enable();
}

