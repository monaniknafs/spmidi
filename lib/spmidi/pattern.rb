require_relative 'pattern_element'

module SPMidi
  class Pattern
    attr_accessor :elements, :confidence
    def initialize(elements = [])
      @elements = [] # contains elements in pattern in order of occurrence
      elements.each do |el|
        @elements << el
      end
      @confidence = 0 # the number of times the pattern has been seen
    end

    def ==(pattern)
      return @elements == pattern.elements
    end

    def add(element)
      @elements << element
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
        puts e.mean_ts
      end
    end

    def occurs?(element, index)
      # if element is in @elements
        # return true
      # else returns false
      # method isn't used at the momento
      if index > @elements.length-1
        return false
      end
      return element == elements[index]
    end

    def occurs_after?(element,index) 
      # if element occurs from point index onwards
        # return index of first occurrence
      # nil returned if false or invalid
      if index > @elements.length-1
        return nil
      end
      for i in index..@elements.length-1
        if @elements[i] == element
            return i
        end
      end
      return nil
    end
  end
end