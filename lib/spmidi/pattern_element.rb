module SPMidi
  class PatternElement
    attr_accessor :data, :rel_ts

    def initialize(note)
      @data = note.data
      @rel_ts = note.rel_ts
    end

    def initialize(data, rel_ts)
      @data = data
      @rel_ts = rel_ts
    end
  end
end