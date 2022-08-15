# frozen_string_literal: true

require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid = []
    10.times do
      @grid << ('A'..'Z').to_a.sample
    end
  end

  def score
    @attempt = params[:attempt].upcase
    @grid = params[:grid].delete(' ').chars
    @result = "Congratulations! #{@attempt} is a valid English word!"
    @result = "Sorry but #{@attempt} does not seem to be a valid English word" unless dictionary_valid?(@attempt)
    @result = "Sorry but #{@attempt} can't be build out of #{@grid.join(', ')}..." unless grid_valid?(@attempt, @grid)
  end

  private

  def grid_valid?(attempt, grid)
    attempt.chars.each do |char|
      return false unless grid.include?(char)

      grid.delete_at(grid.find_index(char))
    end
    return true
  end

  def dictionary_valid?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    word = JSON.parse(URI.open(url).read)
    return word['found']
  end

end
