require 'unimidi'
require_relative 'note'

module SPMidi
  class DrumCollection
    def runtime
      input = UniMIDI::Input.last

      prev_ts = 0 # use for relative timestamp
      start_ts = 0 # use to identify start of recording

      # runtime behaviour
      input.open do |input|
        puts "give me some notes!"
        record = false
        record_buffer = []

        # blocks until input comes in
        while m = input.gets[0]
          ts = m[:timestamp]
          data = m[:data]
          if data == [254]
            next
          end

          note = Note.new(data, ts - start_ts, ts - prev_ts)
          prev_ts = ts

          # beat_analysis section
          # quit note is pitch As5, [_,70,_]
          # if note.data[1] == 70 && note.data[0] == 144
          #   record_buffer.each {|x| puts x.rel_ts}
          #   return record_buffer
          # end

          # need to work out record button
          if record
            if note.data == [176,64,0]
              record = false
              start_ts = ts
              puts "stopped recording"
              record_buffer.each {|x| x.sp_letter_print}
            else
              if note.data[0] == 144
                note.lock_rel_ts(1/8.0)
                record_buffer << note
              end
            end
          else
            # not recording
            # print only the on-notes
            if note.data[0] == 153
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
    end
  end
  d = DrumCollection.new
  d.runtime
end