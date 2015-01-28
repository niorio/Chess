class King < SteppingPiece

  def possible_moves
    super(DELTAS_ALL[:diag] + DELTAS_ALL[:row_col])
  end

  def render
    self.color == :w ? "\u2654" : "\u265A"
  end


end
