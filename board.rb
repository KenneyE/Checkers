require 'colorize'

class Board

  ROWS_0_AND_2 = 0.step(8, 2)

  attr_accessor :squares, :cursor

  def initialize(init_board = true)
    @squares = Array.new(10) { Array.new( 10, nil ) }
    place_pieces if init_board
    @cursor = [0,0]
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

  def get_pieces
    self.squares.flatten.compact
  end

  def dup
    dup_board = Board.new(false)
    self.get_pieces.each do |piece|
      new_piece = Piece.new(dup_board, piece.color, piece.position)
      dup_board[new_piece.position] = new_piece
    end
    dup_board
  end

  def move_piece(from, to)
    self[from].perform_moves(from, to)
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
    s = ""
    self.squares.each_with_index do |row, i|
      s += "#{(10 - i)}"
      s += " " unless i.zero?
      # debugger
      row.each_with_index do |col, j|

        if self.cursor == [i,j]
          background_color = :blue
        elsif (i + j).even?
          background_color = :red
        else
          background_color = :light_gray
        end

        if self[[i, j]].nil?
          s += "   ".colorize(:background => background_color)
        else
          s += " #{self[[i,j]].symbol} ".colorize(:background => background_color)
        end
      end
      s += "\n"
    end
    s += "   A  B  C  D  E  F  G  H  I  J\n"
  end

  def move_cursor(dir)
    pos = self.cursor.dup

    case dir
    when 'a'
      pos[1] -= 1 unless pos[1] <= 0
    when 's'
      pos[0] += 1 unless pos[0] >= 9
    when 'd'
      pos[1] += 1 unless pos[1] >= 9
    when 'w'
      pos[0] -= 1 unless pos[0] <= 0
    end

    self.cursor = pos
    self.display_board
  end

  def must_jump?(color)

  end
end