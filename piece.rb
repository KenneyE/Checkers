require './board.rb'

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
    if jumps.has_key?(destination)
      self.position = destination
      self.board[jumps[destination]] = nil
      maybe_promote

      return true
    end
    false
  end

  def valid_jumps
    valid_jumps = Hash.new { |h,k| h[k] = [] }
    direction.each do |long|
      [1, -1].each do |lat|
        move_pos = self.position.dup
        jump_pos = [ long, lat ]
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

  def perform_slide(destination)
    if valid_slides.include?(destination)
      self.position = destination
      maybe_promote

      return true
    end
    false
  end

  def valid_slides
    valid_slides = []
    debugger
    direction.each do |long|
      [1, -1].each do |lat|
        move_pos = self.position.dup
        move_pos[0] += long
        move_pos[1] += lat
        valid_slides << move_pos if self.board[move_pos].nil?
      end
    end
    valid_slides
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
    return "\u26C0" if color == :white
    return "\u2615" if color == :black
    '-'
  end

end