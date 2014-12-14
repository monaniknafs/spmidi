require_relative 'pattern'

module SPMidi
  class PatternInference
    attr_accessor :current, :placeholder

    def initialize()
      @current = Pattern.new # current pattern
      @placeholder = 0 # @placeholder is an index into pattern
      @index = 1 #TODO: remove me once module is working
    end

    def find_pattern_size(note)
      # TODO use confidence field in pattern to determine whether this method needs to run or not
      #      but should be ran on every note, to account for new notes being added  
      puts "pass number #{@index}"
      puts "note: #{p note.data}"
      puts "placeholder: #{placeholder}"

      if @current.confidence == 0 # have not yet confirmed a pattern  
        occurs = @current.occurs?(note, 0) # this may equal nil  
        if occurs
          @current.confirm
          puts "confirmed" #TODO remove
        else
          @current.add(note)
        end
      else # have already confirmed a pattern
        # TODO make simpler logic here
        # TODO appropriately update placeholder
        @placeholder = @placeholder % @current.length
        occurs = @current.occurs?(note, @placeholder) # this may equal nil
        if occurs
          puts "yep, that follows the pattern" #TODO remove
          if @placeholder+1 == @current.length
            @current.confirm
          end

        else 
          puts "doesn't follow the pattern"
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
      current.print
      @index += 1
    end
  end
end