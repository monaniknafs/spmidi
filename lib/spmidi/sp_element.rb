module SPMidi
  class SPElement
    attr_accessor :ts, :rel_ts, :pitch

    def initialize(h)
      @ts = h[:ts]
      @rel_ts = h[:rel_ts]
      @pitch = h[:pitch]
    end

    def ==(el)
      return  @ts == el.ts && 
              @rel_ts == el.rel_ts && 
              @pitch == el.pitch
    end

    def sp_print
      puts "sleep #{@rel_ts}"
      puts "play #{pitch}"
    end

    def sp_string
      return "sleep #{@rel_ts}\nplay #{pitch}"
    end

    def lock_rel_ts(incr)
      # min_time_element in milliseconds
      # lock relative ts to structure
      r = @rel_ts % incr
      return @rel_ts - r + (r >= incr / 2.0 ? incr : 0)
    end       

    def sp_drum_print
      s = Samples.new
      reg_pitch = @pitch - 48
      if (reg_pitch).between?(0,17) 
        puts "sleep #{@rel_ts}"
        puts "sample :#{s.drum(reg_pitch)}"
      end
    end
  end
end