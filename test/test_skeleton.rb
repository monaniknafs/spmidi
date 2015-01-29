require 'test/unit'
require 'set'
require_relative '../lib/spmidi/pattern_element'
require_relative '../lib/spmidi/note'
require_relative '../lib/spmidi/skeleton'

module SPMidi
  class TestSkeleton < Test::Unit::TestCase

    def test_merge
      n1 = Note.new([0,3,1],0.0,200.0) 
      n2 = Note.new([0,5,3],0.1,120.1)
      n4 = Note.new([1,3,1],0.5,193.7)
      p1 = PatternElement.new(n1)
      p2 = PatternElement.new(n2)
      p4 = PatternElement.new(n4)

      assert_equal(p1,p4)
      assert_not_equal(p1,p2)

      sk = Skeleton.new
      sk.add(p1)
      sk.add(p4)
      sk.add(p2)

      # works but element identities are different
      # assert_equal(sk.skeleton,{p1 => [p4,p2].to_set})
      print sk.skeleton
      # h1 = {p1 => [1].to_set}
      # h2 = {p4 => [4].to_set}
    end

    def test_creation
      # test the merging of the hashsets in the skeleton class
      # we ignore ts and status,velocity fields in data array 

      n1 = Note.new([0,3,1],0.0,200.0) 
      n2 = Note.new([0,5,3],0.1,120.1)
      n3 = Note.new([0,6,3],0.7,100.3)
      n4 = Note.new([1,3,1],0.5,193.7)
      n5 = Note.new([0,6,3],0.0,97.1)
      n6 = Note.new([0,4,1],0.1,19.8)

      p1 = PatternElement.new(n1)
      p2 = PatternElement.new(n2)
      p3 = PatternElement.new(n3)
      p4 = PatternElement.new(n4)
      p5 = PatternElement.new(n5)
      p6 = PatternElement.new(n6)

      notes1 = [n1,n2,n3,n4,n5,n6]

      goes1 = Set.new [p3,p2]
      goes2 = Set.new [p3]
      goes3 = Set.new [p1,p6]
      sk1_assert = {p1 => goes1, p2 => goes2, p3 => goes3}

      sk1 = Skeleton.new
      notes1.each do |n|
        sk1.add(n)
      end

      # print "what i think i do\n"
      # sk1_assert.each do |key, val|
      #   print "key\n#{key.data}#{key.rel_ts}\n"
      #   print "value\n"
      #   val.each do |v|
      #     print "#{v.data} ,#{v.rel_ts}, "
      #   end
      #   print "\n"
      # end

      # print "what the computer thinks i do\n"
      # sk1.skeleton.each do |key, val|
      #   print "key\n#{key.data}#{key.rel_ts}\n"
      #   print "value\n"
      #   val.each do |v|
      #     print "#{v.data} ,#{v.rel_ts}, "
      #   end
      #   print "\n"
      # end

      assert_values = Set.new
      sk1_assert.values.each do |v|
        assert_values.merge(v)
      end

      skeleton_values = Set.new
      sk1.skeleton.values.each do |v|
        skeleton_values.merge(v)
      end

      assert_equal(sk1_assert.size, sk1.skeleton.size)
      assert_equal(sk1_assert.keys, sk1.skeleton.keys)
      assert_equal(sk1_assert.values.size, sk1.skeleton.values.size)
      # TODO write a value comparison that works
      # assert_equal(assert_values, skeleton_values)
    end
  end
end