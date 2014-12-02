#!/usr/local/bin/ruby
require 'unimidi'
require 'set'

module SPMidi
	class DataCollection

		def lock_to_structure(note_ts_array, min_time_element)
			# min_time_element in milliseconds
			last_ts = 0
			structured_array = Array.new

			note_ts_array.each do |note_ts|
				# collect values from hash
				d = note_ts[:note]
				ts = note_ts[:timestamp]
				rts = note_ts[:rel_ts]

				# round to nearest min_time_element multiple
				ts = round_to_frac(ts, min_time_element)
				
				# add structured array entry
				structured_array << {:note => d,
					 				:timestamp => ts, 
					 				:rel_ts => ts - last_ts}

				# update new last timestamp (n-1th timestamp)
				last_ts = ts
			end
			return structured_array
		end

		def organise_print_buffer(data_ts_array)
			# takes hash array, each element is {:data => , :timestamp => }
			# returns hash array, each element is {:note => , :ts => , :rel_ts => }
			# also prints each element of hash array
			buff = Array.new

			if !data_ts_array.empty?
				start_ts = data_ts_array[0][:timestamp]
				last_ts = 0
			end

			data_ts_array.each do |data_ts|
				if data_ts[:data][0] == 144
					note = data_ts[:data]
					ts = data_ts[:timestamp] - start_ts
					rel_ts = ts - last_ts
					buff << {:note => note, 
							:ts => ts, 
							:rel_ts => rel_ts}
					last_ts = ts
					puts "sleep #{buff.last[:rel_ts]/1000}"
					puts "play #{buff.last[:note][1]}"
				end
			end

			return buff
		end

		def runtime()
			# KORG nanoKEY2 produces notes from C_octave5 down to C_octave3
			# assuming MIDI keyboard is last input
			input = UniMIDI::Input.last
			input.clear_buffer
			buff = Array.new

			# runtime behaviour
			input.open do |input|
				puts "give me some notes!"
				record = false

			# blocks until input comes in
			while m = input.gets[0]
					note = m[:data] # an array [status, pitch, velocity]			

				 	# initialise recording if applicable
					if note == [176,64,127]
						start = input.buffer.length
						record = true
						puts "started recording"
					end

					if record 
						if note == [176,64,0]
							finish = input.buffer.length
							record = false
							puts "stopped recording"
							recorded_data = input.buffer.slice(start-1,finish-2)
							organise_print_buffer(recorded_data)
						end
					else
					 	# not recording
					 	# print notes, only the on-notes
					 	if note[0] == 144
					 		# only print the pitch-value
					 		puts note_letter(note[1])
					 	end

					end
				end
			end
		end
		d = DataCollection.new
		d.runtime()
	end
end