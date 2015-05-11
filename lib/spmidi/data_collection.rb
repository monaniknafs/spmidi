#!/usr/local/bin/ruby
require 'unimidi'
require_relative 'note'
require_relative 'pattern_element'
require_relative 'pattern_inference'
require_relative 'hmm'
require_relative 'viterbi'
require_relative 'sp_element'

module SPMidi
  class DataCollection
    attr_accessor :record_buffer, :incr
    def initialize
      @incr = 1.0/8 # must be Float
    end

    def runtime
      # KORG nanoKEY2 produces notes from C_octave5 down to C_octave3
      # assuming MIDI keyboard is last input
      input = UniMIDI::Input.last

      prev_ts = 0 # use for relative timestamp
      start_ts = 0 # use to identify start of recording

      hmm = HMM.new
      first = nil

      # runtime behaviour
      input.open do |input|
        puts "give me some notes!"
        record = false
        record_buffer = [] # array of notes

        # blocks until input comes in
        while m = input.gets[0]
          ts = m[:timestamp]
          data = m[:data]

          rel_ts = ts - prev_ts
          note = Note.new(data, ts - start_ts, rel_ts)
          prev_ts = ts

          # remove after beat_analysis complete
          # quit note is pitch As5, [_,70,_]
          # if note.data[1] == 70 && note.data[0] == 144
          #   record_buffer.each {|x| puts x.rel_ts}
          #   return record_buffer
          # end

          if record
            if note.data == [176,64,0]
              record = false
              start_ts = ts
              puts "stopped recording"

              hmm.process
              hmm.print_probabilities

              viterbi = Viterbi.new(record_buffer,hmm)
              viterbi.robust
              # # why aren't these all the same method already?
              viterbi.run
              viterbi.find_path
              viterbi.print_path

              pi = PatternInference.new
              viterbi.obs_seq.each do |obs|
                el = PatternElement.new(obs)
                pi.find_pattern(el)
              end

              ### uncomment for loop detection
              ## Uncomment for normal output (1/3)
              puts "inferrred pattern:"

              # prepare sp_loop for presentation
              cum_ts = 0.0
              sp_loop = []
              best = pi.best_pattern
              best.elements.each do |e|
                sp_ts = e.sp_ts(@incr)
                s = SPElement.new({
                  :pitch => e.data[1], 
                  :ts => cum_ts, 
                  :rel_ts => sp_ts})
                sp_loop << s
                ## Uncomment for normal output (2/3)
                s.sp_print
                cum_ts += sp_ts
              end

              ## Uncomment for user test output
              # return sp_loop
            else
              if note.data[0] == 144
                # if first == nil
                #   first = note
                # else
                #   if note.data[1] == first.data[1]
                #     first.set_rel_ts(note.rel_ts)
                #     record_buffer[0] = first.dup
                #   end
                # end

                record_buffer << note
                note.print
                hmm.add(note)
              end
            end
          else
            # not recording
            # print only the on-notes
            if note.data[0] == 144
              note.sp_letter_print
            end
          end

          # initialise recording if applicable
          # sustain button on korg nanokey2 for on/off
          if note.data == [176,64,127] # on-value as specified by keyboard
            record = true
            record_buffer = []
            start_ts = ts
            puts "started recording"
          end
        end
      end
    end # def runtime
  end # class DataCollection

  ## Uncomment for normal output (3/3)
  dc = DataCollection.new
  dc.runtime
  
end # module SPMidi