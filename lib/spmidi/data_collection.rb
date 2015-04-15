#!/usr/local/bin/ruby
require 'unimidi'
require_relative 'note'
require_relative 'pattern_element'
require_relative 'pattern_inference'
require_relative 'hmm'
require_relative 'viterbi'

module SPMidi
  class DataCollection
    attr_accessor :record_buffer

    def runtime
      # KORG nanoKEY2 produces notes from C_octave5 down to C_octave3
      # assuming MIDI keyboard is last input
      input = UniMIDI::Input.last

      prev_ts = 0 # use for relative timestamp
      start_ts = 0 # use to identify start of recording

      hmm = HMM.new

      # runtime behaviour
      input.open do |input|
        puts "give me some notes!"
        record = false
        record_buffer = [] # array of notes

        # blocks until input comes in
        while m = input.gets[0]
          ts = m[:timestamp]
          data = m[:data]

          note = Note.new(data, ts - start_ts, ts - prev_ts)
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

              viterbi = Viterbi.new(record_buffer,hmm)
              viterbi.robust(0.09) # adjustable variable
              # why aren't these all the same method already?
              viterbi.run
              viterbi.find_path
              viterbi.print_path

              pi = PatternInference.new
              viterbi.el_path.each do |el|
                pi.find_pattern(el)
              end

              puts "inferrred pattern:"
              pi.current.elements.each do |e|
                e.set_sp_ts
                locked = PatternElement.new(e.data,e.lock_sp_ts(1/16.0))
                locked.sp_drum_print
              end
            else
              if note.data[0] == 144
                # note.lock_rel_ts(1/8.0)
                record_buffer << note
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
  dc = DataCollection.new
  dc.runtime
end # module SPMidi