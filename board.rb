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
    pawn_promotion
  end

  def pawn_promotion
    pawn_promoted = false
    2.times do |i|
      8.times do |j|
        potential_pawn = self[[i*7,j]]
        if potential_pawn.class == Pawn
          self[[i*7,j]] = Queen.new(self, potential_pawn.color, [i*7,j])
          pawn_promoted = true
        end
      end
    end
    if pawn_promoted
      puts "A pawn is now a Queen!"
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
    system("clear")
    background = :light_green
    print "   a  b  c  d  e  f  g  h\n"

    @grid.each_with_index do |r, i|
      background = background == :light_green ? :light_red : :light_green
      print"#{i+1} "
      r.each do |el|
        background = background == :light_green ? :light_red : :light_green
        if el.nil?
          print "   ".colorize(:background => background)
        else
          print" #{el.render} ".colorize(:background => background)
        end
      end
      puts
    end
    nil
  end

end
