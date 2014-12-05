#!/usr/local/bin/ruby
require 'unimidi'
require 'set'
require_relative 'note'

module SPMidi
	class DataCollection
		def runtime()
			# KORG nanoKEY2 produces notes from C_octave5 down to C_octave3
			# assuming MIDI keyboard is last input
			input = UniMIDI::Input.last
			input.clear_buffer

			# buff = Array.new
			prev_ts = 0 # use for relative timestamp
			start_ts = 0 # use to identify start of recording

			# runtime behaviour
			input.open do |input|
				puts "give me some notes!"
				record = false

				# blocks until input comes in
				while m = input.gets[0]
					buff = input.buffer
					record_buffer = Array.new
					index = 0

					ts = m[:timestamp]
					data = m[:data]

					fresh_ts = ts - start_ts
					note = Note.new(data, fresh_ts, fresh_ts - prev_ts, buff, index)
          prev_ts = ts	
					index += 1

					if record
						if note.data == [176,64,0]
							record = false
							start_ts = 0
							puts "stopped recording"
							# print record buffer maybe, if i don't want to do it inline?
							# TODO : make note print method, and array print method
						else
							record_buffer << note
						end
					else
					 	# not recording
					 	# print only the on-notes
					 	if note.data[0] == 144
					 		# only print the pitch-value
					 		puts note.note_letter
					 	end
					end

				 	# initialise recording if applicable
					if note.data == [176,64,127] # on-value as specified by keyboard
						record = true
						start_ts = ts
						puts "started recording"
					end

				end
			end
		end

		d = DataCollection.new
		d.runtime()
	end
end
# TODO: work out how to properly clear buffer, so on/off button actually works