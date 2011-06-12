#!/usr/bin/env python

# Copyright (c) 2011, David Watson
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of the owner nor the
#       names of its contributors may be used to endorse or promote products
#       derived from this software without specific prior written permission.
# 
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL DAVID WATSON BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


import web
import serial
import struct

urls = (
	'/', 'index',
	'/song/(.+)', 'song',
	'/note/(.+)', 'note'
)

app = web.application(urls, globals())

ser = serial.Serial('/dev/ttyUSB0', 9600, timeout=10)

class index:
	def GET(self):
		return "Hello, world!"

class song:
	def GET(self, song_id):
		song = int(song_id)
		cmd = struct.pack("=cB", 'S', song)
		ser.flushInput()
		ser.write(cmd)
		#line = ser.read(1024)
		return "Playing song"

class note:
	def GET(self, note_id):
		note = 8 - int(note_id)
		note_bin = 1 << note
		cmd = struct.pack("=cB", 'N', note_bin)
		ser.flushInput()
		ser.write(cmd)
		#line = ser.read(1024)
		return "Playing note"


if __name__ == "__main__":
	web.wsgi.runwsgi = lambda func, addr=None: web.wsgi.runfcgi(func, addr)
	app.run()
