require_relative 'pattern'

module SPMidi
  class PatternInference
    attr_accessor :current, :placeholder

    def initialize()
      @current = Pattern.new # current pattern
      @placeholder = 0 # @placeholder is an index into pattern
      @index = 1 #TODO: remove me once module is working
    end

    def inc_placeholder()
      if @current.confidence == 0
        @placeholder += 1
      else
        @placeholder += 1
        @placeholder = @placeholder % @current.notes.length
      end
    end

    def find_pattern_size(note)
      puts "pass number #{@index}"
      puts "note: #{note.data}"
      puts "placeholder: #{placeholder}"

      if @current.confidence == 0 # have not yet confirmed a pattern  
        occurs_index = @current.occurs_after?(note, 0) # this may equal nil  
        if occurs_index != nil
          #@current.notes = @current.notes[occurs_index..@current.length-1]
          @current.confirm
          puts "confirmed" #TODO remove
        else
          @current.add(note)
        end
      else # have already confirmed a pattern
        occurs_index = @current.occurs_after?(note, @placeholder) # this may equal nil
        if occurs_index == @placeholder
          puts "yep, that follows the pattern" #TODO remove
          if @placeholder+1 == @current.length
            @current.confirm
          end
        else 
          if occurs_index != nil
            puts "follows pattern, but a subset of"
            @current.notes = @current.notes[placeholder..@current.length-1]
            @current.length = @current.notes.length
          else
            puts "doesn't follow the pattern"
            revised = [] # revised pattern
            current_notes = @current.notes << @current.notes.last
            for i in 0..@current.confidence-1
              revised.concat(current_notes)
            end
            revised << note
            # start fresh
            @current = Pattern.new(revised)
            @placeholder = @current.length - 1
          end
        end
      end
      puts "current array:"
      current.print
      puts ""
      inc_placeholder()
      @index += 1
    end
  end
end