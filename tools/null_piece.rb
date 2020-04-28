require_relative "piece"

#The null class is used for assigning empty spaces on the board.

class NullPiece < Piece

    #Initializes all the characteristics of the empty space to the piece class.
    def initialize(color, board, pos)
        super
    end

end