require 'test/unit'
require_relative '../lib/spmidi/pattern_element'
require_relative '../lib/spmidi/note'

module SPMidi
	class TestPatternElement < Test::Unit::TestCase
    def test_equality
      e = PatternElement.new([0,0,0],203.25)
      f = PatternElement.new([0,0,0],189.08)
      assert_equal(true, e==f)

      g = PatternElement.new([0,0,0],203.25)
      h = PatternElement.new([0,0,0],18.0)
      assert_equal(false, g==h)

      n = Note.new([0,0,0],0.3,202.0)
      m = Note.new([0,0,0],0.6,203.0)
      en = PatternElement.new(n)
      em = PatternElement.new(m)
      assert_equal(true, en==em)

      p = Note.new([0,9,0],0.3,200.0)
      ep = PatternElement.new(p)
      assert_equal(false,em==ep)

      q = Note.new([9,9,0],0.6,190.0)
      eq = PatternElement.new(q)
      assert_equal(true,ep==eq)
    end
  end
end