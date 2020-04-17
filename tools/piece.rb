class Piece
    
    attr_accessor :color, :board, :pos, :symbol

    def initialize(color, board, pos)
        @color = color
        @board = board
        @pos = pos
        @symbol = nil
    end

end