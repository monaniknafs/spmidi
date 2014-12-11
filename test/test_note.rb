require 'test/unit'
require_relative '../lib/spmidi/note'

module SPMidi
  class TestNote < Test::Unit::TestCase
   def test_note
     n0 = Note.new([0,0,10],0.0,0.0,[],0)
     assert_equal("C0",n0.note_letter)
     assert_equal(0,n0.note_octave)

     n1 = Note.new([0,127,10],0.0,0.0,[],0)
     assert_equal("G10",n1.note_letter)
     assert_equal(10,n1.note_octave)

     n2 = Note.new([0,87,10],0.0,0.0,[],0)
     assert_equal("Ds7",n2.note_letter)
     assert_equal(7,n2.note_octave)
   end
  end
end