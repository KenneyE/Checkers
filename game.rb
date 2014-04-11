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
      begin
        from, to = get_move(color)
        board.move_piece(from, to)
      rescue InvalidMoveError
        puts "Invalid move"
        retry
      end

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
      begin
        # from = parse(prompt("Input starting square: ")).first

        puts "Select piece"
        from = get_moves.first
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
      # to = parse(prompt("Input end square: "))

      puts "Select move chain. Press Enter when done."
      to = get_moves
    end

    # def prompt(s)
    #   puts(s)
    #   return gets.chomp.strip.downcase
    # end
    #
    # def parse(s)
    #   moves = []
    #   s.split(",").each do |move|
    #     arr = [move.strip[0], move.strip[1..-1]]
    #     return quit_game if arr[1] == "q"
    #     raise "Invalid Input" unless INPUT_KEY.has_key?(arr[0])
    #     raise "Invalid Input" unless (10 - Integer(arr[1])).between?(0,9)
    #     moves << [ 10 - Integer(arr[1]),  INPUT_KEY[arr[0]]]
    #   end
    #   moves
    # end

    def get_moves
      moves = []
      loop do
        input = get_key_press
        if input == :enqueue
          moves << self.board.cursor
        elsif input == :return
          moves << self.board.cursor
          return moves
        end
      end
      moves.uniq
    end

    def get_key
      begin
        system("stty raw -echo")
        str = STDIN.getc
      ensure
        system("stty -raw echo")
      end
      str.chr
    end


    def get_key_press
      k = get_key
      case k
      when 'a'
        self.board.move_cursor(k)
      when 's'
        self.board.move_cursor(k)
      when 'd'
        self.board.move_cursor(k)
      when 'w'
        self.board.move_cursor(k)
      when 'q'
        self.quit = true
      when " "
        :enqueue
      when "\r"
        :return
      end
    end



end

c = Checkers.new
c.play