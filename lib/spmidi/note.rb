#!/usr/local/bin/ruby
require_relative 'samples'

module SPMidi
  class Note
    attr_accessor :data, :ts, :rel_ts, :wild_ts
    
    def initialize(data, ts, rel_ts)
      @data = data # an array [status, pitch, velocity]
      @ts = ts # timestamp relative to input connection
      @rel_ts = rel_ts # timestamp relative to prev note played
      @wild_ts = !@rel_ts # false if rel_ts exists; i.e is a Float
    end

    def ==(note)
      # ts unique to each note, not tested 
      if note == nil 
        false
      elsif @wild_ts
        @data[1] == note.data[1]
        # for now leave it wild
      else
        @data[1] == note.data[1] && 
        @rel_ts == note.rel_ts
      end
    end

    # bear in mind eql? isn't overridden

    def hash
      @data.dup.concat([@ts]).hash
    end

    def set_rel_ts(new_rel_ts)
      @rel_ts = new_rel_ts
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
      if !@wild_ts
        timestamp = (rel_ts_or_ts == "rel_ts" ? @rel_ts : @ts)
        r = timestamp % element
        rounded_ts = timestamp - r + (r >= element / 2.0 ? element : 0)
        return rounded_ts
      else 
        puts "can't lock non-existent timestamp of a wild ts element, honey!"
        return
      end
    end

    def lock_rel_ts(element)
      if !@wild_ts
        @rel_ts = lock_to_structure("rel_ts", element)
      else 
        puts "can't lock non-existent timestamp of a wild ts element, honey!"
        return
      end     
    end

    def lock_ts(element)
      @ts = lock_to_structure("ts", element)
    end

    def print
      if !@wild_ts
        puts "data: #{data}, rel ts: #{rel_ts}"
      else 
        puts "data: #{data}, rel ts: *"
      end
    end

    def sp_number_print()
      if !@wild_ts
        puts "sleep #{@rel_ts/1000}"
        puts "play :#{@data[1]}"
      end
    end

    def sp_letter_print()
      # TODO: what units does sonic pi use between notes?
      # answer: ts relative to beats per minute; fix once integrated
      if !@wild_ts
        puts "sleep #{@rel_ts/1000*2.0}"
        puts "play :#{note_letter()}"
      end
    end

    def sp_electric_print()
      if !@wild_ts
        s = Samples.new
        puts "sleep #{@rel_ts/1000}"
        puts "sample :#{s.electric(@data[1])}"
      end
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
      if !@wild_ts
        s = Samples.new
        pitch = data[1]
        reg_pitch = pitch - 48
        if (reg_pitch).between?(0,7) 
          puts "sleep #{@rel_ts/1000}"
          puts "sample :#{s.bass(reg_pitch)}"
        end
      end
    end

    def sp_drum_print()
      if !@wild_ts
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
end