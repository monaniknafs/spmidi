require 'test/unit'
require_relative '../lib/spmidi/viterbi'
require_relative '../lib/spmidi/pattern_inference' 
require_relative '../lib/spmidi/note'
require_relative '../lib/spmidi/pattern_element' 
require_relative '../lib/spmidi/hmm' 

module SPMidi
  class TestSystem < Test::Unit::TestCase
    def test_complete_system      
      n1 = Note.new([0,3,1],0.0,200.0) 
      n2 = Note.new([0,5,3],0.1,120.1)
      n3 = Note.new([0,6,3],0.2,100.3)
      n4 = Note.new([1,3,1],0.3,193.7)
      n5 = Note.new([0,6,3],0.4,97.1)
      n6 = Note.new([0,4,1],0.5,19.8)
      n11 = Note.new([0,3,1],1.0,203.0) 
      n12 = Note.new([0,5,3],1.1,118.1)
      n13 = Note.new([0,6,3],1.7,113.3)
      n14 = Note.new([1,3,1],1.5,183.7)
      n15 = Note.new([0,6,3],1.0,100.1)
      n16 = Note.new([0,4,1],1.1,19.9)
      n111 = Note.new([0,3,1],0.0,170.0)
      n_extra = Note.new([0,9,1],1.1,19.9)
      n_oops = Note.new([1,9,1],0.3,200.8)
      n_a = Note.new([0,1,2],1.0,88.0)
      n_b = Note.new([0,1,3],1.0,100.0)
      notes = [n1,n2,n3,n4,n_extra,n5,n6,n_oops,n12,n13,n14,n15,n16,n11,n_oops,n12,n13,n14,n15,n16,n11,n12,n13,n14,n15,n_a,n_b,n16,n11,n12,n13,n14,n15,n16,n11,n12,n13,n14,n15,n16,n11,n12,n13,n14,n15,n16,n111,n12,n13,n14,n15,n16,n11,n12,n13,n14,n15,n16,n11,n12,n13,n14,n15,n16,n11,n12,n13,n14,n15,n16]

      hmm = HMM.new
      notes.each do |note|
        hmm.add(note)
      end

      hmm.process

      puts "observation sequence\n"
      obs = notes.dup
      obs.each do |o|
        puts "#{o.data}, #{o.rel_ts}"
      end
      puts ""

      puts "states\n"
      hmm.states.each do |el|
        el.print
        puts "\n"
      end

      puts "emission probabilities\n"
      hmm.emis_pr.joints.each do |root, destns|
        puts "~#{root.data}~ => "
        destns.each do |note, pr|
          # iterate through Hash of notes=>probability
          note.print
          puts "prob = #{pr}"
        end
        puts "\n"
      end

      puts "transition probabilities\n"
      hmm.trans_pr.joints.each do |root, destns|
        puts "~#{root.data}~ => "
        destns.each do |pe, pr|
          # iterate through Hash of pelements=>probability
          pe.print
          puts "prob = #{pr}"
        end
        puts "\n"
      end

      puts "initial probabilities\n"
      hmm.init_pr.each do |el, pr|
        puts "~#{el.data}~ => #{pr}\n"
      end
      puts "\n"

      viterbi = Viterbi.new(obs,hmm)
      viterbi.robust(0.09)
      viterbi.run
      viterbi.find_path
      viterbi.print_path
      # viterbi.print_viterbi

      pi = PatternInference.new
      viterbi.path.each do |el_pr|
        el = el_pr.keys[0]
        pi.find_pattern(el)
      end

      puts "pattern after viterbi etc:"
      pi.current.elements.each do |el|
        el.print
      end
      puts "end of pattern\n"
    end
  end # class test_system
end # module SPMidi