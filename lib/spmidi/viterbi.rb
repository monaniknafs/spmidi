# TODO: remove all array-like accesses on skeleton instances
require_relative 'hmm'
require_relative 'skeleton'

module SPMidi
  class Viterbi
    attr_reader :obs_seq # array of notes, in order
    attr_reader :hmm
    attr_reader :path
    attr_reader :processed

    def initialize(obs, hmm)
      @obs_seq = obs # should be an array or time => element Hash as it stands
      @path_size = obs.size
      @hmm = hmm
      @path = Skeleton.new # 0 => {element => prob}, .., 
      @processed = false
    end

    def viterbi
      v = Skeleton.new # nested_destn is a probability
      # p contains back pointers, to retrace steps
      p = Skeleton.new # nested_destn is a pattern element
      t = 0

      # first pass
      obs_seq.each do |obs|
        if t == 0
          # REVISE
          @hmm.init_pr.each do |el, pr|
            v.set_nested_destn(t, el, pr * @hmm.emis_pr.get_nested_destn(el, obs))
            p.set_nested_destn(t, el, nil) # no back pointers; first element
          end
        else # t != 0
          @hmm.states.each do |state|
            probabilities = []
            pointers = []
            pointers = {} # one element Hash
            v.joints[t-1].each do |el, pr|
              delta_prev = pr
              a_ji = @hmm.trans_pr.get_nested_destn(el, state)
              b_ik = @hmm.emis_pr.get_nested_destn(state, obs)
              probabilities << delta_prev * a_ji * b_ik
              pointers << {el => delta_prev * a_ji}
            end
            max_pr = probabilities.sort!{|x,y| x <=> y}.last
            max_el = pointers.sort!{|x,y| x.values[0] <=> y.values[0]}.last.keys[0]
            v.set_nested_destn(t, state, max_pr)
            p.set_nested_destn(t, state, max_el)
          end
        end
        t+=1
      end

      # TODO: make sure this does what i want
      for i in @path_size-1..0
        @path[i] = {p.joints[i+1].sort!.last => v.joints[i].sort!.last}
      end
    end

    def print_path
      if !@processed
        puts "viterbi algorithm hasn't run yet, run it"
        return
      end
    end
  end
end