require_relative "piece"
require_relative "piece_modules/step_module"

class SteppingPiece < Piece

    include Stepable

    def initialize(color, board, pos)
        super
    end

    def copy(c, b, p, s)
        copy_piece = SteppingPiece.new(c, b, p)
        copy_piece.set_symbol(s)
        copy_piece
    end

    def castle
        #Castle Rules:
        #   Can't be in check
        #   Can't be in check after castling
        #   Neither the king nor the rook your trying to castle to should have moved
        
        #Queen Side Castling
        #Black Side
        #   Queen Side
        #       No pieces in [0, 1], [0, 2], [0, 3] before castling
        #       King = [0, 2] Rook = [0, 3]
        #   King Side
        #       No pieces in [0, 5], [0, 6]
        #       King = [0, 6] Rook = [0, 5]
        #

        #King Side Castling
        #White Side
        #   Queen Side
        #       No pieces in [7, 1], [7, 2], [7, 3] before castling
        #       King = [7, 2] Rook = [7, 3]
        #   King Side
        #       No pieces in [7, 5], [7, 6]
        #       King = [7, 6] Rook = [7, 5]
        #
        
        puts "Castle"
    end

    def set_symbol(s)
        @symbol = s
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