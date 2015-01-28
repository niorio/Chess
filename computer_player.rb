class ComputerPlayer

  attr_reader :color

  def initialize(board)
    @color = :b
    @board = board
  end

  def play_turn
    possible_moves = []

    @board.collect_pieces(color).each do |piece|
      piece.valid_moves.each {|move| possible_moves << [piece.position, move] }
    end

    possible_moves.sample
  end

end
