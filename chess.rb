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

  def checkmate?(color)
    if in_check?(color)
      collect_pieces(color).all?{ |piece| piece.valid_moves.empty?}
    else
      false
    end
  end

  def display
    col = {:w => "w", :b =>"b"}
    type = { King => "K", Pawn =>"P", Rook =>"R", Knight =>"H", Bishop =>"B", Queen => "Q"}


    print "  0  1  2  3  4  5  6  7\n"
    @grid.each_with_index do |r, i|
      print"#{i} "
      r.each do |el|
        if el.nil?
          print "__ "
        else
          print"#{col[el.color]}#{type[el.class]} "
        end
      end
      puts
    end
    nil
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


class Game

  def initialize
    @board = Board.new
    8.times do |i|
      Pawn.new(@board, :w, [1,i])
    end

    Rook.new(@board, :w, [0,7])
    Rook.new(@board, :w, [0,0])
    Knight.new(@board, :w, [0,6])
    Knight.new(@board, :w, [0,1])
    Bishop.new(@board, :w, [0,2])
    Bishop.new(@board, :w, [0,5])
    King.new(@board, :w, [0,3])
    Queen.new(@board, :w, [0,4])

    8.times do |i|
      Pawn.new(@board, :b, [6,i])
    end

    Rook.new(@board, :b, [7,7])
    Rook.new(@board, :b, [7,0])
    Knight.new(@board, :b, [7,6])
    Knight.new(@board, :b, [7,1])
    Bishop.new(@board, :b, [7,2])
    Bishop.new(@board, :b, [7,5])
    King.new(@board, :b, [7,3])
    Queen.new(@board, :b, [7,4])


    @player1 = HumanPlayer.new(:w)
    @player2 = HumanPlayer.new(:b)

  end

  def play
    player = @player1
    until @board.checkmate?(:w) || @board.checkmate?(:b)
    begin
      @board.display
      positions = player.play_turn
      raise "Not correct starting piece" if @board[positions.first].color != player.color

      @board.move(positions.first, positions.last)
      player = player == @player1 ? @player2 : @player1
    rescue
      retry
    end
    end
    @board.display

  end



end

class HumanPlayer
  attr_reader :color
  def initialize(color)
    @color = color
  end

  def play_turn

    print "Please choose a piece by its location: "
    start = gets.chomp.split("").map(&:to_i)
    print "Please choose an end point by its location: "
    final = gets.chomp.split("").map(&:to_i)
    [start,final]

  end


end
