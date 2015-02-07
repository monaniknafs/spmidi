require 'test/unit'
require_relative '../lib/spmidi/note'
require_relative '../lib/spmidi/pattern'
require_relative '../lib/spmidi/pattern_inference'

module SPMidi
  class TestPatternInference < Test::Unit::TestCase

    def test_find_pattern_size
      # p*_notes is array of notes in repeated pattern

      # test 1
      elements1 = [
      PatternElement.new([2,3,4],200.0),
      PatternElement.new([4,5,6],120.1),
      PatternElement.new([1,2,3],100.3),
      PatternElement.new([1,7,4],110.3),
      PatternElement.new([2,3,4],200.0),
      PatternElement.new([4,5,6],120.1),
      PatternElement.new([1,2,3],100.3),
      PatternElement.new([1,7,4],110.3),
      PatternElement.new([2,3,4],200.0),
      PatternElement.new([4,5,6],120.1),
      PatternElement.new([1,2,3],100.3),
      PatternElement.new([1,7,4],110.3),
      PatternElement.new([2,3,4],200.0),
      PatternElement.new([4,5,6],120.1),
      PatternElement.new([1,2,3],100.3),
      PatternElement.new([1,7,4],110.3)]

      p_elements1 = [
      PatternElement.new([2,3,4],200.0),
      PatternElement.new([4,5,6],120.1),
      PatternElement.new([1,2,3],100.3),
      PatternElement.new([1,7,4],110.3)]

      pi1 = PatternInference.new
      elements1.each do |el|
        pi1.find_pattern_size(el)
      end

      # remove
      pi1.prev.each do |x|
        puts "pattern"
        x.print
      end
      # remove

      assert_equal(p_elements1.length, pi1.current.elements.length)
      for i in 0..pi1.current.elements.length-1
        assert_equal(p_elements1[i].mean_ts, pi1.current.elements[i].mean_ts)
        assert_equal(p_elements1[i].data, pi1.current.elements[i].data)
      end

      # test 2
      elements2 = [
      PatternElement.new([2,3,4],200.0),
      PatternElement.new([2,3,4],200.0),
      PatternElement.new([2,3,4],200.0),
      PatternElement.new([4,5,6],120.1),
      PatternElement.new([4,5,6],120.1),
      PatternElement.new([2,3,4],200.0),
      PatternElement.new([2,3,4],200.0),
      PatternElement.new([2,3,4],200.0),
      PatternElement.new([4,5,6],120.1),
      PatternElement.new([4,5,6],120.1),
      PatternElement.new([2,3,4],200.0),
      PatternElement.new([4,5,6],120.1),
      PatternElement.new([5,2,4],183.3),
      PatternElement.new([5,2,4],183.3),
      PatternElement.new([1,7,4],110.3),
      PatternElement.new([2,3,4],200.0),
      PatternElement.new([4,5,6],120.1),
      PatternElement.new([5,2,4],183.3),
      PatternElement.new([5,2,4],183.3),
      PatternElement.new([1,7,4],110.3),
      PatternElement.new([2,3,4],200.0),
      PatternElement.new([4,5,6],120.1),
      PatternElement.new([5,2,4],183.3),
      PatternElement.new([5,2,4],183.3),
      PatternElement.new([1,7,4],110.3),
      PatternElement.new([2,3,4],200.0),
      PatternElement.new([4,5,6],120.1),
      PatternElement.new([5,2,4],183.3),
      PatternElement.new([5,2,4],183.3),
      PatternElement.new([1,7,4],110.3)]

      p_elements2 = [
      PatternElement.new([2,3,4],200.0),
      PatternElement.new([4,5,6],120.1),
      PatternElement.new([5,2,4],183.3),
      PatternElement.new([5,2,4],183.3),
      PatternElement.new([1,7,4],110.3)]

      pi2 = PatternInference.new

      elements2.each do |el|
        pi2.find_pattern_size(el)
      end

      # remove
      pi2.prev.each do |x|
        puts "pattern"
        x.print
        p x.confidence
      end
      # remove

      assert_equal(p_elements2.length, pi2.current.elements.length)
      for i in 0..pi2.current.elements.length-1
        assert_equal(p_elements2[i].mean_ts, pi2.current.elements[i].mean_ts)
        assert_equal(p_elements2[i].data, pi2.current.elements[i].data)
      end
    end
  end
end