class Pawn < Piece
  VALUE = 1

  MOVING_W = [[1,0], [2,0]]
  MOVING_B = [[-1,0],[-2,0]]
  ATTACKING_W = [[1,1],[1,-1]]
  ATTACKING_B = [[-1,1],[-1,-1]]

  def possible_moves

    possible_moves = []

    if self.color == :w
      if @position[0] == 1
        new_pos = MOVING_W[1].zip(@position).map{ |arr| arr.reduce(:+)}
        possible_moves << new_pos if @board[new_pos].nil? && @board[[new_pos[0]-1,new_pos[1]]].nil?
      end

      new_pos = MOVING_W[0].zip(@position).map{ |arr| arr.reduce(:+)}
      if new_pos.on_board?
        possible_moves << new_pos if @board[new_pos].nil?
      end

      ATTACKING_W.each do |move|
        new_pos = move.zip(@position).map{ |arr| arr.reduce(:+)}
        if new_pos.on_board?
          unless @board[new_pos].nil?
            possible_moves << new_pos if @board[new_pos].color == opposite
          end
        end
      end

    else
      if @position[0] == 6
        new_pos = MOVING_B[1].zip(@position).map{ |arr| arr.reduce(:+)}
        possible_moves << new_pos if @board[new_pos].nil? && @board[[new_pos[0]+1,new_pos[1]]].nil?
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

  def render
    self.color == :w ? "\u2659" : "\u265F"
  end

end
