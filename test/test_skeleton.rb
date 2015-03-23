require 'test/unit'

require_relative '../lib/spmidi/skeleton'
require_relative '../lib/spmidi/pattern_element'

module SPMidi
  class TestSkeleton < Test::Unit::TestCase
    def test_merge
      p1 = PatternElement.new([1,2,1],90.0)
      almost_p1 = PatternElement.new([1,2,1],100.0)
      p2 = PatternElement.new([1,4,1],180.0)
      almost_p2 = PatternElement.new([1,4,1],200.0)
      p3 = PatternElement.new([1,3,1],270.0)
      p4 = PatternElement.new([1,8,1],260.0)
      p5 = PatternElement.new([1,3,1],150.0)
      p6 = PatternElement.new([1,4,1],230.0)

      sk = Skeleton.new(true)
      sk.merge(p1,p2,0.25)
      sk.merge(p1,p3,0.34)
      sk.merge(p3,p4,0.55)
      sk.merge(p4,p5,0.66)
      sk.merge(p5,p4,0.77)
      sk.merge(p4,p3,0.43)

      puts sk.get_nested_destn(almost_p1,almost_p2)

      puts "\n---\n"

      n1 = Note.new([1,2,1],1.0,90.0)
      n2 = Note.new([1,4,1],2.0,180.0)
      n3 = Note.new([1,3,1],3.0,270.0)
      almost_n1 = Note.new([1,2,1],4.0,100.0)
      n4 = Note.new([1,4,1],5.0,190.0)
      almost_n2 = Note.new([1,4,1],6.0,200.0)
      n5 = Note.new([1,3,1],7.0,265.0)
      n6 = Note.new([1,4,1],8.0,230.0)

      pn1 = PatternElement.new([1,2,1],90.0)
      pn2 = PatternElement.new([1,4,1],180.0)
      pn3 = PatternElement.new([1,3,1],270.0)
      almost_pn1 = PatternElement.new([1,2,1],100.0)
      pn4 = PatternElement.new([1,4,1],190.0)
      almost_pn2 = PatternElement.new([1,4,1],200.0)
      pn5 = PatternElement.new([1,3,1],265.0)
      pn6 = PatternElement.new([1,4,1],230.0)

      sk_emis = Skeleton.new(false)
      sk_emis.merge(p1,n2,0.1)
      sk_emis.merge(p2,n3,0.2)
      sk_emis.merge(p3,almost_n1,0.3)
      sk_emis.merge(almost_pn1,n4,0.4)
      sk_emis.merge(pn4,almost_n2,0.5)
      sk_emis.merge(almost_pn2,n5,0.6)
      sk_emis.merge(pn5,n6,0.7)

      puts "emission probabilities\n"
      sk_emis.joints.each do |root, destns|
        puts "#{root.print} => "
        destns.each do |note, pr|
          # iterate through Hash of notes=>probability
          note.print
          puts "prob = #{pr}"
        end
        puts "\n"
      end
    end
  end
end