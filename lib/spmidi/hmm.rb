module SPMidi
  class HMM
    attr_reader :states, :alphabet, :init_pr, :tran_pr, :emis_pr 
    def initialize(args)
      # args is a Hash
      @states = args[:states]
      @alphabet = args[:alphabet]
      @init_pr = args[:init_pr]
      @tran_pr = args[:tran_pr]
      @emis_pr = args[:emis_pr]
    end
  end
end