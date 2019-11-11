require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    alpha = ("A".."Z").to_a
    @letters = []
    10.times do
      @letters << alpha[rand(26)]
    end
  end

  def score
    letters = params[:letters]
    @word = params[:answer]
    if check_word(@word) && check_grid(@word, letters)
      @result = "congratulations! #{@word} is a good word!"
      session[:score] += @word.length
    elsif check_grid(@word, letters)
      @result = "Sorry but #{@word} does not seem to be a valid English word.."
    else
      @result = "Sorry but #{@word} can't be built out of #{letters}"
    end
    @score = session[:score]
  end

  def check_word(word)
    filepath = "https://wagon-dictionary.herokuapp.com/#{word}"
    serialized_answer = open(filepath).read
    answer_check = JSON.parse(serialized_answer)
    answer_check['found']
  end

  def check_grid(attempt, grid)
    attempt.upcase.chars.all? do |letter|
      # binding.pry
      grid.count(letter) >= attempt.upcase.count(letter)
    end
  end
end
