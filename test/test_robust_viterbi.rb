require 'test/unit'

require_relative '../lib/spmidi/viterbi'

module SPMidi
  class Test_Robust_Viterbi < Test::Unit::TestCase
    # make observation sequence
    # make hidden markov model based on observation sequence
    # test the type a, b, c errors are identified and removed,
    # each one seperately
    # TODO i need a null hypothesis
    def test_type_a_b_c
      m = Note.new([0,2,0],0.5,40.0)
      n = Note.new([0,3,0],1.5,500.0)
      o = Note.new([0,4,0],2.5,300.0)
      p = Note.new([0,5,0],3.5,150.0)
      q = Note.new([0,6,0],4.5,60.0)

      e_a = Note.new([0,33,0],1.25,50.0)
      n_a = Note.new([0,3,0],1.5,450.0)
      p_b = Note.new([0,5,0],3.5,450.0)
      p_c = Note.new([0,9,0],3.5,150.0)

      hyp = [m,n,o,p,q, m,n,o,p,q, m,n,o,p,q, m,n,o,p,q, m,n,o,p,q, m,n,o,p,q, m,n,o,p,q, m,n,o,p,q]
      notes_a = [m,n,o,p,q, m,n,o,p,q, m,n,o,p,q, m,n,o,p,q, m,n,o,p,q, m,e_a,n_a,o,p,q, m,n,o,p,q, m,n,o,p,q]
      notes_b = [m,n,o,p,q, m,n,o,p,q, m,n  ,p_b,q, m,n,o,p,q, m,n,o,p,q, m,n,o,p,q, m,n,o,p,q, m,n,o,p,q]
      notes_c = [m,n,o,p,q, m,n,o,p,q, m,n,o,p_c,q, m,n,o,p,q, m,n,o,p,q, m,n,o,p,q, m,n,o,p,q, m,n,o,p,q]

      hmm_a = HMM.new
      hmm_a.add_notes(notes_a)
      hmm_a.process
      hmm_b = HMM.new
      hmm_b.add_notes(notes_b)
      hmm_b.process
      hmm_c = HMM.new
      hmm_c.add_notes(notes_c)
      hmm_c.process

      vit_a = Viterbi.new(notes_a, hmm_a)
      vit_b = Viterbi.new(notes_b, hmm_b)
      vit_c = Viterbi.new(notes_c, hmm_c)

      # puts "emission probabilities\n"
      # hmm_b.emis_pr.joints.each do |root, destns|
      #   puts "#{root.print} => "
      #   destns.each do |note, pr|
      #     # iterate through Hash of notes=>probability
      #     note.print
      #     puts "prob = #{pr}"
      #   end
      #   puts "\n"
      # end

      # puts "transition probabilities\n"
      # hmm_b.trans_pr.joints.each do |root, destns|
      #   puts "#{root.print} => "
      #   destns.each do |pe, pr|
      #     # iterate through Hash of pelements=>probability
      #     pe.print
      #     puts "prob = #{pr}"
      #   end
      #   puts "\n"
      # end

      # puts "initial probabilities\n"
      # hmm_b.init_pr.each do |el, pr|
      #   puts "#{el.print} => #{pr}\n"
      # end

      new_seq_a = vit_a.robust(0.3)
      new_seq_a.each do |n|
        puts "data: #{n.data[1]}, rel_ts: #{n.rel_ts}"
      end

      new_seq_b = vit_b.robust(0.3)
      new_seq_b.each do |n|
        puts "data: #{n.data[1]}, rel_ts: #{n.rel_ts}"
      end

      new_seq_c = vit_c.robust(0.3)
      new_seq_c.each do |n|
        puts "data: #{n.data[1]}, rel_ts: #{n.rel_ts}"
      end

      for i in 0..new_seq_a.size-1 
        assert_equal(hyp[i].data[1], new_seq_a[i].data[1])
        assert_equal(hyp[i].rel_ts, new_seq_a[i].rel_ts)
      end

      for i in 0..new_seq_c.size-1 
        assert_equal(hyp[i].data[1], new_seq_b[i].data[1])
        assert_equal(hyp[i].rel_ts, new_seq_b[i].rel_ts)
      end

      for i in 0..new_seq_c.size-1 
        assert_equal(hyp[i].data[1], new_seq_c[i].data[1])
        assert_equal(hyp[i].rel_ts, new_seq_c[i].rel_ts)
      end
    end
  end
end