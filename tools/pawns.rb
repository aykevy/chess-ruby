require_relative "piece"

#The pawn class derives from the piece class and acts like a pawn.

class Pawn < Piece

    attr_accessor :moved

    #Initializes all the characteristics of the piece and sets the moved attribute.
    def initialize(color, board, pos)
        super
        @moved = false
    end

    #Creates a copy of the piece.
    def copy(color, board, piece, symbol)
        copy_piece = Pawn.new(color, board, piece)
        copy_piece.set_symbol(symbol)
        copy_piece
    end

    #This rule only applies when the pawns have not moved since the start of the game.
    def two_step_forward
        row, col = @pos
        positions = []
        if row == 1 || row == 6
            case @color
            when :white
                positions << [-2 + row, 0 + col]
            when :black
                positions << [2 + row, 0 + col]
            end
        end
        positions.select { | x, y = dir | x >= 0 && x <= 7 && y >= 0 && y <= 7 && !piece?([x,y]) }
    end

    #Gets the common valid moves of the piece.
    def get_moves
        #Last move in each array is a forward move, we will pop it later.
        dirs = @color == :white ? [[-1, -1], [-1, 1], [-1, 0]] : [[1, -1], [1, 1], [1, 0]]
        added = dirs.map { | x, y = dir | [x + @pos[0], y + @pos[1]] }
        bounded_moves = added.select { | x, y = dir | x >= 0 && x <= 7 && y >= 0 && y <= 7 }

        valid = []
        
        #If there is a piece of any color blocking, you can't move forward
        forward = bounded_moves.pop

        unless piece?(forward)
            valid << forward
            valid += two_step_forward #If you can't move forward one time obviously you can't move two forward.
        end
    
        #Checks for opposite color pieces in diagonals.
        bounded_moves.each { | pos | valid << pos if piece?(pos) && opposite_color?(pos) }
        valid
    end
    
end