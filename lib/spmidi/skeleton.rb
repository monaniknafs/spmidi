require 'set'
require_relative 'pattern_element'

module SPMidi
  class Skeleton
    @prev_el
    @skeleton # Hash of elements of form.. see below
    # set of hash elements
    # each element of form {pattern_element => goes_to_set}
    # i call this a joint :/
    attr_reader :skeleton

    def initialize
      @skeleton = Hash.new
      @prev_el = nil
    end

    def add(note)
      # notes are internally changed to pattern element bigrams
      # represent bigrams implictly, 
      # as Hash element {..,pattern_element => to_pointers_set,..}
      pe = PatternElement.new(note)
      if @prev_el == nil # this should only happen on first call to function
        @prev_el = pe # do i need to dup? i wouldn't think so..
      else
        el = @prev_el.dup
        # new bigram, possibly merged in next step
        joint = {el => [pe].to_set}
        @prev_el = pe
        # TODO make sure overridden pattern_element equality function is used
        print "joint\n#{joint}\n"

        # aren't being merged properly

        # POSSIBLY FAILING merging method
        s = @skeleton.merge(joint){|key,oldval,newval| oldval.merge(newval)}
        @skeleton = s
        print "skeleton\n#{@skeleton}\n"
        print "skeleton size #{@skeleton.size}\n"
        print "end\n"
      end
    end
  end
end