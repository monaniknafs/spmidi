require_relative 'hmm'

module SPMidi
  class Viterbi
    attr_reader :obs_seq # array of notes, in order
    attr_reader :hmm
    attr_reader :path

    def initialize(obs, hmm)
      @obs_seq = obs
      @hmm = hmm
      @path = Hash.new
    end

    def viterbi
      v = []
      v << {} # array of Hashes, representing states at each t=0,..,T
      p = []
      p << {}
      t = 0

      # first pass
      obs_seq.each do |obs|
        if t == 0
          @hmm.init_pr.each do |el, pr|
            v[t][el] = pr * @hmm.emis_pr[el][obs_seq[t]]
            v[t][el] = nil # no back pointers; first element
          end
        else
          # next passes
          @hmm.emis_pr.each do |i, destns|
            note = obs_seq[t]
            array = Array.new
            array << Hash.new
            v[t-1].each do |j|
              # j is prev element
              array << {j => v[t-1][j] * trans_pr[j][i] * emis_pr[i][note]} # might not work with the hash indexing of Notes, PatternElements, i've changed it now, should work
            end
            # set probability to max
            # TODO: assign pointers using indices
            # ASSERT that each element of array is a one element hash
            ## i want this so i can easily sort them
            v[t][el] = array.sort!{|x,y| x.values[0] <=> y.values[0]}.last.values[0]
            p[t][el] = array.last.keys[0]
          end
        end
        t+=1
      end
    end
  end
end
