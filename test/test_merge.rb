require 'test/unit'
require 'set'
require_relative '../lib/spmidi/pattern_element'
require_relative '../lib/spmidi/note'

module SPMidi
  class TestMerge < Test::Unit::TestCase
    def test_merge
      n1 = Note.new([1,1,1],1.1,100.0)
      n2 = Note.new([1,1,1],2.2,102.0)
      p1 = PatternElement.new(n1)
      p2 = PatternElement.new(n2)

      assert_not_equal(n1,n2)
      assert_equal(p1,p2)

      h1 = Hash.new
      h1[p1] = [1,2,3,4].to_set
      h2 = Hash.new
      h2[p2] = [3,4,5,6].to_set

      h3_assert1 = {p1 => [1,2,3,4,5,6].to_set}
      h3_assert2 = {p2 => [1,2,3,4,5,6].to_set}
      h3 = h1.merge(h2){|key,oldval,newval| oldval.merge(newval)}
      assert_equal(false, h1.has_key?(p2))
      # i.e note that the classes have to be same instance
      puts h3 #doesn't have the desired effect
    end

    def test_set
      n1 = Note.new([1,1,1],1.1,100.0)
      n2 = Note.new([1,1,1],2.2,102.0)
      p1 = PatternElement.new(n1)
      p_test = p1.dup
      p2 = PatternElement.new(n2)

      s = Set.new
      s << p1
      assert_equal(true,s.member?(p1))
    end
  end
end