require 'test/unit'
require_relative '../lib/spmidi/note'
require_relative '../lib/spmidi/pattern'

module SPMidi
  class TestPattern < Test::Unit::TestCase
    def test_first_occurrence
      notes1 = 
      [Note.new([2,3,4],0.0,0.0),
       Note.new([4,5,6],0.1,0.1),
       Note.new([1,2,3],0.7,0.3),
       Note.new([1,2,3],0.5,0.3)]
      p1 = Pattern.new(notes1)
      puts p1.length
      # assert first occurrence is returned and nothing else
      assert_equal(2,p1.occurs_after?(Note.new([1,2,3],0.7,0.3),1))
      # assert timestamp has no impact on note matching
      assert_equal(true,p1.occurs?(Note.new([1,2,3],0.5,0.3),3))

      notes2 = []
      p2 = Pattern.new(notes2)
      assert_equal(false,p2.occurs?(Note.new([1,2,3],0.7,0.3),2))

      notes3 = 
      [Note.new([2,3,4],0.0,0.0),
       Note.new([4,5,6],0.1,0.1)]
      p3 = Pattern.new(notes3)
      assert_equal(nil,p3.occurs_after?(Note.new([1,2,3],0.7,0.3),0))
      assert_equal(0,p3.occurs_after?(Note.new([2,3,4],0.0,0.0),0))
    end
  end
end