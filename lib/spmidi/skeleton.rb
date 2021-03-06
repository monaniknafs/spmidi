require_relative 'note'
require_relative 'pattern_element'

module SPMidi
  class Skeleton
    attr_reader :joints 
    attr_reader :trans
    attr_reader :x

    def initialize(trans)
      # joints in form:
      # {root1 => {destn1=>p1,..,destnm=>pm},..}
      @joints = {}
      @trans = trans
      @x = nil
    end

    def merge(root, destn, nested_destn)
      # form {pe => {pe1 => pr1, .., pen => prn}}

      # will need to search through all the joints for matching root
      merged_root = false
      @joints.each do |rt, dns|
          # merge into joints
        if @trans == true
          if rt==root
            merged_root = true
            merged_trans = false
            dns.each do |d, nd| # nd stands for nested destination
              if d==destn
                merged_trans = true
              end 
            end
            if !merged_trans
              dns[destn] = nested_destn
            end
          end
        else
          if rt==(root) # to produce representative mean_ts
            merged_root = true
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

    def get_nested_destn(root, destn)
      tport_pr = 0.0
      @joints.each do |rt, dns|
        if rt.eql?(root)
          dns.each do |d, nd| # nd stands for nested destination
            if d.eql?(destn)
              return nd
            end
          end
          if !trans
            tport_pr = 0.75 / dns.size
            puts "dns.size = #{dns.size}"
            puts "tport probability = #{tport_pr}"
          end
        end
      end
      return tport_pr
    end

    def set_nested_destn(root, destn, value)
      # ASSERT: root => {destn => __} not present in joints
      @joints[root] = {destn => value}
    end
  end
end