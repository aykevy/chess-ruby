#The piece class creates the piece object with characteristics of a piece
#and has common methods to be used outside of the class.

class Piece

    attr_accessor :color, :board, :pos, :symbol

    #Initializes all the characteristics of the piece.
    def initialize(color, board, pos)
        @color = color
        @board = board
        @pos = pos
        @symbol = nil
    end

    #Sets the symbol given s.
    def set_symbol(symbol)
        @symbol = symbol
    end

    #Determines if the position is a piece on the board and is not part of
    #the null class.
    def piece?(pos)
        x, y = pos
        @board.rows[x][y].is_a?(Piece) && !@board.rows[x][y].is_a?(NullPiece)
    end

    #Checks if the position is the opposite color.
    def opposite_color?(pos)
        x, y = pos
        @board.rows[x][y].color != @color
    end

end