require_relative 'note'
require_relative 'pattern_element'

module SPMidi
  class Skeleton
    attr_reader :joints 

    def initialize
      @joints = {}
    end

    def merge(root, destn, trans=false)
      # form {pe => {pe1 => pr1, .., pen => prn}}

      # will need to search through all the joints for matching root
      merged_root = false
      @joints.each do |rt, dns|
        if rt.eql?(root) # so elements aren't in distbn twice
          merged_root = true
          # merge into joints
          # DESIGN DECISION: do worry about repeat p_elements
          # TODO ^^
          if trans == true
            merged_trans = false
            dns.each do |d, pr|
              if d==destn
                merged_trans = true
              end 
            end
            if !merged_trans
              dns[destn] = 0.0
            end
          else
            dns[destn] = 0.0
          end
        end
      end
      if !merged_root
        @joints[root] = {destn => 0.0}
      end
    end
  end
end