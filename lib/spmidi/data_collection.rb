#!/usr/local/bin/ruby
require 'unimidi'
require 'set'

module SPMidi
	class DataCollection
		def down_octave(note, x=1)
			# default is to move down one octave as name suggests
			new_note = note - x*12
			if new_note.between?(0,127)
				return new_note
			else
				puts "can't move that far, check down_octave method inputs"
				return note
			end
		end

		def note_letter(note)
			note_array = [:C,:Cs,:D,:Ds,:E,:F,:Fs,:G,:Gs,:A,:As,:B]
			note_name =  note_array[note % 12]
			note_with_octave = "#{note_name}#{note_octave(note)}"
			return note_with_octave
		end

		def note_octave(note)
			if note.between?(0,127)
				return note / 12
			end
		end

		def randomise(note_ts_array)
			max = 10 # cap for random number range
			last_ts = 0
			note_ts_array.each do |note_ts|
				note_ts[:timestamp] = note_ts[:timestamp]*Random::rand(max)/max
				note_ts[:relative_ts] = note_ts[:timestamp] - last_ts
				last_ts = note_ts[:relative_ts]
			end
			# now note_ts_array is no longer ordered by timestamp
			return note_ts_array
		end

		def lock_to_structure(note_ts_array, min_time_element)
			# min_time_element in milliseconds
			last_ts = 0
			note_ts_array.each do |note_ts|
				# TODO: round up and down, this is quite hacky and wrong
				note_ts[:timestamp] = note_ts[:timestamp] - (note_ts[:timestamp] % min_time_element)
				note_ts[:relative_ts] = note_ts[:relative_ts] - (note_ts[:relative_ts] % min_time_element)
				last_ts = note_ts[:relative_ts]
			end
		end # mutating buffer, not good TODO

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
				# applicable only if record is true
				start_ts = 0 # marks beginning of recording
				last_ts = 0 # most recent note's timestamp

			while m = input.gets[0]
					note = m[:data] # an array [status, pitch, velocity]
					ts = m[:timestamp] # milliseconds after input.open

					if record
					# set record value
					# use sustain button for recording
						if note == [176,64,0]
							record = false
							puts "stopped recording"
							if (!buff.empty?)
								puts "recorded data:"
								lock_to_structure(buff, 1/8.0)
								buff.each do |b|
									puts "sleep #{b[:relative_ts]/1000}"
									puts "play #{b[:data][1]}"
								end
								# puts randomise(buff)
								# puts lock_to_structure(buff, 1/16)
							end
						end

						# core action
					 	if note[0] == 144
					 		buff << {:data => note,
					 				:timestamp => ts - start_ts, 
					 				:relative_ts => ts - last_ts}
					 		last_ts = ts
							puts note_letter(note[1])
						end
					else
					 	# not recording
					 	# initialise buffer if applicable
						if note == [176,64,127]
							buff = Array.new
							start_ts = ts # marks beginning of recording
							last_ts = ts # most recent note's timestamp
							record = true
							puts "started recording"
						end

						# core action
					 	# only print the on-notes
					 	if note[0] == 144
					 		# only print the pitch-value
					 		puts note_letter(note[1])
					 	end
					end
				end
			end
		end
	end
end