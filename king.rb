class King < SteppingPiece

  VALUE = 100

  attr_reader :moved

  def initialize(board, color, position)
    @moved = false
    super
  end

  def move(target)
    @moved = true
    super
  end

  def possible_moves
    super(DELTAS_ALL[:diag] + DELTAS_ALL[:row_col])
  end

  def render
    self.color == :w ? "\u2654" : "\u265A"
  end

end
