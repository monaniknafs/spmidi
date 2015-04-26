# TODO: make methods more readable
# TODO: take logs of probabilities, I choose log10 since log10(1.0) = -1.0
# all  probability values in viterbi matrix are log10 probabilities
require_relative 'hmm'

module SPMidi
  class Viterbi
    # obs_seq is Array of Notes
    attr_reader :obs_seq, :hmm, :path, :processed, :el_path, :viterbi, :pad

    def initialize(obs, hmm)
      @hmm = hmm
      @obs_seq = obs # note array
      @viterbi = Array.new(obs.size) {Hash.new}
      @path = Array.new(obs.size) # [{element => prob}, .., ]
      @el_path = Array.new # [element_1,..,element_n]
      @processed = false
      @pad = 0.4
      @timeout_th = 5000.0
    end


    def robust(th)
      puts "original obs sequence:"
      @obs_seq.each do |n|
        puts "#{n.data[1]}, #{n.rel_ts}"
      end
      # th isn't used at the moment
      new_seq = []
      prv = nil
      for i in 0..obs_seq.size-2
        cur = PatternElement.new(obs_seq[i])
        nxt = PatternElement.new(obs_seq[i+1]) # need this for type b errors
        if prv == nil
          new_seq << obs_seq[i].dup
          prv = cur.dup
          next
        end

        @hmm.trans_pr.joints.each do |rt, dstns|
          if !rt.eql?(prv)
            next
          end
          cur_pr = @hmm.trans_pr.get_nested_destn(prv,cur)
          posn = PatternElement.new(false,cur.mean_ts)

          pr_c = 0.0
          n_c = nil
          pr_b_ins = 0.0
          pr_b_nxt = 0.0
          n_b_ins = nil 
          n_b_nxt = nil
          pr_a = 0.0
          n_a = nil # element to insert between prv and cur
          dstns.each do |d,pr|
            if pr < cur_pr + @pad
              next 
            end
            # if probability is below threshold, may have to do something
            if d.eql?(posn)
              puts "d = [#{d.data[1]},#{d.mean_ts}], posn = [*,#{posn.mean_ts}]"
              # possible Type C
              puts "oops"
              if d.data[1] == cur.data[1]
                # no error
                # this shouldn't happen by defn of cur_pr
                next
              end
                # possible type C error
                if pr > pr_c
                  puts "oops"
                  pr_c = pr
                  n_c = Note.new(d.data, 0.0, d.mean_ts) # TODO: work out the correct ts
                end
            elsif d.mean_ts < cur.mean_ts
              # possible Type B (missing note)
              ins = d
              new_cur = PatternElement.new(cur.data,cur.mean_ts - d.mean_ts)
              puts "cur = #{cur.data[1]}, #{cur.mean_ts}"
              puts "new cur = #{new_cur.data[1]}, #{new_cur.mean_ts}"
              pr_1 = pr
              pr_2 = @hmm.trans_pr.get_nested_destn(d,new_cur) # here we might be using the teleportation probability :|

              puts "pr_1 = #{pr_1}"
              puts "pr_2 = #{pr_2}"

              if pr_2 < cur_pr + @pad
                next
              end
              if pr_1 * pr_2 > pr_b_ins * pr_b_nxt
                pr_b_ins = pr_1
                pr_b_nxt = pr_2
                n_b_ins = Note.new(d.data, 0.0, d.mean_ts)
                n_b_nxt = Note.new(new_cur.data, 0.0, new_cur.mean_ts)
              end
            else # d.mean_ts < cur.mean_ts
              # possible Type A (extra note)
              # the actual current note is added..
              if pr > pr_a
                pr_a = pr
                puts "cur = #{cur.data[1]}, #{cur.mean_ts}"
                n_a = Note.new(d.data, 0.0, d.mean_ts)
              end
            end
          end
          # assess whether there is an error
          # to determine what to put in new_seq
          if pr_a + pr_b_ins + pr_b_nxt + pr_c != 0.0
            h = [{:c => pr_c}, {:b => Math.sqrt(pr_b_ins * pr_b_nxt)}, {:a => pr_a}]
            h.sort!{|x,y| x.values[0] <=> y.values[0]}
            error = h.last.keys[0]
            h.each do |er|
              p er
            end
            case error
            when :a
              # extra note to be removed
              # remake the next note using carry
              # don't add to new_seq
              puts "a"
              puts "#{cur.mean_ts}"
              carry_ts = cur.mean_ts
              obs_seq[i+1].set_rel_ts(obs_seq[i+1].rel_ts + carry_ts)
              cur = prv.dup # for updating prv in a sec
            when :b
              # missing Note to be added
              puts "b"
              puts "#{cur.mean_ts}"
              new_seq << n_b_ins.dup
              new_seq << n_b_nxt.dup
            when :c
              puts "c"
              puts "#{cur.mean_ts}"
              # pitch to be substituted
              new_seq << n_c.dup
            else
              puts "none"
              puts "#{cur.mean_ts}"
              # no error
              new_seq << obs_seq[i].dup
            end
          else
            puts "none"
            puts "#{cur.mean_ts}"
            # no error
            new_seq << obs_seq[i].dup
          end
        end
        prv = cur.dup
      end
      new_seq << obs_seq.last.dup

      @obs_seq = new_seq
      @obs_seq[0] = revise(obs_seq[0],0).dup
      @viterbi = Array.new(@obs_seq.size) {Hash.new}
      @path = Array.new(@obs_seq.size)
      puts "new robust sequence:"
      new_seq.each do |n|
        puts "#{n.data[1]}, #{n.rel_ts}"
      end

      return new_seq
    end

    def revise(note,i)
      # ASSERT note.rel_ts is greater than timeout
      if i == @obs_seq.size-2
        return note
      end
      el = PatternElement.new(note.data,false)
      nxt = PatternElement.new(@obs_seq[i+1])
      # TODO: determine if this method works with my problem
      replacements = []
      @hmm.trans_pr.joints.each do |rt, dstns|
        if rt.mean_ts == note.rel_ts
          next
        end
        if el.eql?(rt)
          dstns.each do |d, pr|
            if d.eql?(nxt)
              puts "rt rel_ts is #{rt.mean_ts}\n"
              replacements << {rt => pr}
            end
          end
        end
      end
      # sorts wrt ascending probability
      if replacements.size != 0
        replacements.sort!{|x,y| x.values[0] <=> y.values[0]}
        rvn = replacements.last.keys[0]
        new_note = Note.new(rvn.data, note.ts, rvn.mean_ts)
        return new_note
      else
        puts "unable to find replacement for first element"
        return note
      end
    end

    def run
      # v contains results of each iteration of viterbi
      # [ {l=>[k,pr],..,l=>[k,pr]} ,.., {l=>[k,pr],..,l=>[k,pr]} ]

      if @obs_seq.size == 0
        return
      end

      t = 0
      @obs_seq[0] = revise(obs_seq[0],0).dup

      # first pass
      @obs_seq.each do |obs|
        if t == 0
          @hmm.init_pr.each do |el, prob|
            # first element so nil backpointer
            pr = Math.log10(prob)
            em = Math.log10(@hmm.emis_pr.get_nested_destn(el, obs))
            @viterbi[t][el] = [nil, pr + em]
          end
        else # t != 0
          @hmm.states.each do |state|
            probs = [] # array of log10_probabilities => elements

            @viterbi[t-1].each do |el, prev|
              pr = prev[1] # already a log10 term
              tr = Math.log10(@hmm.trans_pr.get_nested_destn(el, state))
              probs << {pr + tr => el}
            end
            probs.sort!{|x,y| x.keys[0] <=> y.keys[0]}
            em = Math.log10(@hmm.emis_pr.get_nested_destn(state, obs))
            max_pr = probs.last.keys[0] + em
            max_state = probs.last.values[0] # corresponding state
            @viterbi[t][state] = [max_state, max_pr]
          end
        end
        t+=1
      end
    end

    def find_path
      puts ""
      t = @viterbi.size-1 # go backwards through the elements
      # note t is used as an index here
      prev_state = nil
      prev_pr = nil
      
      @viterbi.reverse_each do |v|
        # first find max prT
        # if we are on last element
        if t == @viterbi.size-1
          max_pr = Math.log10(0.0)
          max_state = nil

          v.each do |k, el_pr|
            state = k
            prev = el_pr[0]
            pr = el_pr[1]
            if pr > max_pr
              max_pr = pr
              max_state = state 
              prev_state = prev
              prev_pr = pr
            end
          end
          @path[t] = {max_state => max_pr}

        # then backtrack through list
        # using prev_state
        else
          corresponding_state = nil
          max_prev_state = nil
          max_prev_pr = Math.log10(0.0)
          v.each do |k, el_pr|
            #initialise max x2
            state = k
            prev = el_pr[0]
            pr = el_pr[1]
            if state.eql?(prev_state)
              if pr > max_prev_pr
                corresponding_state = state
                max_prev_state = prev
                max_prev_pr = pr
              end
            end
          end
          prev_state = max_prev_state
          @path[t] = {corresponding_state => max_prev_pr}
        end
        t-=1
      end
      @path.each do |el_pr|
        el = el_pr.keys[0]
        @el_path << el
      end
      @processed = true
    end

    def print_path
      if !@processed
        puts "viterbi algorithm hasn't run yet, run it"
        return
      else
        puts "\n~~final path~~"
        @path.each do |p|
          el = p.keys[0]
          pr = p.values[0]
          if el != nil 
            el.print
          end
          s = "%0.3f" % pr
          print "probability = #{s}\n"
        end
      end
    end

    def print_viterbi
      t = 0
      @viterbi.each do |v|
        puts ""
        puts "t=#{t}"
        v.each do |state, k_pr|
          k = k_pr[0]
          pr = k_pr[1]
          if k != nil
            puts "#{state.data} <= #{k.data}, #{pr}"
          else
            puts "#{state.data} <= nil, #{pr}"
          end
        end
        t+=1
      end
    end
  end
end