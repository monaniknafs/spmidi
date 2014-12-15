require_relative 'pattern'

module SPMidi
  class PatternInference
    attr_accessor :current, :ph, :backlog, :matched

    def initialize()
      @current = Pattern.new # current pattern
      @ph = 0 # @ph is an index into pattern
      @backlog = [] # array of past seen notes
      @matched = []# array of notes matched so far
    end

    def inc_ph()
      if @current.confidence == 0
        @ph += 1
      else
        @ph += 1
        @ph = @ph % @current.notes.length
      end
    end

    def restore()
      if @matched != []
        curr = @current.notes
        puts "confidence is #{@current.confidence}"
        (@matched).each {|x| p x.data} # remove
        @current = Pattern.new(@matched)
        @matched = @current.notes
        @ph = @current.length-1
      else
        @current = Pattern.new(@backlog)
        @ph = @current.length-1
      end
    end

    def save(note)
      @backlog << note
    end

    def match(note)
      @matched << note
    end

    def backlog_match?(notes)
      # naive string matching
      substring = []
      start = 0
      mlen = notes.length
      for i in 0..mlen-1
        for j in start..@backlog.length-1
          m = notes[i,mlen]
          b = @backlog[j,mlen]
          if m == b
            substring = m
            return substring
          end
        end
      end
      puts "substring: #{substring.each {|x| x.print}}"
      return substring
    end

    #TODO change all occurrences of @placeholder to @ph
    def find_pattern_size(note)
      puts "pass number #{@index}"
      puts "note: #{note.data}"
      puts "placeholder: #{ph}"

      save(note) # put note in backlog list

      if @current.confidence == 0 
        occurs = @current.occurs_after?(note,0) # occurrence in pattern
        if occurs != nil
          @current.trim_before(occurs)
          @current.confirm
          puts note.class
          match(note)
          puts "confirmed"
        else
          @current.add(note)
        end
      else # have already confirmed pattern
        occurs = @current.occurs_after?(note, @ph)
        if occurs == @ph
          puts "follows pattern"
          match(note)
          if @ph+1 == @current.length
            @current.confirm
          end
        else
          new_current = backlog_match?(@matched << note) 
          if occurs != nil
            puts "follows pattern subset"
            (@backlog).each {|x| p x.data} # remove
            puts "" # remove
            (@matched).each {|x| p x.data} # remove
            @current = Pattern.new(new_current)
            @matched = new_current
            (@matched).each {|x| p x.data} # remove
          else
            puts "doesn't follow pattern"
            restore()
          end
        end
      end
      puts "current array:"
      @current.print
      puts ""
      inc_ph()
      puts "current confidence: #{@current.confidence}"
    end
  end
end