class ComputerPlayer

  attr_reader :color

  def initialize(board)
    @color = :b
    @board = board
  end

  def play_turn
    @possible = possible_moves

    return checkmate_move unless checkmate_move.nil?
    return check_moves.sample unless check_moves.empty?
    return good_trade.sample unless good_trade.empty?
    return safe_moves.sample unless safe_moves.empty?
    return attack_moves.sample unless attack_moves.empty?

    @possible.sample

  end

  def check_moves
    check_moves = []
    @possible.each do |move|
      duped_board = @board.dup
      duped_board.move(move[0],move[1])
      if duped_board.in_check?(:w)
        check_moves << move
      end
    end
    check_moves
  end

  def checkmate_move
    @possible.each do |move|

      duped_board = @board.dup
      duped_board.move(move[0],move[1])

      return move if duped_board.checkmate?(:w)
    end
    nil

  end


  def possible_moves
    possible_moves = []

    @board.collect_pieces(color).each do |piece|
      piece.valid_moves.each {|move| possible_moves << [piece.position, move] }
    end

    possible_moves
  end

  def safe_moves
    safe_moves = []

    @possible.each do |move|
      duped_board = @board.dup
      duped_board.move(move[0],move[1])
      opponent_color = color == :w ? :b : :w
      all_possible_moves = []

      duped_board.collect_pieces(opponent_color).each do |piece|
        all_possible_moves += piece.valid_moves
      end

      unless all_possible_moves.include?(move[1])
        safe_moves << move
      end
    end
    safe_moves
  end


  def good_trade
    good_trades = []
    @possible.each do |move|
      base_val = @board[move[0]].class::VALUE
      new_val = @board[move[1]].nil? ? 0 : @board[move[1]].class::VALUE
      if new_val >= base_val
        good_trades << move
      end
    end
    good_trades

  end

  def attack_moves
    possible_attacks = @possible.select do |move|
      !@board[move[1]].nil?
    end

    possible_attacks.sort! {|move| @board[move[1]].class::VALUE}
    possible_attacks.reverse

    best_val = @board[possible_attacks[0][1]].class::VALUE
    possible_attacks.select{|move| move[1].class::VALUE >= best_val}

  end


end
