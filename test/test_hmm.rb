require 'test/unit'
require_relative '../lib/spmidi/hmm'
require_relative '../lib/spmidi/note'

module SPMidi
  class TestHMM < Test::Unit::TestCase
    def test_add_process
      n1 = Note.new([0,3,1],0.0,200.0) 
      n2 = Note.new([0,5,3],0.1,120.1)
      n3 = Note.new([0,6,3],0.7,100.3)
      n4 = Note.new([1,3,1],0.5,193.7)
      n5 = Note.new([0,6,3],0.0,97.1)
      n6 = Note.new([0,4,1],0.1,19.8)

      n11 = Note.new([0,3,1],1.0,203.0) 
      n12 = Note.new([0,5,3],1.1,118.1)
      n13 = Note.new([0,6,3],1.7,113.3)
      n14 = Note.new([1,3,1],1.5,183.7)
      n15 = Note.new([0,6,3],1.0,100.1)
      n16 = Note.new([0,4,1],1.1,19.9)

      p1 = PatternElement.new(n1)
      p2 = PatternElement.new(n2)
      p3 = PatternElement.new(n3)
      p4 = PatternElement.new(n4)
      p5 = PatternElement.new(n5)
      p6 = PatternElement.new(n6)

      assert_equal(p1,p4)
      assert_equal(p3,p5)

      hmm = HMM.new
      hmm.add(n1)
      hmm.add(n2)
      hmm.add(n3)
      hmm.add(n4)
      hmm.add(n5)
      hmm.add(n6)
      hmm.add(n11)
      hmm.add(n12)
      hmm.add(n13)
      hmm.add(n14)
      hmm.add(n15)
      hmm.add(n16)

      puts "alphabet\n"
      hmm.alphabet.each do |note|
        note.print
        puts "\n"
      end

      puts "states\n"
      hmm.states.each do |el|
        el.print
        puts "\n"
      end

      goes1 = Set.new [p3,p2]
      goes2 = Set.new [p3]
      goes3 = Set.new [p1,p6]
      goes4 = Set.new [p1]
      trans_assert = {p1 => goes1, p2 => goes2, p3 => goes3, p6 => goes4}

      assert_equal(hmm.trans_pr.joints.size, trans_assert.size)
      assert_equal(hmm.trans_pr.joints.keys, trans_assert.keys)
      # need a way to test values
      # probably have to loop through Hash

      hmm.process      
      puts "emission probabilities\n"
      hmm.emis_pr.joints.each do |root, destns|
        puts "#{root.print} => "
        destns.each do |note, pr|
          # iterate through Hash of notes=>probability
          note.print
          puts "prob = #{pr}"
        end
        puts "\n"
      end

      puts "transition probabilities\n"
      hmm.trans_pr.joints.each do |root, destns|
        puts "#{root.print} => "
        destns.each do |pe, pr|
          # iterate through Hash of pelements=>probability
          pe.print
          puts "prob = #{pr}"
        end
        puts "\n"
      end

      puts "initial probabilities\n"
      hmm.init_pr.each do |el, pr|
        puts "#{el.print} => #{pr}\n"
      end
    end
  end
end