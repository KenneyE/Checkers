class InvalidMoveError < RuntimeError; end

class Piece

  attr_reader :color, :board
  attr_accessor :position, :is_king

  def initialize(board, color, position, is_king = false)
    @board = board
    @color = color
    @position = position
    @is_king = is_king
  end

  def perform_jump(destination)
    jumps = valid_jumps

    self.board[self.position] = nil
    self.board[destination] = self
    self.board[jumps[destination]] = nil
    self.position = destination
    maybe_promote
  end

  def perform_slide(destination)
    self.board[self.position] = nil
    self.board[destination] = self
    self.position = destination
    maybe_promote
  end

  def perform_moves(from, move_chain)
    if valid_move_chain?(from, move_chain)
      perform_moves!(move_chain, self.board)
    end
  end

  def perform_moves!(move_chain, move_board)
    # start = move_chain.shift
    # piece = move_board[start]
    to = move_chain[0]
    if valid_slides.include?(to)
      perform_slide(to)
    elsif valid_jumps.include?(to)
      valid_chain = perform_jump_chain(move_chain)
      unless valid_chain
        puts "Not a valid chain"
        raise InvalidMoveError
      end
    else
      puts "Not a valid destination"
      raise InvalidMoveError
    end
    true
  end

  def perform_jump_chain(chain)
    return true if chain.empty?

    next_pos = chain.shift
    return false unless valid_jumps.include?(next_pos)

    perform_jump(next_pos)
    perform_jump_chain(chain)
  end

  def valid_move_chain?(from, move_chain)
    dup_board = self.board.dup
    dup_chain = move_chain.dup
    piece = dup_board[from]

    begin
      piece.perform_moves!(dup_chain, dup_board)
    rescue InvalidMoveError
      # puts "Not a valid move"
      return false
    else
      true
    end

  end

  def valid_jumps
    valid_jumps = Hash.new { |h,k| h[k] = [] }
    direction.each do |long|
      [1, -1].each do |lat|
        move_pos = self.position.dup
        jump_pos = [ move_pos[0] + long, move_pos[1] + lat ]
        move_pos[0] += 2 * long
        move_pos[1] += 2 * lat

        unless  self.board[jump_pos].nil? || self.board[jump_pos].color == self.color
          if self.board[move_pos].nil?
            valid_jumps[move_pos] = jump_pos
          end
        end
      end
    end
    valid_jumps
  end

  def valid_slides
    slides = []
    direction.each do |long|
      [1, -1].each do |lat|
        move_pos = self.position.dup
        move_pos[0] += long
        move_pos[1] += lat
        slides << move_pos if self.board[move_pos].nil?
      end
    end
    slides
  end

  def valid_moves
    valid_slides + valid_jumps.keys
  end

  def direction
    if self.is_king
      [1, -1]
    elsif self.color == :white
      [-1]
    else
      [1]
    end
  end

  def maybe_promote
    if (self.position[0] == 0 && color == :white) || self.position[0] == 7 && color == :black
      self.is_king = true
    end
  end

  def symbol
    return "\u25CE" if color == :white
    return "\u25CD" if color == :black
    return "\u265B" if color == :black && self.is_king
    return "\u2655" if color == :white && self.is_king
    '-'
  end

end