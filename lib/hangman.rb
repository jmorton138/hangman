require 'yaml'

class Game
    attr_reader :word
    attr_accessor :display
    attr_accessor :guesses
    attr_accessor :incorrect_guesses
    
    # create guess countdown (number of letters in word)

    def initialize(word, display = Array.new(word.length, "_"), guesses = display.length, incorrect_guesses=[])
        @word = word
        @display = display
        @guesses = guesses
        @incorrect_guesses = incorrect_guesses
    end


    def guess_countdown
        self.guesses -= 1
    end

    def to_yaml
        YAML.dump ({
            :word => @word,
            :display => @display,
            :guesses => @guesses,
            :incorrect_guesses => incorrect_guesses
        })
    end

    def self.from_yaml(string)
        data = YAML.load string
        data
        self.new(data[:word], data[:display], data[:guesses], data[:incorrect_guesses])
    end
end

def load_files_names
    files = []
    Dir.foreach("./") do |file| 
        if file.include?(".txt")
            files.push(file.chomp(".txt")) unless file == "5desk.txt"  
        end
    end
    files
end

def save_game(game, username)
    #create file
    fname = "#{username}.txt"
    file = File.open(fname, "w")
    #serialize game and write to file
    file.puts game.to_yaml
    file.close
end

def choose_file
    puts "Enter file to load."
    puts "Current files:"
    puts load_files_names
    username = gets.chomp.to_s
    
end

def load_game(username)
    begin
        file = File.open("#{username}.txt", "r")
        Game.from_yaml(file)
    rescue Errno::ENOENT
        puts "File doesn't exist. Please enter an existing file name."
        load_game(choose_file)
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
    game = Game.new(random_word)
end

def game_play_flow(game)
    puts "Your hangman word is:"
    game.display.each {|v| print v + " "}
    puts "\n"
    ## loop until out of guesses:
    while game.guesses > 0 do
        puts "Incorrect guesses: "
        game.incorrect_guesses.each {|letter| print letter + " "}
        puts "\n"
        puts "Enter a letter or type 'save' to save game"
        letter = gets.chomp.to_s.downcase
        if letter == 'save'
            puts "Please enter username to save game under"
            username = gets.chomp.to_s
            save_game(game, username)
            puts "Game saved"
            break
        end
        # check if letter in word
        if game.word.include?(letter)
            if game.display.include?(letter)
                puts "You already chose that one. Try again."
            else
                # put letter in the displayed array at correct position
                indexes = game.word.each_with_index.map { |v, index| v == letter ? index : nil }.compact
                indexes.each { |index| game.display[index.to_i] = letter }
                #end game if solved the puzzle
                if !game.display.include?("_")
                    puts "You won!"
                    break
                end
                puts "Good guess! You got it right."
            end  
        else
            guesses_left = game.guess_countdown
            if guesses_left == 0
                puts "Out of guesses. You lose."
                puts "The word was:"
                game.word.each {|v| print v}
                puts "\n"
                break
            else
                puts "Incorrect. You now have #{game.guesses} guesses remaining"
                if !game.incorrect_guesses.include?(letter)
                    game.incorrect_guesses.push(letter)
                end
            end
        end
        # display progress on word e.g. h_ll_
        game.display.each {|v| print v + " "}
        puts ""
    end
end




puts "Press 1 to start new game. Press 2 to load saved game"
menu_option = gets.chomp.to_i
if menu_option == 1
    game = new_game
elsif menu_option == 2
    #choose_file
    game = load_game(choose_file)
else
    puts "Invalid option. Starting new game.."
    game = new_game
end

puts "\n"
game_play_flow(game)






