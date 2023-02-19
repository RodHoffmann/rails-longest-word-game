require 'open-uri'

class GamesController < ApplicationController
  def new
    @random_letters = (0..7).map { ('A'..'Z').to_a[rand(26)] }
  end

  def score
    @grid_letters = params[:token].split('')
    @answer = params[:answer]
    word_in_dict = word_is_in_dict?
    word_in_grid = false
    @ans = ''
    @index = 0
    check_answer
    check_word(word_in_dict, word_in_grid)
  end

  private

  def check_word(word_in_dict, word_in_grid)
    word_in_grid = true if @index == @answer.length
    if word_in_dict && word_in_grid
      @ans = 'correct'
    elsif word_in_grid == false
      @ans = 'not in grid'
    elsif word_in_dict == false
      @ans = 'not in dict'
    end
  end

  def word_is_in_dict?
    word_serialized = URI.open("https://wagon-dictionary.herokuapp.com/#{@answer.downcase}").read
    JSON.parse(word_serialized)['found']
  end

  def check_answer
    @answer.upcase.chars.each do |letter|
      @index += 1 if @grid_letters.include?(letter)
    end
  end
end
