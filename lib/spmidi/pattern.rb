require_relative 'pattern_element'

module SPMidi
  class Pattern
    attr_accessor :elements, :confidence
    # test intialization with note for pattern element
    def initialize(notes = [])
      @elements = [] # contains elements in pattern in order of occurrence
      notes.each do |note|
        e = PatternElement.new(note)
        @elements << e
      end
      @confidence = 0 # the number of times the pattern has been seen
    end

    def ==(pattern)
      return @elements == pattern.elements
    end

    def add(note)
      @elements << PatternElement.new(note)
    end

    def trim_before(start)
      @elements = @elements[start..@elements.length-1]
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
      if index > @elements.length-1
        return false
      end
      e = PatternElement.new(note)
      return e == elements[index]
    end

    def occurs_after?(note,index) 
      # if note occurs from point index onwards
        # return index of first occurrence
      # nil returned if false or invalid
      if index > @elements.length-1
        return nil
      end
      e = PatternElement.new(note)
      for i in index..@elements.length-1
        if @elements[i] == e
            return i
        end
      end
      return nil
    end
  end
end