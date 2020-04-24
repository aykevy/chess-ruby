require_relative "piece"
require_relative "piece_modules/slide_module"

class SlidingPiece < Piece

    include Slideable

    attr_accessor :moved

    def initialize(color, board, pos)
        super
        @moved = false
    end

    def copy(c, b, p, s)
        copy_piece = SlidingPiece.new(c, b, p)
        copy_piece.set_symbol(s)
        copy_piece
    end

    def set_symbol(s)
        @symbol = s
    end

    def piece?(pos)
        x, y = pos
        @board.rows[x][y].is_a?(Piece) && !@board.rows[x][y].is_a?(NullPiece)
    end

    def get_unblocked_moves(direction)
        result = []
        direction.each do | pos |
            if piece?(pos)
                x, y = pos
                result << pos if @color != @board.rows[x][y].color
                break
            else
                result << pos
            end
        end
        result
    end

    def get_moves
        valid = []
        case @symbol
        when :bishop
            valid = diagonal_moves(@pos).map { | direction | get_unblocked_moves(direction) }
        when :rook
            valid = horizontal_vertical_moves(@pos).map { | direction | get_unblocked_moves(direction) }
        when :queen
            valid = all_directions(@pos).map { | direction | get_unblocked_moves(direction) }
        end
        result = []
        valid.each { | direction | direction.each { | pos | result << pos } }
        result
    end

end