require 'debugger'
load './piece.rb'
load './board.rb'

class InvalidInputError < RuntimeError
  "Invalid input"
end

class Checkers

  INPUT_KEY = { "a" => 0, "b" => 1, "c" => 2, "d" => 3, "e" => 4,
                "f" => 5, "g" => 6, "h" => 7 , "i" => 8, "j" => 9
              }

  attr_accessor :board, :player1_turn
  attr_reader :player1_color, :player2_color

  def initialize( options = { :player1_color => :white, :player2_color => :black} )
    @player1_color = options[:player1_color]
    @player2_color = options[:player2_color]
    @board = nil
    @player1_turn = true
  end

  def play
    self.board = Board.new

    until false #game_over? || quit?
      self.board.display_board
      color = swap_color

      move = get_move(color)
      board.move_piece(move)

      swap_player

    end
  end

  protected

    def swap_player
      self.player1_turn = !self.player1_turn
    end

    def swap_color
      if self.player1_turn
        color = :white
      else
        color = :black
      end
    end

    def get_move(color)

      from = get_from(color)
      # return nil if quit?
      # puts "You Picked a: #{self.board[from].class}"

      valid_moves = self.board[from].valid_moves
      to = get_to(from, valid_moves)
      # return nil if quit?

      return from, to
    end

    def get_from(color)
      # debugger
      begin
        from = parse(prompt("Input starting square: "))

        raise InvalidInputError if self.board[from].nil? || self.board[from].color != color
        moves = self.board[from].valid_moves
        raise InvalidInputError if self.board[from].valid_moves.empty?
      rescue InvalidInputError => e
        puts e
        retry
      end
      from
    end

    def get_to(from, valid_moves)
      # debugger
      begin
        to = parse(prompt("Input end square: "))
      end until valid_moves.include?(to)
      to
    end

    def prompt(s)
      puts(s)
      return gets.chomp.strip.downcase
    end

    def parse(s)
      arr = s.split("")
      return quit_game if arr[1] == "q"
      raise "Invalid Input" unless INPUT_KEY.has_key?(arr[0])
      raise "Invalid Input" unless (10 - Integer(arr[1])).between?(0,9)
      [ 10 - Integer(arr[1]),  INPUT_KEY[arr[0]]]
    end


end

c = Checkers.new
c.play