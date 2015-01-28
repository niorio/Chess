class Bishop < SlidingPiece

  VALUE = 3

  def possible_moves
    super(DELTAS_ALL[:diag])
  end
  def render
    self.color == :w ? "\u2657" : "\u265D"
  end

end
