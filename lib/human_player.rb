class HumanPlayer
  attr_reader :color

  def initialize(color)
    @color = color
    @name = color == :w ? "White" : "Black"
  end

  def parse_input(input)
    input = input.gsub(/\s+/, "").split(",").map{|el| el.split("")}
    raise ArgumentError if input.flatten.count != 4
    input.map do |el|
      el[0] = el[0].downcase.ord - 97
      el[1] = el[1].to_i
      el[1] -= 1
      el.reverse
    end
  end

  def play_turn
    print "#{@name}, please enter your move (in the form \"a1,b2\"): "
    move = gets.chomp
    parse_input(move)
  rescue
    retry
  end


end
