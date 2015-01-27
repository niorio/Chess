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

class Board

  def self.starting_board
    Array.new(8) { Array.new(8) }
  end

  def initialize
    @grid = self.class.starting_board
  end

  def [](pos)
    x, y = pos[0], pos[1]
    @grid[x][y]
  end

  def []=(pos, piece)
    x, y = pos[0], pos[1]
    @grid[x][y] = piece
  end



end

class Piece
  attr_reader :color, :position

  def opposite
    @color == :w ? :b : :w
  end

  def initialize(board, color, position)
    @board = board
    @color = color
    @position = position
    @board[position] = self
  end

  def move(target)
    if possible?(target) && possible_moves.include?(target)
      @board[@position] = nil
      @position = target
      @board[@position] = self

    else
      raise
    end
  end

  def possible?(pos)
    pos.on_board? && (@board[pos].nil? || @board[pos].color == opposite)
  end

end

class SlidingPiece < Piece

  def possible_moves(deltas)
    possible_moves = []

    deltas.each do |delta|
      new_pos = @position
      available = true

      while available
        new_pos = delta.zip(new_pos).map{ |arr| arr.reduce(:+)}
        if possible?(new_pos)
          possible_moves << new_pos
          if @board[new_pos].nil?
          elsif @board[new_pos].color == opposite
            available = false
          end
        else
          available = false
        end
      end
    end
    possible_moves

  end


end

class SteppingPiece < Piece

  def possible_moves(deltas)
    possible_moves =[]

    deltas.each do |delta|
      new_pos = delta.zip(@position).map{ |arr| arr.reduce(:+)}
      possible_moves << new_pos if possible?(new_pos)
    end
    possible_moves
  end

end

class Pawn < Piece

  def move(target)
    @board[@position] = nil
    @position = target
    @board[@position] = self
  end

  def crazy
  end

end

class Rook < SlidingPiece

  #@delta = DELTAS_ALL[:row_col]


  def possible_moves
    super(DELTAS_ALL[:row_col])
  end


end

class Bishop < SlidingPiece

  def possible_moves
    super(DELTAS_ALL[:diag])
  end


end

class Queen < SlidingPiece

  def possible_moves
    super(DELTAS_ALL[:diag] + DELTAS_ALL[:row_col])
  end



end

class King < SteppingPiece

  def possible_moves
    super(DELTAS_ALL[:diag] + DELTAS_ALL[:row_col])
  end




end

class Knight < SteppingPiece

  def possible_moves
    super(DELTAS_ALL[:knights])
  end


end
