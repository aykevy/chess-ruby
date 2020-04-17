require_relative "piece"

class Pawn < Piece

    def initialize(color, board, pos)
        super
    end

    def set_symbol(s)
        @symbol = s
    end

    def piece?(pos)
        x, y = pos
        @board.rows[x][y].is_a?(Piece) && !@board.rows[x][y].is_a?(NullPiece)
    end

    def opposite_color?(pos)
        x, y = pos
        @board.rows[x][y].color != @color
    end

    def get_moves 
        #Worry about promotion later for [-1, 0], [1,0]
        #Worry about fixing the problem where its very first move can actually move 2 spaces
        #forward.

        dirs = @color == :white ? [[-1, -1], [-1, 1], [-1, 0]] : [[1, -1], [1, 1], [1, 0]]
        added = dirs.map { | x, y = dir | [x + @pos[0], y + @pos[1]] }
        bounded_moves = added.select { | x, y = dir | x >= 0 && x <= 7 && y >= 0 && y <= 7 }
        
        valid = []
        #If theres a piece of any color blocking, u cant move forward
        forward = bounded_moves.pop
        valid << forward unless piece?(forward) 

        #Checks for opposite color pieces in diagonals
        bounded_moves.each { | pos | valid << pos if piece?(pos) && opposite_color?(pos) }
        valid 

    end
    
end