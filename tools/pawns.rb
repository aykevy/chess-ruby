require_relative "piece"
require_relative "board_modules/display_module"

class Pawn < Piece

    attr_accessor :moved

    def initialize(color, board, pos)
        super
        @moved = false
    end

    def copy(c, b, p, s)
        copy_piece = Pawn.new(c, b, p)
        copy_piece.set_symbol(s)
        copy_piece
    end

    def two_step_forward
        #This rule only applies when the pawns have not moved since the start of the game.
        row, col = @pos
        raw = []
        if row == 1 || row == 6
            case @color
            when :white
                raw << [-2 + row, 0 + col]
            when :black
                raw << [2 + row, 0 + col]
            end
        end
        bounded = raw.select { | x, y = dir | x >= 0 && x <= 7 && y >= 0 && y <= 7 && !piece?([x,y]) }
    end

    def get_moves #Tentative, lets add the fix
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