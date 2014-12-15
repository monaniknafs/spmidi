module SPMidi
  class Pattern
    attr_accessor :notes, :length, :confidence

    # TODO: not good design practice to have ts field in notes where it doesn't apply
    # TODO: perhaps make a pattern element? which has an adjustable threshhold field in it etc? 
    def initialize(notes = [])
      @notes = notes # array containing notes in pattern in order of occurrence
      @length = notes.length # length of note array
      @confidence = 0 # the number of times the pattern has been seen
    end

    def add(note)
      @notes << note
      @length += 1
    end

    def confirm()
      @confidence += 1
    end

    def print()
      notes.each do |note|
        p note.data
        puts note.rel_ts
      end
    end

    def occurs?(note, index)
      # if note is in notes, returns index of first occurrence
      # else returns nil
      # TODO: make this work with confidence interval
      #       as it won't work as it stands
      #       by definition no two notes are the same
      if index > @length-1
        return nil
      end
      if @notes[index].data == note.data #TODO make a method for checking PITCH is equal WITHIN REASON
        if @notes[index].rel_ts == note.rel_ts #TODO likewise for checking TIMESTAMPS are equal WITHIN REASON
          return true
        end
      end
      return false
    end

    def occurs_after?(note,index)
      # return true if note occurs from point index onwards
      # nil returned if false or invalid
      if index > @length-1
        return nil
      end
      for i in index..@length-1
        if @notes[i].data == note.data
          if @notes[i].rel_ts == note.rel_ts
            return i
          end
        end
      end
      return nil
    end
  end
end