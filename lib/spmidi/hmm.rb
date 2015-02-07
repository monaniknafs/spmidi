require 'set'
require_relative 'pattern_element'

module SPMidi
  class HMM
    attr_reader :states
    attr_reader :alphabet
    attr_reader :init_pr
    attr_reader :trans_pr
    attr_reader :emis_pr
    attr_reader :trans
    attr_reader :emis
    attr_reader :cur_root

    def initialize
      @cur_root = nil
      @alphabet = []
      @states = []
      @emis = Hash.new
      @trans = Hash.new
      @emis_pr = Hash.new
      @trans_pr = Hash.new
      @init_pr = Hash.new
    end

    def add(note)
      @alphabet << note

      # i want everything referencing the same thing
      element = PatternElement.new(note)
      merged_cur = false
      merged_nxt = false

      if @cur_root == nil
        # first call to add
        @states << element
        @emis[element] = []
        @trans[element] = []
        @cur_root = element
      else
        root = @cur_root.dup
        # add to emis Hash
        @emis.each do |rt, dn|
          if rt == root
            merged_cur = true
            merged_trns = false
            # merge into emis, trans
            @emis[rt] << note
            @trans[rt].each do |el|
              if el == element
                merged_trns = true
              end
            end
            if !merged_trns
              @trans[rt] << element
            end
          end
          if rt == element
            merged_nxt = true
          end
        end
        if !merged_cur
          @states << root
          @emis[root] = note
          @trans[root] = element
        end
        if !merged_nxt
          @states << element
          @emis[element] = []
          @trans[element] = []
        end
        # prepare for next call
        @cur_root = element
      end
    end

    def process
      # initialise emission probabilities
      @emis.each do |root, notes|
        if !@emis_pr.has_key?(root)
          @emis_pr[root] = {}
        end
        total = notes.size
        pr = 1.0/total
        notes.each do |n|
          pr = 1.0/total
          @emis_pr[root] = @emis_pr[root].merge({n => pr})
        end
      end
      # initialise transition probabilities
      @trans.each do |root, elements|
        if !@trans_pr.has_key?(root)
          @trans_pr[root] = {}
        end
        total = 0
        elements.each do |el|
          total += el.n
        end
        elements.each do |el|
          pr = Float(el.n)/total
          @trans_pr[root] = @trans_pr[root].merge({el => pr})
        end
      end
      # initialise initial probabilities
      total = @trans.size
      @trans.each do |root, elements|
        @init_pr[root] = 1.0/total
      end
    end
  end
end