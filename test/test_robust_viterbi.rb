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

      notes_real = [
      Note.new([144, 59, 73], 0.1, 2497.0879554748535),
      Note.new([144, 62, 64], 0.1, 225.04377365112305),
      Note.new([144, 64, 67], 0.1, 246.0780143737793),
      Note.new([144, 65, 64], 0.1, 183.44688415527344),
      Note.new([144, 59, 73], 0.1, 178.0099868774414),
      Note.new([144, 62, 67], 0.1, 174.01480674743652),
      Note.new([144, 64, 61], 0.1, 222.97000885009766),
      Note.new([144, 65, 69], 0.1, 191.90406799316406),
      Note.new([144, 59, 67], 0.1, 197.45588302612305),
      Note.new([144, 62, 66], 0.1, 158.56313705444336),
      Note.new([144, 64, 65], 0.1, 231.77480697631836),
      Note.new([144, 65, 52], 0.1, 211.52520179748535),
      Note.new([144, 59, 61], 0.1, 158.40888023376465),
      Note.new([144, 62, 64], 0.1, 224.5461940765381),
      Note.new([144, 64, 58], 0.1, 218.4748649597168),
      Note.new([144, 65, 64], 0.1, 189.4831657409668),
      Note.new([144, 59, 65], 0.1, 206.4361572265625),
      Note.new([144, 62, 62], 0.1, 224.05099868774414),
      Note.new([144, 64, 68], 0.1, 207.5800895690918),
      Note.new([144, 65, 60], 0.1, 219.43306922912598),
      Note.new([144, 59, 63], 0.1, 172.61004447937012),
      Note.new([144, 62, 63], 0.1, 276.0279178619385),
      Note.new([144, 64, 64], 0.1, 224.43485260009766),
      Note.new([144, 65, 68], 0.1, 200.9291648864746),
      Note.new([144, 59, 72], 0.1, 195.56188583374023),
      Note.new([144, 62, 63], 0.1, 184.01479721069336),
      Note.new([144, 64, 66], 0.1, 204.4541835784912),
      Note.new([144, 65, 70], 0.1, 201.49993896484375),
      Note.new([144, 59, 60], 0.1, 235.95595359802246),
      Note.new([144, 62, 64], 0.1, 185.57000160217285),
      Note.new([144, 64, 71], 0.1, 227.47087478637695),
      Note.new([144, 65, 68], 0.1, 211.90810203552246),
      Note.new([144, 59, 61], 0.1, 237.37382888793945),
      Note.new([144, 62, 59], 0.1, 131.48021697998047),
      Note.new([144, 64, 70], 0.1, 239.04109001159668),
      Note.new([144, 65, 65], 0.1, 220.44610977172852),
      Note.new([144, 59, 61], 0.1, 219.96498107910156),
      Note.new([144, 62, 64], 0.1, 117.3560619354248),
      Note.new([144, 64, 64], 0.1, 204.53619956970215),
      Note.new([144, 65, 66], 0.1, 178.43890190124512),
      Note.new([144, 59, 60], 0.1, 185.4252815246582),
      Note.new([144, 62, 64], 0.1, 141.98994636535645),
      Note.new([144, 64, 69], 0.1, 228.49702835083008),
      Note.new([144, 65, 54], 0.1, 207.94200897216797)]

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

      new_seq_a = vit_a.robust
      new_seq_a.each do |n|
        puts "data: #{n.data[1]}, rel_ts: #{n.rel_ts}"
      end

      new_seq_b = vit_b.robust
      new_seq_b.each do |n|
        puts "data: #{n.data[1]}, rel_ts: #{n.rel_ts}"
      end

      new_seq_c = vit_c.robust
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


      hmm_real = HMM.new
      hmm_real.add_notes(notes_real)
      hmm_real.process
      hmm_real.print_probabilities
      vit_real = Viterbi.new(notes_real, hmm_real)

      new_seq_real = vit_real.robust
      new_seq_real.each do |n|
        puts "data: #{n.data[1]}, rel_ts: #{n.rel_ts}"
      end

    end
  end
end