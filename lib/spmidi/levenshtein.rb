# please note: only use eql? method when comparing PatternElements
module SPMidi
  class Levenshtein
    attr_accessor :distance

    def initialize(min_ts_unit)
      @distance = nil
      @inc = min_ts_unit
      @c_del = 1
      @c_ins = 1
      @c_sub_p = 1 # pitch cost
      # c_sub_ts is a function
    end

    def c_sub_ts(a,b)
      distance = (a.rel_ts - b.rel_ts).abs
      # cost function
      return (distance / @inc).floor
    end

    def c_sub_p(a,b)
      return a.pitch == b.pitch ? 0 : 1 
    end

    def distance(b, a)
      # ASSERT: b is inferred
      # ASSERT: a is actual
      # b and a are arrays of SPElements
      matrix = [(0..b.length).to_a]
      (1..a.length).each do |j|
        matrix << [j] + [0] * (b.length)
      end
     
      (1..a.length).each do |i|
        (1..b.length).each do |j|
          if b[j-1]==a[i-1]
            matrix[i][j] = matrix[i-1][j-1]
          else
            matrix[i][j] = [
              matrix[i-1][j] + @c_del,
              matrix[i][j-1] + @c_ins,
              matrix[i-1][j-1] + c_sub_p(b[i-1], a[i-1]) + c_sub_ts(b[i-1], a[i-1]),
            ].min
          end
        end
      end
      @distance = matrix.last.last
      return matrix.last.last
    end
  end
end