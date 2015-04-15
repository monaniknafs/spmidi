# leave comments displaying functionality until after documented
require_relative 'pattern'

module SPMidi
  class PatternInference
    attr_accessor :current, :ph, :backlog, :matched, :prev

    def initialize()
      @prev = [] # array of prev patterns
      @current = Pattern.new # current pattern
      @ph = 0 # @ph is an index into pattern
      @backlog = [] # array of past seen elements
      @matched = [] # array of elements matched so far
    end

    def inc_ph()
      if @current.confidence == 0
        @ph += 1
      else
        @ph += 1
        @ph = @ph % @current.elements.length
      end
    end

    def restore()
      # @matched.each {|x| p x.data} # remove
      @current = Pattern.new(@backlog)
      @ph = @current.elements.length-1
      @matched = []
    end

    def save(element)
      @backlog << element
    end

    def prev_add(pattern)
      if @prev.include?(pattern)
        i = @prev.index(pattern)
        @prev[i].confirm()
      else
        @prev << pattern
      end
    end

    def match(element)
      @matched << element
    end

    def backlog_match(elements)
      # naive string matching
      substring = []
      mlen = elements.length
      clen = @current.elements.length
      for i in 0..mlen-1
        for j in 0..clen-1
          m = elements[i,mlen]
          mlen = m.length
          c = @current.elements[j,mlen]
          if m == c
            # puts "i-index for matched = #{i}" # remove
            # puts "j-index for matched = #{j}" # remove
            substring = @current.elements[j,clen].dup
            @matched = elements
            @ph = mlen-1
            return substring
          end
        end
      end
      return substring
    end

    # this should be called add(element)
    def find_pattern(element)
      # puts "pass number #{@index}" # remove
      # puts "element: #{element.data}" # remove
      # puts "placeholder: #{ph}" # remove

      save(element) # put element in backlog list

      if @current.confidence == 0 
        occurs = @current.occurs_after?(element,0) # occurrence in pattern
        if occurs != nil
          @current.trim_before(occurs)
          match(element)
          @current.confirm
          prev_add(@current)
          # puts "confirmed" # remove
        else
          @current.add(element)
        end
      else # have already confirmed pattern
        occurs = @current.occurs_after?(element, @ph)
        if occurs == @ph
          # puts "follows pattern" #remove
          match(element)
          if @ph+1 == @current.elements.length
            @current.confirm
            prev_add(@current)
          end
        else
          if occurs != nil
            # (@matched).each {|x| p x.data} # remove
            new_current = backlog_match(@matched.dup << element) 
            # puts "" # remove
            # (@matched.dup << element).each {|x| p x.data} # remove
            # puts "follows pattern subset" # remove
            # @backlog.each {|x| p x.data} # remove
            # puts "" # remove
            @current = Pattern.new(new_current.dup)
            @current.confirm()
            prev_add(@current)
            # (@matched).each {|x| p x.data} # remove
            # if @current.elements.length == 0 #remove
            #   puts "empty current pattern" #remove
            # end #remove
          else
            # puts "doesn't follow pattern" # remove
            restore()
          end
        end
      end
      # puts "current array:" # remove
      # @current.print # remove
      # puts "" # remove
      inc_ph()
      # puts "current confidence: #{@current.confidence}" # remove
    end # def find_pattern

    # def find_pattern_now(el_array)
    #   el_array.each do |el|
    #     find_pattern(el)
    #   end
    # end # def find_pattern_now

  end # class pattern_inference
end # module SPMidi