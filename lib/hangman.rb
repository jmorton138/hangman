class Game
    attr_reader :word
    attr_accessor :display
    attr_accessor :guesses
    
    # create guess countdown (number of letters in word)

    def initialize(word)
        @word = word
        @display = Array.new(@word.length, "_")
        @guesses = @display.length
    end


    def guess_countdown
        self.guesses -= 1
    end
end
#new game
def new_game
    #load dictionary from 5desk file
    lines = File.readlines('5desk.txt')
    #choose random word from dictionary and start new game\
    random_word = lines.sample.downcase.split('')
    random_word.pop(2)
    until random_word.length >= 5 && random_word.length <= 12 do
        random_word = lines.sample.downcase.split('')
        random_word.pop(2)
    end
    print random_word
    game = Game.new(random_word)
end

def game_play_flow(game)
    ## loop until out of guesses:
    while game.guesses > 0 do
        # prompt user to guess a letter
        puts "Guess a letter."
        letter = gets.chomp.to_s.downcase
        # check if letter in word
        if game.word.include?(letter)
            if game.display.include?(letter)
                puts "You already chose that one. Try again."
            else
                # put letter in the displayed array at correct position
                indexes = game.word.each_with_index.map { |v, index| v == letter ? index : nil }.compact
                indexes.each { |index| game.display[index.to_i] = letter }
                puts "Good guess! You got it right"
                #end game if solved the puzzle
                if !game.display.include?("_")
                    puts "You won!"
                    break
                end
            end  
        else
            guesses_left = game.guess_countdown
            if guesses_left == 0
                puts "Out of guesses. You lose."
                break
            else
                puts "Incorrect. You now have #{game.guesses} guesses remaining"
            end
        end
        # display progress on word e.g. h_ll_
        print game.display
        puts ""
    end
end



game = new_game
puts "\n"
game_play_flow(game)



