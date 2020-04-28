require_relative "piece"
require_relative "piece_modules/slide_module"

#The sliding class derives from the piece class and will either act as
#a bishop, rook, or queen.

class SlidingPiece < Piece

    include Slideable

    attr_accessor :moved

    #Initializes all the characteristics of the piece and sets the moved attribute.
    def initialize(color, board, pos)
        super
        @moved = false
    end

    #Creates a copy of the piece.
    def copy(c, b, p, s)
        copy_piece = SlidingPiece.new(c, b, p)
        copy_piece.set_symbol(s)
        copy_piece
    end

    #Gets the unblocked moves of the piece.
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

    #Gets the common valid moves of the piece.
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