require 'test/unit'

require_relative '../lib/spmidi/levenshtein'
require_relative '../lib/spmidi/sp_element'

module SPMidi
  class TestLevenshtein < Test::Unit::TestCase
    def test_distance
      pitch = 34
      ts = 83.0
      rel_ts = 2.0
      a = SPElement.new({:pitch => pitch, :ts => ts, :rel_ts => rel_ts}) 
      b = SPElement.new({:pitch => pitch, :ts => ts, :rel_ts => 2.125})
      c = SPElement.new({:pitch => 35, :ts => ts, :rel_ts => rel_ts})

      infer1 = [a,a.dup,c]
      infer2 = [a,b,c]
      actual = [a,a.dup,a.dup]


      l = Levenshtein.new(1/16.0)
      assert_equal(0,l.c_sub_ts(a,c))
      assert_equal(1,l.c_sub_p(a,c))

      assert_equal(0,l.c_sub_ts(a,a.dup))
      assert_equal(0,l.c_sub_p(a,a.dup))

      assert_equal(l.distance(infer1,actual),1)
      assert_equal(l.distance(infer2,actual),3)
    end

    def test_c_sub
      pitch = 34
      ts = 83.0
      rel_ts = 2.0
      a = SPElement.new({:pitch => pitch, :ts => ts, :rel_ts => rel_ts}) 
      b = SPElement.new({:pitch => pitch, :ts => ts, :rel_ts => rel_ts})
      c = SPElement.new({:pitch => 35, :ts => ts, :rel_ts => rel_ts})
      d = SPElement.new({:pitch => pitch, :ts => ts, :rel_ts => 2.125})
      l = Levenshtein.new(1/16.0)
      assert_equal(l.c_sub_ts(a,b),0) 
      assert_equal(l.c_sub_ts(a,c),0) 
      assert_equal(l.c_sub_ts(a,d),2) 
      assert_equal(l.c_sub_p(a,c),1) 
    end
  end
end