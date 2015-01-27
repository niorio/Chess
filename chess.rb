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

class Pieces

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
    if @board[target].nil? || @board[target].color == opposite
      @board[@position] = nil
      @position = target
      @board[@position] = self

    else
      raise
    end
  end

end

class SlidingPieces < Pieces

  def possible_moves(deltas)
    possible_moves = []

    deltas.each do |delta|
      new_pos = @position
      available? = true

      while available?
      new_pos = delta.zip(new_pos).reduce(:+)
      if new_pos.on_board? && (@board[new_pos].nil? || @board[new_pos].color == opposite)
        possible_moves << new_pos
        if @board[new_pos].color == opposite
          available? = false
        end
      else
        available? = false
      end



end

class SteppingPieces < Pieces

  def move(target)
    super
  end

end

class Pawn < Pieces

  def move(target)
    @board[@position] = nil
    @position = target
    @board[@position] = self
  end

  def crazy
  end

end

class Rook < SlidingPieces

  def move(target)

  end

end
