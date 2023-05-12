require "open-uri"

class GamesController < ApplicationController
  VOWELS = %w(A E I O U Y)

  def new
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (('A'..'Z').to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    @letters = params[:letters].split
    @word = (params[:word] || "").strip.upcase
    @included = included?(@word, @letters)
    @english_word = english_word?(@word)
  end

  private

  # method checks if all the letters in a given word are present in the array of letters, and returns a Boolean value indicating whether the word can be formed from the letters or not.

  def included?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    encoded_word = URI::DEFAULT_PARSER.escape(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{encoded_word}")
    json = JSON.parse(response.read)
    json['found']
  end
end
