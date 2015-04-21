require_relative 'data_collection'
require_relative 'levenshtein'

module SPMidi
  class UserTest
    attr_accessor :name, :index
    @compliment_array = # TODO
    @seq_array = # TODO
    def initialize
      @index = 0
      @incr = 1.0/16
    end
    puts "Welcome, press any key to continue"
    text = gets.chomp.to_s # blocks until input
    puts = "You will be asked to input a repeated note loop ..."
    puts "Press any key to continue"
    text = gets.chomp.to_s
    puts "\nPlease ask your gorgeous assistant to play you the first note loop"
    puts "Press any key to continue"
    text = gets.chomp.to_s
    puts "\nNow, as we discussed, input this note loop (determine through testing) times"
    puts "Press any key to continue"
    end

    lev = Levenshtein.new(@incr)
    while true      
      puts "\nPlease ask your #{compliment_array.shuffle!.first} assistant to play you the next note loop"
      puts "Input this note loop (determine through testing) times"
      puts "Press any key to continue"
      text = gets.chomp.to_s
      puts "\nReady for input, begin when ready..."

      d = DataCollection.new(@incr)
      sp_loop = d.runtime
      actual_loop = @seq_array[@index]

      $stdout.write("press any key to save, or q to discard\n")
      text = gets.chomp.to_s # blocks until input
      if text != 'q'
        # TODO
        # compute the lev distance
        # save the chosen pattern
        # save the user output
        # save the lev distance
        distance = lev.distance(sp_loop, actual_loop)
        accuracy = Float(lev_distance) / (sp_loop.size + actual_loop.size)

        # write test results to file
        pathname = "#{@name}/test#{@index}"
        f = File.new(pathname,'w+')
        File.open(pathname, 'w') do |f|
          f.write("inferred sequence:\n")
          sp_loop.each do |x| 
            f.write(x.sp_string) # prev f.write("#{x.to_s}")
          end
          f.write("\nactual sequence:\n")
          actual_loop.each do |x| 
            f.write(x.sp_string)
          end
          f.write("\ndistance: #{distance}\n")
          f.write("\naccuracy:#{accuracy}\n")
        end
        puts "well done you"
        @index+=1
      end
    end
  end
end