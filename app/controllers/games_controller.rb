class GamesController < ApplicationController
  attr_accessor :letters, :initial_letters
  require 'open-uri'

  def home

  end

  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @answer = params[:answer]
    @initial_letters = params[:initial_letters]
    # raise
    # binding.pry
    @included = included?(@answer, @initial_letters)
    @english_word = english_word?(@answer)
    @result = result(@answer)
  end

  # private

  # VERIFICATION METHODS
  def included?(answer, initial_letters)
    # answer.chars.all? { |letter| answer.count(letter) <= initial_letters.count(letter) }
    answer.chars.all? { |letter| initial_letters.include?(letter) }
  end

  # English words
  def english_word?(answer)
    response = URI.open("https://wagon-dictionary.herokuapp.com/:#{answer}")
    json = JSON.parse(response.read)
    json['found']
  end

  def result(answer)
    #  Word is valid + English word
    if @included || @english_word
      "<p><strong>Congratulations!</strong>#{answer} is a valid English word and in scope!</p>"
      #  Word is valid (in grid) but not English word
    elsif @included || !@english_word
      "<p>Sorry, but <strong>#{answer}!</strong> is not a English word.</p>"
    elsif !@included || @english_word
      "<p>Sorry, but <strong>#{answer}</strong> is not within the grid's scope #{@initial_letters}.</p>"
    end
  end

end
