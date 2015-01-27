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

  def initialize(grid = self.class.starting_board)
    @grid = grid
  end

  def [](pos)
    x, y = pos[0], pos[1]
    @grid[x][y]
  end

  def []=(pos, piece)
    x, y = pos[0], pos[1]
    @grid[x][y] = piece
  end

  def pieces
    @grid.flatten.select{|item| !item.nil?}
  end

  def collect_pieces(color)
    collection = []

    pieces.each do |space|
      collection << space if space.color == color
    end

    collection
  end

  def find_king(color)
    pieces.each do |piece|
      return piece if piece.color == color && piece.class == King
    end
  end

  def in_check?(color)
    opponent_color = color == :w ? :b : :w
    all_possible_moves = []

    collect_pieces(opponent_color).each do |piece|
      all_possible_moves += piece.possible_moves
    end

    all_possible_moves.include?(find_king(color).position)
  end

  def move(start, finish)
    if self[start].nil?
      raise
    else
      self[start].move(finish)
    end
  end


  def dup
    duped_board = Board.new
    pieces.each do |piece|
      piece.class.new(duped_board, piece.color, piece.position)
    end
    duped_board
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

  def possible_moves
    raise "Not yet implemented"
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
  MOVING_W = [[1,0], [2,0]]
  MOVING_B = [[-1,0],[-2,0]]
  ATTACKING_W = [[1,1],[1,-1]]
  ATTACKING_B = [[-1,1],[-1,-1]]

  def possible_moves
    possible_moves = []

    if self.color == :w
      if @position[0] == 1
        new_pos = MOVING_W[1].zip(@position).map{ |arr| arr.reduce(:+)}
        possible_moves << new_pos if @board[new_pos].nil?
      end

      new_pos = MOVING_W[0].zip(@position).map{ |arr| arr.reduce(:+)}
      possible_moves << new_pos if @board[new_pos].nil?

      ATTACKING_W.each do |move|
        new_pos = move.zip(@position).map{ |arr| arr.reduce(:+)}
        unless @board[new_pos].nil?
          possible_moves << new_pos if @board[new_pos].color == opposite
        end
      end

    else
      if @position[0] == 6
        new_pos = MOVING_B[1].zip(@position).map{ |arr| arr.reduce(:+)}
        possible_moves << new_pos if @board[new_pos].nil?
      end

      new_pos = MOVING_B[0].zip(@position).map{ |arr| arr.reduce(:+)}
      possible_moves << new_pos if @board[new_pos].nil?

      ATTACKING_B.each do |move|
        new_pos = move.zip(@position).map{ |arr| arr.reduce(:+)}
        unless @board[new_pos].nil?
          possible_moves << new_pos if @board[new_pos].color == opposite
        end
      end

    end
    possible_moves.select{|move| move.on_board?}
  end
  def move(target)
    if possible_moves.include?(target)
      @board[@position] = nil
      @position = target
      @board[@position] = self

    else
      raise
    end
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
