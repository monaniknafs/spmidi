require_relative 'note'
require_relative 'pattern_element'

module SPMidi
  class Skeleton
    attr_reader :joints 

    def initialize
      @joints = {}
    end

    def merge(root, destn, nested_destn, trans=false)
      # form {pe => {pe1 => pr1, .., pen => prn}}

      # will need to search through all the joints for matching root
      merged_root = false
      @joints.each do |rt, dns|
        if rt.eql?(root) # so elements aren't in distbn twice
          merged_root = true
          # merge into joints
          if trans == true
            merged_trans = false
            dns.each do |d, nd| # nd stands for nested destination
              if d==destn
                merged_trans = true
              end 
            end
            if !merged_trans
              dns[destn] = nested_destn
            end
          else
            dns[destn] = nested_destn
          end
        end
      end
      if !merged_root
        @joints[root] = {destn => nested_destn}
      end
    end

    # used for viterbi
    # so doesn't need merging atm

    def get_inner_destn(root, destn)
      @joints.each do |rt, dns|
        if rt.eql?(root)
          dns.each do |d, nd| # nd stands for nested destination
            if d.eql?(destn)
              return nd
            end
          end
        end
      end
    end

    def set_inner_destn(root, destn, value)
      # ASSERT: root => {destn => __} not present in joints
      @joints[rt][destn] = value
    end
  end
end