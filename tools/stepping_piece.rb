require_relative "piece"
require_relative "piece_modules/step_module"

class SteppingPiece < Piece

    include Stepable

    def initialize(color, board, pos)
        super
    end

    def set_symbol(s)
        @symbol = s
    end
    
    def copy_king(c, b, p, s)
        copy_piece = SteppingPiece.new(c, b, p)
        copy_piece.set_symbol(s)
        copy_piece
    end

    def piece?(pos)
        x, y = pos
        @board.rows[x][y].is_a?(Piece) && !@board.rows[x][y].is_a?(NullPiece)
    end

    def get_unblocked_moves(moves)
        result = []
        moves.each do | pos |
            if piece?(pos)
                x, y = pos
                result << pos if @color != @board.rows[x][y].color 
            else
                result << pos
            end
        end
        result
    end

    def get_moves
        possible_moves = moves(@pos, @symbol) 
        valid = get_unblocked_moves(possible_moves)
    end
    
end