# Project: Hangman in Ruby for The Odin Project
# Author: Luján Fernaud
# URL: http://www.theodinproject.com/courses/ruby-programming/lessons/file-i-o-and-serialization

require "pry"

class Dictionary
  attr_accessor :dictionary

  def initialize(filename)
    @dictionary = []
    prepare_dictionary(filename)
  end

  def prepare_dictionary(filename)
    @dictionary = File.read(filename).gsub(/\r\n/, " ").split
    @dictionary = @dictionary.select { |word| word.length > 4 && word.length < 13 }
  end

  def sample
    @dictionary.sample
  end
end

class Player
  def input
    puts "Introduce a letter:"
    print "> "
    gets.chomp.downcase
  end
end

class Game
  attr_accessor :hidden_word
  attr_reader   :secret_word, :guesses_left, :player

  def initialize
    @dictionary       = Dictionary.new("dictionary.txt")
    @secret_word      = @dictionary.sample.split("")
    @hidden_word      = create_hidden_word
    @wrong_characters = []
    @guesses_left     = @secret_word.length
    @player           = Player.new
  end

  def start
    loop do
      begin
        print_board
        check_guess(check_input(player.input))
        player_loses if @guesses_left.zero?
      rescue Interrupt
        exit_game
      end
    end
  end

  def create_hidden_word
    @secret_word.map { |letter| "_" if letter }
  end

  def check_input(input)
    return if input.length == secret_word.length

    case input
    when "exit" then exit_game
    when "save" then save_game
    else input[0]
    end
  end

  def check_guess(input)
    if input_is_a_word(input)
      check_introduced_word(input)
    elsif character_is_in_secret_word(input)
      add_characters(input)
      player_wins if secret_word_is_equal_to(hidden_word.join)
    else
      @wrong_characters << input unless @wrong_characters.include?(input)
      @guesses_left -= 1
    end
  end

  def input_is_a_word(input)
    input.length == secret_word.length
  end

  def check_introduced_word(input)
    secret_word_is_equal_to(input) ? player_wins : player_loses
  end

  def secret_word_is_equal_to(input)
    secret_word.join("").casecmp(input).zero?
  end

  def character_is_in_secret_word(input)
    secret_word.any? { |character| character.casecmp(input).zero? }
  end

  def add_characters(input)
    indexes = secret_word.map
                         .with_index { |char, idx| idx if char == input }
                         .compact

    indexes.each { |index| hidden_word[index] = input }
  end

  def print_board
    clear_screen
    print_guesses
    empty_line
    print_hidden_word
    empty_line
  end

  def clear_screen
    system "clear" || "cls"
  end

  def empty_line
    puts "\n"
  end

  def print_guesses
    puts "Guesses left: #{@guesses_left}"
  end

  def print_hidden_word
    puts hidden_word.join(" ")
  end

  def print_wrong_characters
    puts "Wrong characters: #{@wrong_characters.join(" ")}"
  end

  def player_wins
    print_board
    puts "You WIN!\n\n"
    puts "The correct word was: #{secret_word.join}\n\n"
    exit
  end

  def player_loses
    print_board
    puts "You lose.\n\n"
    puts "The correct word was: #{secret_word.join}\n\n"
    exit
  end

  def save_game
    # Add logic to save game.
    puts "Something is going to happen here."
  end

  def exit_game
    clear_screen
    puts "Thanks for playing. Hope you liked it!\n\n"
    exit
  end
end

Game.new.start
