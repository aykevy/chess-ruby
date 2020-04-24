#This module gets you all the positions of every direction on the board
#relative to the piece. It does not check for valid or invalid positions nor does
#it check for blocked positions, it simply returns all possible placements on the 
#board for knights and kings.

module Stepable

    #Gets you all positions on the board from the given position depending on 
    #whether its a knight or king.
    def moves(pos, symbol)
        x, y = pos
        directions = []
        case symbol
        when :knight
            directions = [[-1, -2], [-2, -1], [-2, 1], [-1, 2], [1, -2], [1, 2], [2, -1], [2, 1]]
        when :king
            directions = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
        end
        positions = directions.map { | row, col = move | [row + x, col + y] }
        positions.select do | row, col = p |
            row >= 0 && row <= 7 && col >= 0 && col <= 7
        end
    end

end