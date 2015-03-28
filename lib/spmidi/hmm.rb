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
    attr_reader :x # teleportation constant
    attr_reader :trans
    attr_reader :emis
    attr_reader :cur_root
    attr_reader :processed
    attr_reader :x

    def initialize
      @cur_root = nil
      @alphabet = []
      @states = []
      @x = 0.15
      @emis_pr = Skeleton.new(false, @x)
      @trans_pr = Skeleton.new(true, @x)
      @init_pr = Hash.new # TODO think of something logical for initial states
      @processed = false
    end

    def add(note)
      @alphabet << note
      element = PatternElement.new(note)
      @emis_pr.merge(element.dup, note, 0.0)

      if @cur_root == nil
        # first call to add
        @states << element
      else
        root = @cur_root.dup
        # add to transition Hash
        @trans_pr.merge(root, element.dup, 0.0)

        # add state if new
        repeat_el = false
        @states.each do |s|
          if s.eql?(element)
            repeat_el = true
          end
        end
        if !repeat_el
          @states << element
        end
      end
      # prepare for next call
      @cur_root = element
    end

    def process
      tport_pr = @emis_pr.x 
      # add emission probabilities
      @emis_pr.joints.each do |root, notes|
        total = 0.0
        mean = root.mean_ts
        sd = root.sd
        th = root.th # threshold
        if notes.size == 1
          notes.each do |n, pr|
            notes[n] = 1.0*(1-tport_pr)
          end
        else
          # part of prev definition
          # notes.each do |n, pr|
          #   total += 1.0/(mean - n.rel_ts).abs
          # end
          notes.each do |n, pr|
            # prev defn: notes[n] = (1.0/(mean - n.rel_ts).abs)/total*(1-tport_pr) # probability
            z = ((n.rel_ts - mean)/sd).abs
            rev_z = th-z
            notes[n] = rev_z
            total += rev_z
          end
          notes.each do |n, pr|
            rev_z = notes[n]
            notes[n] = rev_z/total
          end
        end
      end

      # add transition probabilities
      root_total = 0
      tport_pr = @trans_pr.x
      @trans_pr.joints.each do |root, elements|
        root_total += root.n
        total = 0
        elements.each do |el,pr|
          total += el.n
        end
        elements.each do |el, pr|
          prob = Float(el.n)/total*(1-tport_pr)
          elements[el] = prob # probability
        end
      end

      # initialise initial probabilities
      @trans_pr.joints.each do |root, elements|
        @init_pr[root] = Float(root.n) / Float(root_total)
      end
      @processed = true
    end
  end
end