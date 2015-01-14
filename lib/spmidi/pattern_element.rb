module SPMidi
  class PatternElement
    attr_accessor :data, :rel_ts

    def initialize(*args)
      if args.size == 2
        @data = args[0]
        @rel_ts = args[1]
      elsif args.size == 1
        @data = args[0].data
        @rel_ts = args[0].rel_ts
      else
        puts 'error: pattern element initialize takes 1 or 2 arguments'
      end
    end

    # def initialize(note)
    #   @data = note.data
    #   @rel_ts = note.rel_ts
    # end

    # def initialize(data, rel_ts)
    #   @data = data
    #   @rel_ts = rel_ts
    # end
    
    def ==(element)
      if element.data[1] != @data[1]
        return false
      end
      # rel tstamps are normally distributed
      # assume @rel_ts is equal to its mean
      # following, its approx standard deviation:
      sd = 44 + 0.0447*(@rel_ts - 637)
      if (element.rel_ts >= @rel_ts - sd && element.rel_ts <= @rel_ts + sd)
        return true
      else
        return false
      end 
    end
  end
end