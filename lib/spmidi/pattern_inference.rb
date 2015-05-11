# leave comments displaying functionality until after documented
require_relative 'pattern'

module SPMidi
  class PatternInference
    attr_accessor :current, :ph, :backlog, :matched, :prev, :best

    def initialize()
      @prev = [] # array of prev patterns
      @current = Pattern.new # current pattern
      @ph = 0 # @ph is an index into pattern
      @backlog = [] # array of past seen elements
      @matched = [] # array of elements matched so far
      @best = nil
    end

    def best_pattern
      best = Pattern.new
      prev.each do |p|
        if p.confidence > best.confidence
          best = p
        end
      end
      if best.confidence >= 2
        puts "all patterns and their confidences:"
        @prev.each do |pat|
          pat.print
          puts "with confidence: #{pat.confidence}\n"
        end
        @best = best
        return best
      else
        puts "No pattern detected, please re-record desired pattern sequence"
        return
      end
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
      # check if we have a substring match of current
      substring = []
      mlen = elements.length
      clen = @current.elements.length
      for i in 0..mlen-1
        for j in 0..clen-1
          m = elements[i,mlen]
          mlen = m.length
          c = @current.elements[j,mlen]
          if m == c
            substring = @current.elements[j,clen].dup
            @matched = elements
            @ph = mlen-1
            return substring
          end
        end
      end
      return substring
    end

    def find_pattern(element)
      save(element) # put element in backlog list

      if @current.confidence == 0 
        occurs = @current.occurs_after?(element,0) # occurrence in pattern
        if occurs != nil
          @current.trim_before(occurs)
          match(element)
          @current.confirm
          prev_add(@current)
        else
          @current.add(element)
        end
      else # have already confirmed pattern
        occurs = @current.occurs_after?(element, @ph)
        if occurs == @ph
          match(element)
          if @ph+1 == @current.elements.length
            @current.confirm
            prev_add(@current)
          end
        else
          if occurs != nil
            new_current = backlog_match(@matched.dup << element) 
            @current = Pattern.new(new_current.dup)
            @current.confirm()
            prev_add(@current)
          else
            restore()
          end
        end
      end
      inc_ph()
    end # def find_pattern

    def permute(hmm)
      if @best == nil
        best_pattern()
      end
      i = 0
      best_index = nil
      best_pr = 0.0
      @best.elements.each do |el|
        hmm.init_pr.each do |pe, pr|
          if el.eql?(pe)
            if pr > best_pr
              best_index = i
              best_pr = pr
            end
          end
        end
        i += 1
      end

      len = @best.elements.length
      if best_index != nil
        for i in 0..best_index-1
          top = @best.elements.first
          @best.elements = @best.elements.last(len-1) << top
        end
      end
    end
  end # class pattern_inference
end # module SPMidi