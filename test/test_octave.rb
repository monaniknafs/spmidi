require 'test/unit'
require_relative '../lib/spmidi/data_collection'

module SPMidi
	class TestOctave < Test::Unit::TestCase

		def testoctave
			d = DataCollection.new
			assert_equal(0,d.note_octave(0))
			assert_equal(0,d.note_octave(10))
			assert_equal(5,d.note_octave(67))
			assert_equal(3,d.note_octave(47))
		end

		def testdownoctave
			d = DataCollection.new
			x = 24
			assert_equal(x-24,d.down_octave(x,2))
			# how to I use assert_raise
			# i.e how do I use exceptions
		end

	end
end