require 'test/unit'
require_relative '../lib/spmidi/note'

module SPMidi
  class TestNote < Test::Unit::TestCase
    def test_pitch
      n0 = Note.new([0,0,10],0.0,0.0)
      assert_equal("C0",n0.note_letter)
      assert_equal(0,n0.note_octave)

      n1 = Note.new([0,127,10],0.0,0.0)
      assert_equal("G10",n1.note_letter)
      assert_equal(10,n1.note_octave)

      n2 = Note.new([0,87,10],0.0,0.0)
      assert_equal("Ds7",n2.note_letter)
      assert_equal(7,n2.note_octave)
    end
    def test_ts
      # test locked timestamp is multiple of element argument
      n1 = Note.new([0,87,10],1.2,0.7)
      e1 = 0.25
      n1.lock_rel_ts(e1)
      assert_equal(0,n1.rel_ts % e1)
      n1.lock_ts(e1)
      assert_equal(0,n1.ts % e1)
    end
    def test_equality
      n1 = Note.new([0,87,10],1.2,0.7)
      n2 = Note.new([0,87,10],2.9,0.7)
      n3 = Note.new([0,87,10],1.2,0.7)
      n4 = Note.new([0,87,10],1.2,0.7)
      n5 = Note.new([0,87,10],1.2,0.7)
      array1 = [n1,n2,n3,n4,n5]
      array2 = [n5,n4,n3,n2,n1]
      assert_equal(array1,array2)
    end
  end
end