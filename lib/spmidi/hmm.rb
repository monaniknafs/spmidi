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
      @emis_pr = Skeleton.new(false)
      @trans_pr = Skeleton.new(true)
      @init_pr = {}
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

    def add_notes(note_array)
      # used for testing purposes
      note_array.each do |n|
        add(n)
      end
    end

    def process
      # add emission probabilities
      @emis_pr.joints.each do |root, notes|
        total = 0.0
        mean = root.mean_ts
        sd = root.sd
        th = root.th # threshold
        if notes.size == 1
          notes.each do |n, pr|
            notes[n] = 1.0
          end
        else
          # part of prev definition
          # notes.each do |n, pr|
          #   total += 1.0/(mean - n.rel_ts).abs
          # end
          notes.each do |n, pr|
            # use z-scores for probability 
            ## stochastic distance metric from mean
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
      @trans_pr.joints.each do |root, elements|
        root_total += root.n
        total = 0
        elements.each do |el,pr|
          total += el.n
        end
        elements.each do |el, pr|
          prob = Float(el.n)/total
          elements[el] = prob # probability
        end
      end

      # initialise initial probabilities
      size = Float(@trans_pr.joints.size)
      pos = 1.0 # represents position
      sum_pos = Float(1.0/6) * size * (size + 1.0) * (2*size + 1.0)
      puts "sum pos = #{sum_pos}"

      # TODO
      # I want to reorder the transition probability roots in an array
      # to use to assign the initial probabilities in the appropriate order
      # maybe I can make the first element wild_ts?
      # do this , ensure when init_pr is used no errors are slippin'
      # and see what errors come up 

      # note this might not work as the frequency values is still off
      # since first note should be different,
      # but it's hard to define what before the hmm is made
      # plan b: once transition elements are determined , then change the root element
      # then calculate the probabilities

      first = true
      first_el = nil
      first_pr = nil
      @trans_pr.joints.each do |root, elements|
        sig = size + 1 - pos # significance
        puts "sig = #{sig}"
        pos_val = (sig * sig) / sum_pos
        freq_val = Float(root.n) / Float(root_total)
        if first 
          # TODO might want to merge this first element is all
          # first element has wild timestamp
          root = PatternElement.new(root.data, false)
          first_el = root
          first_pr = (pos_val + freq_val) / 2.0
          first = false
        end
        @init_pr[root] = (pos_val + freq_val) / 2.0
        pos += 1
      end

      # sketchy
      @init_pr.each do |el,pr|
        if el.eql?(first_el)
          @init_pr[first_el] = first_pr + pr
        end
      end

      tot = 0.0
      @init_pr.each do |el, pr|
        tot += pr
      end
      puts "total initial prob = #{tot}"

      @processed = true
    end

    def print_probabilities
      puts "emission probabilities\n"
      @emis_pr.joints.each do |root, destns|
        puts "#{root.print} => "
        destns.each do |note, pr|
          # iterate through Hash of notes=>probability
          note.print
          puts "prob = #{pr}"
        end
        puts "\n"
      end

      puts "transition probabilities\n"
      @trans_pr.joints.each do |root, destns|
        puts "#{root.print} => "
        destns.each do |pe, pr|
          # iterate through Hash of pelements=>probability
          pe.print
          puts "prob = #{pr}"
        end
        puts "\n"
      end

      puts "initial probabilities\n"
      @init_pr.each do |el, pr|
        puts "#{el.print} => #{pr}\n"
      end
    end
  end
end