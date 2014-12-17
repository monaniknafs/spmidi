module SPMidi
  class Pattern
    attr_accessor :notes, :length, :confidence

    def initialize(notes = [])
      @notes = notes # array containing notes in pattern in order of occurrence
      @length = notes.length # length of note array
      @confidence = 0 # the number of times the pattern has been seen
    end

    def add(note)
      @notes << note
      @length += 1
    end

    def trim_before(start)
      @notes = @notes[start..@length-1]
      @length = @notes.length
    end
    
    def confirm()
      @confidence += 1
    end

    def print()
      @notes.each do |note|
        p note.data
        puts note.rel_ts
      end
    end

    def occurs?(note, index)
      # if note is in @notes, return true
      # else returns false
      # method isn't used at the mo
      if index > @length-1
        return false
      end
      if @notes[index].data == note.data #TODO make a method for checking PITCH is equal WITHIN REASON
        if @notes[index].rel_ts == note.rel_ts #TODO likewise for checking TIMESTAMPS and RELATIVE TIMESTAMPS are equal WITHIN REASON
          return true
        end
      end
      return false
    end

    def occurs_after?(note,index)
      # return index of first occurrence if note occurs from point index onwards
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