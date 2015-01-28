class Game

  def initialize(player2)
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
    King.new(@board, :w, [0,4])
    Queen.new(@board, :w, [0,3])

    8.times do |i|
      Pawn.new(@board, :b, [6,i])
    end

    Rook.new(@board, :b, [7,7])
    Rook.new(@board, :b, [7,0])
    Knight.new(@board, :b, [7,6])
    Knight.new(@board, :b, [7,1])
    Bishop.new(@board, :b, [7,2])
    Bishop.new(@board, :b, [7,5])
    King.new(@board, :b, [7,4])
    Queen.new(@board, :b, [7,3])


    @player1 = HumanPlayer.new(:w)

    if player2 == :computer
      @player2 = ComputerPlayer.new(@board)
    else
      @player2 = HumanPlayer.new(:b)
    end

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
    if @board.checkmate?(:w)
      puts "Uh oh, black checkmated white! Game over. Congrats black!"
    else
      puts "White checkmated black. Cheater, it had the first move."
    end

  end



end
