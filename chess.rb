#!/usr/bin/env ruby

require_relative 'lib/board'
require_relative 'lib/pieces/piece'
require_relative 'lib/pieces/sliding_piece'
require_relative 'lib/pieces/stepping_piece'
require_relative 'lib/pieces/bishop'
require_relative 'lib/pieces/king'
require_relative 'lib/pieces/knight'
require_relative 'lib/pieces/pawn'
require_relative 'lib/pieces/rook'
require_relative 'lib/pieces/queen'
require_relative 'lib/computer_player'
require_relative 'lib/human_player'
require_relative 'lib/game'
require 'colorize'

DELTAS_ALL = {
  :row_col => [
    [1,0],
    [-1,0],
    [0,1],
    [0,-1]
  ],
  :diag    => [
    [1,1],
    [-1,1],
    [1,-1],
    [-1,-1]
  ],
  :knights => [
    [1,2],
    [1,-2],
    [2,1],
    [2,-1],
    [-1,2],
    [-1,-2],
    [-2,1],
    [-2,-1]
  ]
}

class Array

  def on_board?

    self.all? {|el| el.between?(0,7)}

  end

end

if __FILE__ == $PROGRAM_NAME

  puts "Would you like to play against a computer? Y or N?"
  response = gets.chomp.upcase
  if response == "Y"
    player2 = :computer
  else
    player2 = :human
  end

  game = Game.new(player2)
  game.play


end
