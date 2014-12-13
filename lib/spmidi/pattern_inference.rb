require_relative 'pattern'

module SPMidi
  class PatternInference
    attr_accessor :current, :placeholder

    def initialize()
      @current = Pattern.new # current pattern
      @placeholder = 0 # @placeholder is an index into pattern
    end

    def find_pattern_size(note)
      # TODO use confidence field in pattern to determine whether this method needs to run or not
      #      but should be ran on every note, to account for new notes being added  
      first = @current.first_occurrence(note) # this may equal nil
      if @current.confidence == 0 # have not yet confirmed a pattern
        puts first
        if first == nil # have not seen note in current pattern
          @current.add(note)
        else
          @current.confirm
        end
      else # have already confirmed a pattern
        # TODO make simpler logic here
        if first == @placeholder % @current.length
          if @placeholder+1 == @current.length
            @current.confirm
          end
        else 
          # either first is nil or we have integer inequality
          # but either way we are in the subsequence case
          # (where greedy algorithms would otherwise fail)
          revised = [] # revised pattern
          current_notes = @current.notes
          for i in 0..@current.confidence-1
            revised.concat(current_notes)
          end
          revised << note
          # start fresh
          @current = Pattern.new(revised)
        end
      end
      @placeholder += 1
    end

  end
end