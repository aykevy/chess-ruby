require_relative "board_modules/display_module"
class Piece
    
    include Display

    attr_accessor :color, :board, :pos, :symbol

    def initialize(color, board, pos)
        @color = color
        @board = board
        @pos = pos
        @symbol = nil
    end

    #Sets the symbol given s.
    def set_symbol(s)
        @symbol = s
    end

    #Determines if the position is a piece on the board and is not part of
    #the null class.
    def piece?(pos)
        #print_board(@board.rows)
         x, y = pos
         @board.rows[x][y].is_a?(Piece) && !@board.rows[x][y].is_a?(NullPiece)
    end

    #Checks if the position is the opposite color.
    def opposite_color?(pos)
        x, y = pos
        @board.rows[x][y].color != @color
    end

end