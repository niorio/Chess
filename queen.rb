class Queen < SlidingPiece

  def possible_moves
    super(DELTAS_ALL[:diag] + DELTAS_ALL[:row_col])
  end
  def render
    self.color == :w ? "\u2655" : "\u265B"
  end


end
