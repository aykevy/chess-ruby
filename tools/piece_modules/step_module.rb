module Stepable

    def moves(pos, symbol)
        x, y = pos
        directions = []
        if symbol == :knight
            directions = [[-1, -2], [-2, -1], [-2, 1], [-1, 2], [1, -2], [1, 2], [2, -1], [2, 1]]
        else
            directions = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
        end
        positions = directions.map { | row, col = move | [row + x, col + y] }
        positions.select do | row, col = p |
            row >= 0 && row <= 7 && col >= 0 && col <= 7
        end
    end

end