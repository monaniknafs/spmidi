# please note: only use eql? method when comparing PatternElements
module SPMidi
  class LevDistance
    attr_accessor :distance

    def initialize
      @distance = nil
    end

    def levenshtein(p1, p2)
      # ASSERT: p1 is inferred pattern
      # ASSERT: p2 is actual pattern
      # AND: p1 and p2 arrays of PatternElements
      matrix = [(0..p1.length).to_a]
      (1..p2.length).each do |j|
        matrix << [j] + [0] * (p1.length)
      end
     
      (1..p2.length).each do |i|
        (1..p1.length).each do |j|
          if p1[j-1].eql?(p2[i-1])
            matrix[i][j] = matrix[i-1][j-1]
          else
            matrix[i][j] = [
              matrix[i-1][j],
              matrix[i][j-1],
              matrix[i-1][j-1],
            ].min + 1
          end
        end
      end
      @distance = matrix.last.last
      return matrix.last.last
    end

    def percentage(p1,p2)
      if !@distance 
        # TODO
        # decide on appropriate notion for lev_percentage 
        # as not sure about current one
        # i could also do it as a proporation of the max of these sizes
        return levenshtein(p1,p2) / Float(p1.size+p2.size)
      end
      return @distance / Float(p1.size+p2.size)
    end
  end
end