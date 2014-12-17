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
      Note.new([2,3,4],0.0,0.0),
      Note.new([4,5,6],0.1,0.1),
      Note.new([1,2,3],0.7,0.3),
      Note.new([1,2,4],0.5,0.3),
      Note.new([2,3,4],0.0,0.0),
      Note.new([4,5,6],0.1,0.1),
      Note.new([1,2,3],0.7,0.3),
      Note.new([1,2,4],0.5,0.3),
      Note.new([2,3,4],0.0,0.0),
      Note.new([4,5,6],0.1,0.1),
      Note.new([1,2,3],0.7,0.3),
      Note.new([1,2,4],0.5,0.3),
      Note.new([2,3,4],0.0,0.0),
      Note.new([4,5,6],0.1,0.1),
      Note.new([1,2,3],0.7,0.3),
      Note.new([1,2,4],0.5,0.3)]

      p_notes1 = [
      Note.new([2,3,4],0.0,0.0),
      Note.new([4,5,6],0.1,0.1),
      Note.new([1,2,3],0.7,0.3),
      Note.new([1,2,4],0.5,0.3)]

      pi1 = PatternInference.new
      notes1.each do |note1|
        pi1.find_pattern_size(note1)
      end
      assert_equal(p_notes1.length, pi1.current.length)
      for i in 0..pi1.current.length-1
        assert_equal(p_notes1[i].rel_ts, pi1.current.notes[i].rel_ts)
        assert_equal(p_notes1[i].data, pi1.current.notes[i].data)
      end

      # test 2
      notes2 = [
      Note.new([2,3,4],0.0,0.0),
      Note.new([2,3,4],0.0,0.0),
      Note.new([2,3,4],0.0,0.0),
      Note.new([4,5,6],0.1,0.1),
      Note.new([4,5,6],0.1,0.1),
      Note.new([2,3,4],0.0,0.0),
      Note.new([2,3,4],0.0,0.0),
      Note.new([2,3,4],0.0,0.0),
      Note.new([4,5,6],0.1,0.1),
      Note.new([4,5,6],0.1,0.1),
      Note.new([2,3,4],0.0,0.0),
      Note.new([4,5,6],0.1,0.1),
      Note.new([5,2,4],0.5,0.3),
      Note.new([5,2,4],0.5,0.3),
      Note.new([1,2,4],0.5,0.3),
      Note.new([2,3,4],0.0,0.0),
      Note.new([4,5,6],0.1,0.1),
      Note.new([5,2,4],0.5,0.3),
      Note.new([5,2,4],0.5,0.3),
      Note.new([1,2,4],0.5,0.3),
      Note.new([2,3,4],0.0,0.0),
      Note.new([4,5,6],0.1,0.1),
      Note.new([5,2,4],0.5,0.3),
      Note.new([5,2,4],0.5,0.3),
      Note.new([1,2,4],0.5,0.3),
      Note.new([2,3,4],0.0,0.0),
      Note.new([4,5,6],0.1,0.1),
      Note.new([5,2,4],0.5,0.3),
      Note.new([5,2,4],0.5,0.3),
      Note.new([1,2,4],0.5,0.3)]

      p_notes2 = [
      Note.new([2,3,4],0.0,0.0),
      Note.new([4,5,6],0.1,0.1),
      Note.new([5,2,4],0.5,0.3),
      Note.new([5,2,4],0.5,0.3),
      Note.new([1,2,4],0.5,0.3)]

      pi2 = PatternInference.new

      notes2.each do |note2|
        pi2.find_pattern_size(note2)
      end

      assert_equal(p_notes2.length, pi2.current.length)
      for i in 0..pi2.current.length-1
        assert_equal(p_notes2[i].rel_ts, pi2.current.notes[i].rel_ts)
        assert_equal(p_notes2[i].data, pi2.current.notes[i].data)
      end
    end
  end
end