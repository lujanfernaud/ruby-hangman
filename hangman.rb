# Project: Hangman in Ruby for The Odin Project
# Author: Luján Fernaud
# URL: http://www.theodinproject.com/courses/ruby-programming/lessons/file-i-o-and-serialization

require 'pry'

class Dictionary
  attr_accessor :dictionary

  def initialize(filename)
    @dictionary = []
    prepare_dictionary(filename)
  end

  def prepare_dictionary(filename)
    @dictionary = File.read(filename).gsub(/\r\n/, ' ').split
    @dictionary = @dictionary.select { |word| word.length > 4 && word.length < 13 }
  end

  def sample
    @dictionary.sample
  end
end

class Player
end

class Game
  attr_reader :secret_word, :guesses

  def initialize
    @dictionary  = Dictionary.new('dictionary.txt')
    @secret_word = @dictionary.sample
    @guesses     = @secret_word.length
    @player      = Player.new
  end

  def setup
  end

  def start
    puts secret_word
    puts guesses
  end
end

Game.new.start
