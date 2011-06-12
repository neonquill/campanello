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

// Songs!
// First byte is the bitmask for which notes to hit.
// Second byte is the duration in milliseconds.
// 0, 0 is the terminator.
const unsigned char scale_song[] PROGMEM =
  {128, 255,
   0, 245,
   64, 255,
   0, 245,
   32, 255,
   0, 245,
   16, 255,
   0, 245,
   8, 255,
   0, 245,
   4, 255,
   0, 245,
   2, 255,
   0, 245,
   1, 0,
   0, 0};

const unsigned char doorbell_song[] PROGMEM =
  {8, 255,
   0, 245,
   32, 0,
   0, 0};

// She'll Be Coming 'Round the Mountain.
const unsigned char mountain_song[] PROGMEM =
  {8, 250,
   4, 250,
   1, 125,
   1, 125,
   0, 250,
   1, 250,
   0, 125,
   1, 125,
   4, 250,
   8, 250,
   32, 250,
   8, 250,
   1, 255,
   0, 255,
   0, 255,
   0, 255,
   0, 255,
   0, 225,
   0, 0};

// Happy Birthday.
// 135 bpm, 3/4 time.
// 888 (255, 255, 255, 123) milliseconds = half note.
// 444 (255, 189) milliseconds = quarter note.
// 222 milliseconds = eigth note.
// 111 milliseconds = sixteenth note.
const unsigned char birthday_song[] PROGMEM =
  {128, 255,
   0, 78,
   128, 111,
   64, 255,
   0, 189,
   128, 255,
   0, 189,
   16, 255,
   0, 189,
   32, 255,
   0, 255,
   0, 255,
   0, 123,
   128, 255,
   0, 78,
   128, 111,
   64, 255,
   0, 189,
   128, 255,
   0, 189,
   8, 255,
   0, 189,
   16, 255,
   0, 255,
   0, 255,
   0, 123,
   128, 255,
   0, 78,
   128, 111,
   1, 255,
   0, 189,
   4, 255,
   0, 189,
   16, 255,
   0, 189,
   32, 255,
   0, 189,
   64, 255,
   0, 255,
   0, 255,
   0, 123,
   8, 255,
   0, 78,
   8, 111,
   4, 255,
   0, 189,
   16, 255,
   0, 189,
   8, 255,
   0, 189,
   16, 255,
   0, 255,
   0, 255,
   0, 255,
   0, 255,
   0, 57,
   0, 0};

const unsigned char birthday_short_song[] PROGMEM =
  {128, 255,
   0, 78,
   128, 111,
   64, 255,
   0, 189,
   128, 255,
   0, 189,
   16, 255,
   0, 189,
   32, 255,
   0, 255,
   0, 255,
   0, 123,
   0, 0};

// Ode to Joy
// 1020 (255, 255, 255, 255) milliseconds = half note.
// 510 (255, 255) milliseconds = quarter note.
// 255 (255) milliseconds = eigth note.
const unsigned char ode_to_joy_song[] PROGMEM =
  {32, 255, 0, 255,
   32, 255, 0, 255,
   16, 255, 0, 255,
   8, 255, 0, 255,
   8, 255, 0, 255,
   16, 255, 0, 255,
   32, 255, 0, 255,
   64, 255, 0, 255,
   128, 255, 0, 255,
   128, 255, 0, 255,
   64, 255, 0, 255,
   32, 255, 0, 255,
   32, 255, 0, 255, 0, 255,
   64, 255,
   64, 255, 0, 255, 0, 255, 0, 255,

   32, 255, 0, 255,
   32, 255, 0, 255,
   16, 255, 0, 255,
   8, 255, 0, 255,
   8, 255, 0, 255,
   16, 255, 0, 255,
   32, 255, 0, 255,
   64, 255, 0, 255,
   128, 255, 0, 255,
   128, 255, 0, 255,
   64, 255, 0, 255,
   32, 255, 0, 255,
   64, 255, 0, 255, 0, 255,
   128, 255,
   128, 255, 0, 255, 0, 255, 0, 255,

   64, 255, 0, 255,
   64, 255, 0, 255,
   32, 255, 0, 255,
   128, 255, 0, 255,
   64, 255, 0, 255,
   32, 255,
   16, 255,
   32, 255, 0, 255,
   128, 255, 0, 255,
   64, 255, 0, 255,
   32, 255,
   16, 255,
   32, 255, 0, 255,
   64, 255, 0, 255,
   128, 255, 0, 255,
   64, 255, 0, 255,
   8, 255, 0, 255, 0, 255, 0, 255,

   32, 255, 0, 255,
   32, 255, 0, 255,
   16, 255, 0, 255,
   8, 255, 0, 255,
   8, 255, 0, 255,
   16, 255, 0, 255,
   32, 255, 0, 255,
   64, 255, 0, 255,
   128, 255, 0, 255,
   128, 255, 0, 255,
   64, 255, 0, 255,
   32, 255, 0, 255,
   64, 255, 0, 255, 0, 255,
   128, 255,
   128, 255, 0, 255, 0, 255, 0, 255,

   0, 0};

const int num_songs = 5;

// Add PROGMEM here if this list gets long.
// See http://www.arduino.cc/en/Reference/PROGMEM
const unsigned char *songs[num_songs] =
  {
    doorbell_song,
    scale_song,
    mountain_song,
    birthday_song,
    ode_to_joy_song,
  };

