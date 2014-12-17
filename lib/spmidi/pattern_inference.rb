# leave comments displaying functionality until after documented
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
      @matched.each {|x| p x.data} # remove
      @current = Pattern.new(@backlog)
      @ph = @current.length-1
      @matched = []
    end

    def save(note)
      @backlog << note
    end

    def match(note)
      @matched << note
    end

    def backlog_match(notes)
      # naive string matching
      substring = []
      mlen = notes.length
      clen = @current.notes.length
      for i in 0..mlen-1
        for j in 0..clen-1
          m = notes[i,mlen]
          mlen = m.length
          c = @current.notes[j,mlen]
          if m == c
            puts "i-index for matched = #{i}" # remove
            puts "j-index for matched = #{j}" # remove
            substring = @current.notes[j,clen].dup
            @matched = notes
            @ph = mlen-1
            return substring
          end
        end
      end
      return substring
    end

    def find_pattern_size(note)
      puts "pass number #{@index}" # remove
      puts "note: #{note.data}" # remove
      puts "placeholder: #{ph}" # remove

      save(note) # put note in backlog list

      if @current.confidence == 0 
        occurs = @current.occurs_after?(note,0) # occurrence in pattern
        if occurs != nil
          @current.trim_before(occurs)
          puts note.class
          match(note)
          @current.confirm
          puts "confirmed" # remove
        else
          @current.add(note)
        end
      else # have already confirmed pattern
        occurs = @current.occurs_after?(note, @ph)
        if occurs == @ph
          puts "follows pattern" #remove
          match(note)
          if @ph+1 == @current.length
            @current.confirm
          end
        else
          if occurs != nil
            (@matched).each {|x| p x.data} # remove
            new_current = backlog_match(@matched.dup << note) 
            puts ""
            (@matched.dup << note).each {|x| p x.data} # remove
            puts "follows pattern subset" # remove
            (@backlog).each {|x| p x.data} # remove
            puts "" # remove
            puts ""
            @current = Pattern.new(new_current.dup)
            @current.confirm()
            (@matched).each {|x| p x.data} # remove
            if @current.notes.length == 0
              puts "empty current pattern"
            end
          else
            puts "doesn't follow pattern" # remove
            restore()
          end
        end
      end
      puts "current array:" # remove
      @current.print # remove
      puts "" # remove
      inc_ph()
      puts "current confidence: #{@current.confidence}" # remove
    end
  end
end