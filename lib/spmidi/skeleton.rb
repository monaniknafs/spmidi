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
        @prev_el = pe.dup # do i need to dup? i wouldn't think so..
      else
        el = @prev_el.dup
        @prev_el = pe.dup # next method call's bigram head

        s = Hash.new
        merged = false
        @skeleton.each do |key, val|
          if key == el
            s[key] = val.merge([pe].to_set)
            merged = true
          else 
            s[key] = val
          end
        end
        if !merged
          s[el] = [pe].to_set
        end
        @skeleton = s
      end
    end
  end
end