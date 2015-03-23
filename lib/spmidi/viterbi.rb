# TODO: make methods more readable
# TODO: take logs of probabilities, I choose log10 since log10(1.0) = -1.0
# all  probability values in viterbi matrix are log10 probabilities
require_relative 'hmm'

module SPMidi
  class Viterbi
    attr_reader :obs_seq # array of notes, in order
    attr_reader :hmm
    attr_reader :path
    attr_reader :processed

    def initialize(obs, hmm)
      @obs_seq = obs # note array
      @path_size = obs.size
      @viterbi = Array.new(@path_size) {Hash.new}
      @viterbi.each do |v|  
        v = []
      end
      @hmm = hmm
      @path = Array.new(@path_size) # [{element => prob}, .., ]
      @processed = false
    end

    def run
      # v contains results of each iteration of viterbi
      # [{l=>[k,pr],..,l=>[k,pr]},..,{l=>[k,pr],..,l=>[k,pr]}]
      t = 0
      # first pass
      obs_seq.each do |obs|
        if t == 0
          @hmm.init_pr.each do |el, prob|
            # first element so nil backpointer
            pr = Math.log10(prob)
            tr = Math.log10(@hmm.emis_pr.get_nested_destn(el, obs))
            @viterbi[t][el] = [nil, pr + tr]
          end
        else # t != 0
          @hmm.states.each do |state|
            probs = [] # array of log10_probabilities => elements

            @viterbi[t-1].each do |el, prev|
              pr = prev[1] # already a log10 term
              tr = Math.log10(@hmm.trans_pr.get_nested_destn(el, state))
              probs << {pr + tr => el}
            end
            probs.sort!{|x,y| x.keys[0] <=> y.keys[0]}
            em = Math.log10(@hmm.emis_pr.get_nested_destn(state, obs))
            max_pr = probs.last.keys[0] + em
            max_state = probs.last.values[0] # corresponding state
            @viterbi[t][state] = [max_state, max_pr]
          end
        end
        t+=1
      end
    end

    def find_path
      puts ""
      t = @viterbi.size-1 # go backwards through the elements
      # note t is used as an index here
      prev_state = nil
      prev_pr = nil
      
      @viterbi.reverse_each do |v|
        # first find max prT
        if t == @viterbi.size-1
          max_pr = Math.log10(0.0)
          max_state = nil

          v.each do |k, el_pr|
            state = k
            prev = el_pr[0]
            pr = el_pr[1]
            if pr > max_pr
              max_pr = pr
              max_state = state 
              prev_state = prev
              prev_pr = pr
            end
          end
          @path[t] = {max_state => max_pr}

        # then backtrack through list
        # using prev_state
        else
          corresponding_state = nil
          max_prev_state = nil
          max_prev_pr = Math.log10(0.0)
          v.each do |k, el_pr|
            #initialise max x2
            state = k
            prev = el_pr[0]
            pr = el_pr[1]
            if state.eql?(prev_state)
              if pr > max_prev_pr
                corresponding_state = state
                max_prev_state = prev
                max_prev_pr = pr
              end
            end
          end
          prev_state = max_prev_state
          @path[t] = {corresponding_state => max_prev_pr}
        end
        t-=1
      end
      @processed = true
    end

    def print_path
      if !@processed
        puts "viterbi algorithm hasn't run yet, run it"
        return
      else
        puts "\n~~final path~~"
        @path.each do |p|
          el = p.keys[0]
          pr = p.values[0]
          if el != nil 
            el.print
          end
          s = "%0.3f" % pr
          print "probability = #{s}\n"
        end
      end
    end

    def print_viterbi
      t = 0
      @viterbi.each do |v|
        puts ""
        puts "t=#{t}"
        v.each do |state, k_pr|
          k = k_pr[0]
          pr = k_pr[1]
          if k != nil
            puts "#{state.data} <= #{k.data}, #{pr}"
          else
            puts "#{state.data} <= nil, #{pr}"
          end
        end
        t+=1
      end
    end
  end
end