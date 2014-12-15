require 'test/unit'
require_relative '../lib/spmidi/note'
require_relative '../lib/spmidi/pattern'
require_relative '../lib/spmidi/pattern_inference'

module SPMidi
  class TestPatternInference < Test::Unit::TestCase

    def test_find_pattern_size(notes, p_notes)
      # p_notes is array of notes in repeated pattern
      pi = PatternInference.new

      notes.each do |note|
        pi.find_pattern_size(note)
      end
      assert_equal(p_notes.length, pi.current.length)
      for i in 0..pi.current.length-1
        assert_equal(p_notes[i].rel_ts, pi.current.notes[i].rel_ts)
        assert_equal(p_notes[i].data, pi.current.notes[i].data)
      end
    end

    def test_cases
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

    test_find_pattern_size(notes1,p_notes1)

    notes2 = [
    Note.new([2,3,4],0.0,0.0),
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

    test_find_pattern_size(notes2,p_notes2)

    end
  end
end