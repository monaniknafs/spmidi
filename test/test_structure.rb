require 'test/unit'
require_relative '../lib/spmidi/data_collection'

module SPMidi
	class TestStructure < Test::Unit::TestCase

		def teststructure
			d = DataCollection.new

			x = 1/8.0
			assert_equal(9*x,d.round_to_frac(9*x,x))
			assert_equal(12*x, d.round_to_frac(12*x+0.03243,x))

			y = 1/72.0
			assert_equal(4*y,d.round_to_frac(3*y+y*0.75,y))
			assert_equal(3*y,d.round_to_frac(3*y+y*0.02,y))

			z = 1/72313892.0
			assert_equal(4*z,d.round_to_frac(3*z+z*0.5,z))
		end

	end
end