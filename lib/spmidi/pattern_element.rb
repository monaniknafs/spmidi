module SPMidi
  class PatternElement
    # TODO: remove :n it is unecessary since i have :timestamps.size
    attr_reader :data, :timestamps, :mean_ts, :sd, :n, :th, :wild_pitch, :sp_ts, :wild_ts

    def initialize(*args)
      if args.size == 2
        @data = args[0]
        @mean_ts = args[1]
      elsif args.size == 1
        @data = args[0].data
        if args[0].wild_ts 
          @mean_ts = false
        else
          @mean_ts = args[0].rel_ts
        end
      else
        puts 'error: pattern element initialize takes 1 or 2 arguments'
        return
      end

      @timestamps = nil
      @n = 1 # number of (rel) timestamp elements in distribution
      @th = 4.0 # num of standard deviations around mean_ts tolerated for equality of ts
      @sp_ts = nil

      @wild_pitch = !@data ? true : false # otherwise @data is integer
      @wild_ts = !@mean_ts ? true : false # otherwise @data is integer
      if !@wild_ts
        @sd = (44 + 0.0447*(@mean_ts - 637)).abs
        @timestamps = [@mean_ts]
      end
    end

    def ==(element)
      if element == nil
        return false
      end
      if @wild_pitch 
        puts "equality method == can't be used with wild pitch pattern elements"
        puts "can only be used with eql? method"
        return
      end

      if element.data[1] != @data[1]
        return false
      end

      if @wild_ts || element.wild_ts
        if !element.wild_ts
          @wild_ts = false
          prev_mean_ts = element.mean_ts
          @n += element.n
          @timestamps = element.timestamps 
          for i in (0..@n-2)
            puts "ts number #{i}"
            @timestamps << element.mean_ts
          end
          @mean_ts = prev_mean_ts + (element.mean_ts - prev_mean_ts)/@n
          @sd = 44 + 0.0447*(@mean_ts - 637)
        else
          @n += 1
        end
        return true
      end

      # underlying timestamps are in MIDI units
      if (element.mean_ts >= @mean_ts - @th*@sd && element.mean_ts <= @mean_ts + @th*@sd)
        prev_mean_ts = @mean_ts
        @n += 1
        @timestamps << element.mean_ts
        @mean_ts = prev_mean_ts + (element.mean_ts - prev_mean_ts)/@n
        # using line of regression, approx new standard deviation:
        @sd = 44 + 0.0447*(@mean_ts - 637)
        return true
      else
        return false
      end 
    end

    def set_mean_ts(new_ts)
      @mean_ts = new_ts
    end

    def eql?(element)
      # for use when don't want to add to distribution
      if element == nil
        return false
      end

      if !@wild_pitch && !element.wild_pitch
        if element.data[1] != @data[1]
          return false
        end
      end

      if @wild_ts || element.wild_ts
        return true
      end

      # rel tstamps are normally distributed,
      # using line of regression, approx standard deviation:
      if (element.mean_ts >= @mean_ts - @th*@sd && element.mean_ts <= @mean_ts + @th*@sd)
        # element is defined equal when within one standard deviatation
        return true
      else
        return false
      end 
    end

    def print
      if @wild_pitch
        if @wild_ts
          puts "data: *, rel ts: *"
        else
          puts "data: *, rel ts: #{mean_ts}"
        end
      else
        if @wild_ts
          puts "data: #{data}, rel ts: *"
        else
          puts "data: #{data}, rel ts: #{mean_ts}"
        end
      end
    end

    def lock_mean_ts(incr)
      # min_time_element in milliseconds
      # lock relative ts to structure
      if !@wild_ts
        r = @mean_ts % incr
        return @mean_ts - r + (r >= incr / 2.0 ? incr : 0)
      else
        puts "can't lock non-existent mean_ts"
        return
      end
    end  

    def sp_ts(incr)
      # min_time_element in milliseconds
      # lock relative ts to structure
      sp_ts = @mean_ts / 1000.0 * 2.7
      r = sp_ts % incr
      return sp_ts - r + (r >= incr / 2.0 ? incr : 0.0)
    end      

    def sp_drum_print
      s = Samples.new
      pitch = data[1]
      reg_pitch = pitch - 48
      if (reg_pitch).between?(0,17) 
        puts "sleep #{@mean_ts/500.0}"
        puts "sample :#{s.drum(reg_pitch)}"
      end
    end
  end
end