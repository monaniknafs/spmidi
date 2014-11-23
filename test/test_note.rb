require 'test/unit'
require_relative '../lib/spmidi/data_collection'
module SPMidi
class TestNote < Test::Unit::TestCase

	def test_note
		d = DataCollection.new
		assert_equal("C0",d.note_letter(0))
		assert_equal("G10",d.note_letter(127))
		assert_equal("Ds7",d.note_letter(87))
	end

	def test_note_range
		
	end
	# TODO
	# more unit tests
	# don't go crazy
	# generative, generate note, octave, RSpec,..
	# travis
end
end