class Rook < SlidingPiece

  #@delta = DELTAS_ALL[:row_col]


  def possible_moves
    super(DELTAS_ALL[:row_col])
  end
  def render
    self.color == :w ? "\u2656" : "\u265C"
  end



end
