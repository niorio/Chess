require_relative 'board'
require_relative 'piece'
require_relative 'sliding_piece'
require_relative 'stepping_piece'
require_relative 'bishop'
require_relative 'king'
require_relative 'knight'
require_relative 'pawn'
require_relative 'rook'
require_relative 'queen'
require_relative 'computer_player'
require_relative 'human_player'
require_relative 'game'
require 'byebug'
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
