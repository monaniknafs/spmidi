require 'set'
require_relative 'pattern_element'
require_relative 'skeleton'

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
    attr_reader :processed

    def initialize
      @cur_root = nil
      @alphabet = []
      @states = []
      @emis_pr = Skeleton.new
      @trans_pr = Skeleton.new
      @init_pr = Hash.new # TODO think of something logical for initial states
      @processed = false
    end

    def add(note)
      @alphabet << note

      # i want everything referencing the same thing
      element = PatternElement.new(note)

      if @cur_root == nil
        # first call to add
        @states << element
      else
        root = @cur_root.dup
        # add to emis Hash
        @emis_pr.merge(root, note)
        @trans_pr.merge(root, element, true)
      end
      # prepare for next call
      @cur_root = element
    end

    def process
      # add emission probabilities
      @emis_pr.joints.each do |root, notes|
        total = notes.size
        prob = 1.0/total
        notes.each do |n, pr|
          notes[n] = prob
        end
      end

      # add transition probabilities
      @trans_pr.joints.each do |root, elements|
        total = 0
        elements.each do |el,pr|
          total += el.n
        end
        elements.each do |el, pr|
          prob = Float(el.n)/total
          elements[el] = prob
        end
      end

      # initialise initial probabilities
      total = @trans_pr.joints.size
      @trans_pr.joints.each do |root, elements|
        @init_pr[root] = 1.0/total
      end
      processed = true
    end
  end
end