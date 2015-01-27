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



end

class Pieces

  def initialize(board, color, position)
    @board = board
    @color = color
    @position = position
  end

  def move
    raise NotImplementedError
  end

end

class SlidingPieces < Pieces

  def move(target)
    @board[@position] = nil
    @position = target
    @board[@position] = self
  end


end

class SteppingPieces < Pieces

  def move(target)
    @board[@position] = nil
    @position = target
    @board[@position] = self
  end

end

class Pawn < Pieces

  def move(target)
    @board[@position] = nil
    @position = target
    @board[@position] = self
  end

end
