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

  def possible_moves
    raise NotImplementedError
  end

  def render
    raise NotImplementedError
  end



  def valid_moves
    possible_moves.select{|move| !move_into_check?(move)}
  end

  def move_into_check?(pos)
    duped_board = @board.dup
    duped_board.move(@position,pos)
    duped_board.in_check?(@color)

  end
end
