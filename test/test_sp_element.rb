require 'test/unit'
require_relative '../lib/spmidi/sp_element'

module SPMidi
  class TestSPElement < Test::Unit::TestCase
    def test_init
      pitch = 34
      ts = 83.0
      rel_ts = 2.0
      a = SPElement.new({:pitch => pitch, :ts => ts, :rel_ts => rel_ts}) 
    end
    def test_equality
      pitch = 34
      ts = 83.0
      rel_ts = 2.0
      a = SPElement.new({:pitch => pitch, :ts => ts, :rel_ts => rel_ts}) 
      b = SPElement.new({:pitch => pitch, :ts => ts, :rel_ts => rel_ts}) 
      c = SPElement.new({:pitch => 35, :ts => ts, :rel_ts => rel_ts})
      a.sp_print
      assert_equal(a,b)
      assert_not_equal(a,c)
    end
  end
end