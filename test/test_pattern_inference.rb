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
      puts "first patten inferred:"
      pi1.current.elements.each do |e|
        e.print
      end

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
      puts "second patten inferred:"
      pi2.current.elements.each do |e|
        e.print
      end

      assert_equal(p_elements2.length, pi2.current.elements.length)
      for i in 0..pi2.current.elements.length-1
        assert_equal(p_elements2[i].mean_ts, pi2.current.elements[i].mean_ts)
        assert_equal(p_elements2[i].data, pi2.current.elements[i].data)
      end

      elements3 = [
      PatternElement.new([144, 60, 71], 276.0),
      PatternElement.new([144, 62, 71], 205.125),
      PatternElement.new([144, 62, 74], 105.5),
      PatternElement.new([144, 60, 71], 157.21875),
      PatternElement.new([144, 62, 69], 265.3125),
      PatternElement.new([144, 60, 65], 261.9),
      PatternElement.new([144, 62, 69], 194.62899305555555),
      PatternElement.new([144, 62, 67], 104.23125),
      PatternElement.new([144, 60, 59], 128.32196593915344),
      PatternElement.new([144, 62, 70], 207.375),
      PatternElement.new([144, 60, 64], 262.1875),
      PatternElement.new([144, 62, 69], 188.79166666666666),
      PatternElement.new([144, 62, 73], 102.25),
      PatternElement.new([144, 60, 65], 160.25),
      PatternElement.new([144, 62, 68], 210.9375),
      PatternElement.new([144, 60, 65], 194.44861111111112),
      PatternElement.new([144, 62, 70], 185.17290013227512),
      PatternElement.new([144, 62, 74], 97.31458333333333),
      PatternElement.new([144, 60, 71], 132.6694416887125),
      PatternElement.new([144, 62, 80], 200.51174768518518),
      PatternElement.new([144, 60, 69], 245.5),
      PatternElement.new([144, 62, 73], 195.02349537037037),
      PatternElement.new([144, 62, 73], 95.928125),
      PatternElement.new([144, 60, 68], 142.0984829695767),
      PatternElement.new([144, 62, 66], 207.4375),
      PatternElement.new([144, 60, 64], 262.28125),
      PatternElement.new([144, 62, 72], 168.0),
      PatternElement.new([144, 62, 72], 109.125),
      PatternElement.new([144, 60, 70], 151.0),
      PatternElement.new([144, 62, 59], 255.375)]

      pi3 = PatternInference.new

      elements3.each do |el|
        pi3.find_pattern_size(el)
      end
      puts "third patten inferred:"
      pi3.current.elements.each do |e|
        e.print
      end
    end
  end
end