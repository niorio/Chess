class ComputerPlayer

  attr_reader :color

  def initialize(board)
    @color = :b
    @board = board
  end

  def play_turn

    @possible = possible_moves
    @safe_moves = safe_moves
    return checkmate_moves.first unless checkmate_moves.empty?




    # if duped_board.in_check?(:w) && possible_attacks.include?(move)
    #   check_attacks << move
    # elsif duped_board.in_check?(:w)
    #   checks << move
    # end



    # return (check_moves & attack_moves & safe_moves).sample unless (check_moves & attack_moves & safe_moves).empty?
    # return (attack_moves & safe_moves).sample unless (attack_moves & safe_moves).empty?
    # return (check_moves & good_trade).sample unless (check_moves & good_trade).empty?
    return good_trade.sample unless good_trade.empty?


    return check_moves.sample unless check_moves.empty?
    return attack_moves.sample unless attack_moves.empty?

    possible_moves.sample

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
  def checkmate_moves
    @possible.each do |move|

      duped_board = @board.dup
      duped_board.move(move[0],move[1])

      return move if duped_board.checkmate?(:w)
    end
    []

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
      if @board[move[1]].class::VALUE >= base_val
        good_trades << move
      end
    end
  end

  def attack_moves

    possible_attacks = @possible.select do |move|
      !@board[move[1]].nil?
    end

    possible_attacks.sort! {|move| @board[move[1]].class::VALUE}
    possible_attacks.reverse

  end

  def highest_attack_moves

    best_val = attack_moves.first[1].class::VALUE
    attack_moves.select {|move| @board[move[1]].class::VALUE == best_val }

  end



end
