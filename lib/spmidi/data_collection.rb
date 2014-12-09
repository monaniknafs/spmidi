#!/usr/local/bin/ruby
require 'unimidi'

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
				buff = input.buffer
        record_buffer = []
        index = 0

				# blocks until input comes in
				while m = input.gets[0]

					ts = m[:timestamp]
					data = m[:data]

					note = Note.new(data, ts - start_ts, ts - prev_ts, buff, index)
          prev_ts = ts

					index += 1

					if record
						if note.data == [176,64,0]
							record = false
							start_ts = ts
							puts "stopped recording"
							record_buffer.each {|x| x.sp_letter_print}
						else
		          if note.data[0] == 144
                note.lock_rel_ts(1/8.0)
								record_buffer << note
		          end
						end
					else
					 	# not recording
					 	# print only the on-notes
					 	if note.data[0] == 144
              note.sp_ambi_print
					 	end
          end

				 	# initialise recording if applicable
					if note.data == [176,64,127] # on-value as specified by keyboard
						record = true
            record_buffer = []
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