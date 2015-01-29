require 'test/unit'
require_relative '../lib/spmidi/note'
require_relative '../lib/spmidi/pattern'
require_relative '../lib/spmidi/pattern_inference'

module SPMidi
  class TestPatternInference < Test::Unit::TestCase

    def test_find_pattern_size
      # p*_notes is array of notes in repeated pattern

      # test 1
      notes1 = [
      Note.new([2,3,4],0.0,200.0),
      Note.new([4,5,6],0.1,120.1),
      Note.new([1,2,3],0.7,100.3),
      Note.new([1,7,4],0.5,110.3),
      Note.new([2,3,4],0.0,200.0),
      Note.new([4,5,6],0.1,120.1),
      Note.new([1,2,3],0.7,100.3),
      Note.new([1,7,4],0.5,110.3),
      Note.new([2,3,4],0.0,200.0),
      Note.new([4,5,6],0.1,120.1),
      Note.new([1,2,3],0.7,100.3),
      Note.new([1,7,4],0.5,110.3),
      Note.new([2,3,4],0.0,200.0),
      Note.new([4,5,6],0.1,120.1),
      Note.new([1,2,3],0.7,100.3),
      Note.new([1,7,4],0.5,110.3)]

      p_notes1 = [
      Note.new([2,3,4],0.0,200.0),
      Note.new([4,5,6],0.1,120.1),
      Note.new([1,2,3],0.7,100.3),
      Note.new([1,7,4],0.5,110.3)]

      pi1 = PatternInference.new
      notes1.each do |note1|
        pi1.find_pattern_size(note1)
      end

      # remove
      pi1.prev.each do |x|
        puts "pattern"
        x.print
      end
      # remove

      assert_equal(p_notes1.length, pi1.current.elements.length)
      for i in 0..pi1.current.elements.length-1
        assert_equal(p_notes1[i].rel_ts, pi1.current.elements[i].rel_ts)
        assert_equal(p_notes1[i].data, pi1.current.elements[i].data)
      end

      # test 2
      notes2 = [
      Note.new([2,3,4],0.0,200.0),
      Note.new([2,3,4],0.0,200.0),
      Note.new([2,3,4],0.0,200.0),
      Note.new([4,5,6],0.1,120.1),
      Note.new([4,5,6],0.1,120.1),
      Note.new([2,3,4],0.0,200.0),
      Note.new([2,3,4],0.0,200.0),
      Note.new([2,3,4],0.0,200.0),
      Note.new([4,5,6],0.1,120.1),
      Note.new([4,5,6],0.1,120.1),
      Note.new([2,3,4],0.0,200.0),
      Note.new([4,5,6],0.1,120.1),
      Note.new([5,2,4],0.5,183.3),
      Note.new([5,2,4],0.5,183.3),
      Note.new([1,7,4],0.5,110.3),
      Note.new([2,3,4],0.0,200.0),
      Note.new([4,5,6],0.1,120.1),
      Note.new([5,2,4],0.5,183.3),
      Note.new([5,2,4],0.5,183.3),
      Note.new([1,7,4],0.5,110.3),
      Note.new([2,3,4],0.0,200.0),
      Note.new([4,5,6],0.1,120.1),
      Note.new([5,2,4],0.5,183.3),
      Note.new([5,2,4],0.5,183.3),
      Note.new([1,7,4],0.5,110.3),
      Note.new([2,3,4],0.0,200.0),
      Note.new([4,5,6],0.1,120.1),
      Note.new([5,2,4],0.5,183.3),
      Note.new([5,2,4],0.5,183.3),
      Note.new([1,7,4],0.5,110.3)]

      p_notes2 = [
      Note.new([2,3,4],0.0,200.0),
      Note.new([4,5,6],0.1,120.1),
      Note.new([5,2,4],0.5,183.3),
      Note.new([5,2,4],0.5,183.3),
      Note.new([1,7,4],0.5,110.3)]

      pi2 = PatternInference.new

      notes2.each do |note2|
        pi2.find_pattern_size(note2)
      end

      # remove
      pi2.prev.each do |x|
        puts "pattern"
        x.print
        p x.confidence
      end
      # remove

      assert_equal(p_notes2.length, pi2.current.elements.length)
      for i in 0..pi2.current.elements.length-1
        assert_equal(p_notes2[i].rel_ts, pi2.current.elements[i].rel_ts)
        assert_equal(p_notes2[i].data, pi2.current.elements[i].data)
      end
    end
  end
end