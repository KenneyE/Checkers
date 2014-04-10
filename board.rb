require './piece.rb'

class Board

  ROWS_0_AND_2 = 0.step(8, 2)

  attr_accessor :squares

  def initialize
    @squares = Array.new(10) { Array.new( 10, nil ) }
    place_pieces
  end

  def [](pos)
    self.squares[pos[0]][pos[1]]
  end

  def []=(pos, piece)
    self.squares[pos[0]][pos[1]] = piece
  end

  def display_board
    system("clear")
    puts self.to_s
  end

  def move_piece(move)
    from, to = move[0], move[1]
    piece = self[from]
    if piece.valid_slides.include?(to)
      piece.perform_slide(to)
    elsif piece.valid_jumps.include?(to)
      piece.perform_jump(to)
    end
  end

  def place_pieces
    [0, 2].each do |row|
      ROWS_0_AND_2.each do |col|
        self[[row, col + 1]] = Piece.new(self, :black, [row, col + 1])
        self[[row + 1, col]] = Piece.new(self, :black, [row + 1, col])
        self[[8 - row, col + 1]] = Piece.new(self, :white, [8 - row, col + 1])
        self[[9 - row, col]] = Piece.new(self, :white, [9 - row, col])
      end
    end
  end

  def to_s
    s = "  A B C D E F G H I J\n"
    # debugger
    self.squares.each_with_index do |row, i|
      s += (10 - i).to_s + " "
      row.each_with_index do |col, j|
        if self[[i, j]].nil?
          s += "- "
        else
          s += self[[i,j]].symbol + " "
        end
      end
      s += "\n"
    end
    s
  end

end