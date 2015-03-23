#!/usr/local/bin/ruby
require_relative 'samples'

module SPMidi
  class Note
    attr_accessor :data, :ts, :rel_ts
    
    def initialize(data, ts, rel_ts)
      @data = data # an array [status, pitch, velocity]
      @ts = ts # timestamp relative to input connection
      @rel_ts = rel_ts # timestamp relative to prev note played
    end

    def ==(note)
      @data[1] == note.data[1] && 
      @rel_ts == note.rel_ts
    end

    def eql?(note)
      # ts is not tested
      # ts is unique to note
      @data[1] == note.data[1]
    end

    def hash
      @data.dup.concat([@rel_ts]).hash
    end

    def down_octave(x=1) 
      # default is to move down one octave as name suggests
      old_note = @data[1]
      new_note = old_note - x*12

      if new_note.between?(0,127)
        return new_note
      else
        puts "can't move that far, check down_octave method inputs"
        return old_note
      end
    end

    def note_letter()
      # uses note_octave method seen below
      # can i use @ with this and put it as 'global' variable?
      note_array = [:C,:Cs,:D,:Ds,:E,:F,:Fs,:G,:Gs,:A,:As,:B]
      note_name =  note_array[@data[1] % 12]
      note_with_octave = "#{note_name}#{note_octave()}"
      return note_with_octave
    end

    def note_octave()
      # octaves start from 0 up to 10
      # by MIDI note constraints
      return @data[1] / 12
    end

    def lock_to_structure(rel_ts_or_ts, element)
      # min_time_element in milliseconds
      timestamp = (rel_ts_or_ts == "rel_ts" ? @rel_ts : @ts)
      r = timestamp % element
      rounded_ts = timestamp - r + (r >= element / 2.0 ? element : 0)
      return rounded_ts
    end

    def lock_rel_ts(element)
      @rel_ts = lock_to_structure("rel_ts", element)
    end

    def lock_ts(element)
      @ts = lock_to_structure("ts", element)
    end

    def print
      puts "data: #{data}, rel ts: #{rel_ts}"
    end

    def sp_number_print()
      puts "sleep #{@rel_ts/1000}"
      puts "play :#{@data[1]}"
    end

    def sp_letter_print()
      # TODO: what units does sonic pi use between notes?
      # answer: ts relative to beats per minute; fix once integrated
      puts "sleep #{@rel_ts/1000}"
      puts "play :#{note_letter()}"
    end

    def sp_electric_print()
      s = Samples.new
      puts "sleep #{@rel_ts/1000}"
      puts "sample :#{s.electric(@data[1])}"
    end

    def sp_ambi_print()
      s = Samples.new
      pitch = data[1]
      reg_pitch = pitch - 48
      if (reg_pitch).between?(0,9) 
        puts "sleep #{@rel_ts/1000}"
        puts "sample :#{s.ambi(reg_pitch)}"
      end
    end

    def sp_ambi_print()
      s = Samples.new
      pitch = data[1]
      reg_pitch = pitch - 48
      if (reg_pitch).between?(0,7) 
        puts "sleep #{@rel_ts/1000}"
        puts "sample :#{s.bass(reg_pitch)}"
      end
    end

    def sp_drum_print()
      s = Samples.new
      pitch = data[1]
      reg_pitch = pitch - 48
      if (reg_pitch).between?(0,17) 
        puts "sleep #{@rel_ts/1000}"
        puts "sample :#{s.drum(reg_pitch)}"
      end
    end
  end
end