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

    possible_attacks = possible_moves.select do |move|
      !@board[move[1]].nil?
    end


    check_attacks = []
    checks = []
    possible_moves.each do |move|

      duped_board = @board.dup
      duped_board.move(move[0],move[1])
      
      return move if duped_board.checkmate?(:w)

      if duped_board.in_check?(:w) && possible_attacks.include?(move)
        check_attacks << move
      elsif duped_board.in_check?(:w)
        checks << move
      end
    end

    return check_attacks.sample unless check_attacks.empty?
    return possible_attacks.sample unless possible_attacks.empty?
    return checks.sample unless checks.empty?
    possible_moves.sample

  end

end
