class Knight < SteppingPiece

  VALUE = 3

  def possible_moves
    super(DELTAS_ALL[:knights])
  end
  
  def render
    self.color == :w ? "\u2658" : "\u265E"
  end

end
