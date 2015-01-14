require 'test/unit'
require_relative '../lib/spmidi/pattern_element'

module SPMidi
	class TestPatternElement < Test::Unit::TestCase
    def test_equality
      e = PatternElement.new([0,0,0],203.25)
      f = PatternElement.new([0,0,0],189.08)
      assert_equal(true, e==f)
      g = PatternElement.new([0,0,0],203.25)
      h = PatternElement.new([0,0,0],18.0)
      assert_equal(false, g==h)
    end
  end
end