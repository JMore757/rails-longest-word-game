require "open-uri"
require "json"

class GamesController < ApplicationController
  def new
    rand_letters = ('a'..'z').to_a
    @letters = Array.new(10) { rand_letters.sample }
  end

  def score
    @word = params[:word].downcase
    @grid = params[:grid].downcase

    # Check whether the word can be built from the grid
    word_letters = @word.chars
    grid_letters = @grid.chars

    if word_letters.tally.all? { |letter, count| grid_letters.tally.fetch(letter, 0) >= count }

      # Check whether the word is a valid English word
      url = "https://dictionary.lewagon.com/#{@word}"
      response = URI.open(url).read
      result = JSON.parse(response)

      if result["found"]
        @message = "Congratulations! #{@word} is a valid English word!"
      else
        @message = "Sorry, #{@word} is not an English word."
      end

    else
      @message = "Sorry, #{@word} can't be built out of #{@grid}."
    end
  end
end
