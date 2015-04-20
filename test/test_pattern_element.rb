require 'test/unit'
require_relative '../lib/spmidi/pattern_element'
require_relative '../lib/spmidi/note'

module SPMidi
	class TestPatternElement < Test::Unit::TestCase
    def test_equality
      e = PatternElement.new([0,0,0],203.25)
      f = PatternElement.new([0,0,0],189.08)
      assert_equal(true, e==f)

      g = PatternElement.new([0,0,0],203.25)
      h = PatternElement.new([0,0,0],18.0)
      assert_equal(false, g==h)

      n = Note.new([0,0,0],0.3,202.0)
      m = Note.new([0,0,0],0.6,203.0)
      en = PatternElement.new(n)
      em = PatternElement.new(m)
      assert_equal(true, en==em)

      p = Note.new([0,9,0],0.3,200.0)
      ep = PatternElement.new(p)
      assert_equal(false,em==ep)

      q = Note.new([9,9,0],0.6,190.0)
      eq = PatternElement.new(q)
      assert_equal(true,ep==eq)
    end

    def test_distribution
      notes = [407.0,437.0,404.0,408.5,423.0,388.5,396.25,413.25,413.0,430.5,413.0,376.0,383.0,416.125,409.375,394.875,412.5,414.5,433.125,436.125,407.125,408.625,430.375,366.5,391.875,410.5,428.5,367.5,372.0,389.875,417.5,422.625,460.125,443.0,416.0,406.0,415.5,399.0,396.875,399.625,397.875,414.0,386.875,376.0,429.5,431.0,376.5,395.5,399.0,369.5,383.0,403.5,413.875,411.125,376.0,403.0,398.5,377.875,398.5,365.5,378.25,363.5]
      element = PatternElement.new(1,notes[0])
      notes.each do |n|
        e = PatternElement.new(1,n)
      end
      refute_empty(element.timestamps)
      assert_instance_of(Float, element.mean_ts)
      assert_instance_of(Fixnum, element.n)

      n1 = Note.new([0,6,3],0.0,97.1)
      n2 = Note.new([0,6,3],0.0,100.1)
      n3 = Note.new([0,6,3],0.0,112.1)
      n4 = Note.new([0,6,3],0.0,10.1)
      n5 = Note.new([0,6,3],0.0,96.1)

      p1 = PatternElement.new(n1)
      p2 = PatternElement.new(n2)
      p3 = PatternElement.new(n3)
      p4 = PatternElement.new(n4)
      p5 = PatternElement.new(n5)

      p1 == p2
      p1 == p3
      p1 == p4
      p1 == p5

      assert_false(p1.wild_ts)
      assert_equal(4,p1.n)
      assert_equal(4,p1.timestamps.size)
    end

    def test_wild_pitch
      p1 = PatternElement.new(false, 20.8)
      p2 = PatternElement.new([1,2,3], 20.9)
      p3 = PatternElement.new(false, 20.7)
      p4 = PatternElement.new([4,5,6],300.0)

      assert_true(p1.eql?(p1))      
      assert_true(p1.eql?(p2))
      assert_true(p1.eql?(p3))
      assert_false(p1.eql?(p4))
    end

    def test_wild_ts
      p1 = PatternElement.new([1,27,1], false)
      p2 = PatternElement.new([1,27,1], 70.2)
      p3 = PatternElement.new([1,27,1], false)

      assert_true(p1==p3)
      assert_equal(p1.timestamps, [70.2,70.2])
      assert_true(p1==p2)
      assert_equal(p1.n,3)
      assert_equal(p1.timestamps, [70.2,70.2,70.2])
      assert_equal(p1.mean_ts, 70.2)
    end
  end
end