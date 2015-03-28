module SPMidi
  class PatternElement
    attr_reader :data, :timestamps, :mean_ts, :sd, :n, :th, :wild_pitch

    def initialize(*args)
      if args.size == 2
        @data = args[0]
        @mean_ts = args[1]
      elsif args.size == 1
        @data = args[0].data
        @mean_ts = args[0].rel_ts
      else
        puts 'error: pattern element initialize takes 1 or 2 arguments'
        return
      end
      @timestamps = [@mean_ts]
      @wild_pitch = !@data ? true : false

      # test whether we have wildcard pitch
      @n = 1 # number of (rel) timestamp elements deemed equal
      @sd = 44 + 0.0447*(@mean_ts - 637)
      @th = 2.0 # num of standard deviations around mean_ts tolerated for equality of ts
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
      # rel tstamps are normally distributed
      # DECISION: underlying timestamps are in MIDI units
      # sonic pi units can come into play in the higher level
      if (element.mean_ts >= @mean_ts - @th*@sd && element.mean_ts <= @mean_ts + @th*@sd)
        # element is defined equal when within one standard deviatation
        # TODO: revise this assumption, by looking at distributions of sample data sets
        prev_mean_ts = @mean_ts
        @n += 1
        @timestamps << element.mean_ts
        # equation from mmethods supervision exercises
        @mean_ts = prev_mean_ts + (element.mean_ts - prev_mean_ts)/@n # is this a risky subtraction to be doing?
        # using line of regression, approx new standard deviation:
        @sd = 44 + 0.0447*(@mean_ts - 637)
        return true
      else
        return false
      end 
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
        puts "data: *, rel ts: #{mean_ts}"
      else
        puts "data: #{data}, rel ts: #{mean_ts}"
      end
    end
  end
end