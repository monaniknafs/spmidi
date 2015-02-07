require_relative 'note'
require_relative 'pattern_element'

module SPMidi
  class Skeleton
    attr_reader :joints, :processed # data structure? array? hash?

    def initialize
      @joints = ##
      # whether probabilities have been added
      @processed = false 
    end

    def merge(joint)
      # joint is Hash  
      # form {pe => {pe1 => pr1, .., pen => prn}}
    end

    def process
      # at end
      @processed = true
    end

    def transition(root, destn)

    end
  end
end