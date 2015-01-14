require_relative 'pattern_element'

module SPMidi
  class Pattern
    attr_accessor :elements, :length, :confidence
    # test intialization with note for pattern element
    def initialize(notes = [])
      @elements = [] # contains elements in pattern in order of occurrence
      notes.each do |note|
        e = PatternElement.new(note)
        @elements << e
      end
      @length = @elements.length # length of note array
      @confidence = 0 # the number of times the pattern has been seen
    end

    def add(note)
      @elements << PatternElement.new(note)
      @length += 1
    end

    def trim_before(start)
      @elements = @elements[start..@length-1]
      @length = @elements.length
    end
    
    def confirm()
      @confidence += 1
    end

    def print()
      @elements.each do |e|
        p e.data
        puts e.rel_ts
      end
    end

    def occurs?(note, index)
      # if pattern_element(note) is in @elements
        # return true
      # else returns false
      # method isn't used at the momento
      if index > @length-1
        return false
      end
      e = PatternElement.new(note)
      return e == elements[index]
    end

    def occurs_after?(note,index) 
      # if note occurs from point index onwards
        # return index of first occurrence
      # nil returned if false or invalid
      if index > @length-1
        return nil
      end
      e = PatternElement.new(note)
      for i in index..@length-1
        if @elements[i] == e
            return i
        end
      end
      return nil
    end
  end
end