#This module is used to simply provide functions that will setup the board will
#all the correct pieces in the correct positions.

module Setup
    
    #Sets the pawns given the row, column, 2d board array, and board instance.
    def set_pawns(row, col, board_arr, board_itself)
        color = row == 1 ? :black : :white
        board_arr[row][col] = Pawn.new(color, board_itself, [row, col])
        board_arr[row][col].set_symbol(:pawn)
    end

    #Sets the rooks given the row, column, 2d board array, and board instance.
    def set_rooks(row, col, color, board_arr, board_itself)
        board_arr[row][col] = SlidingPiece.new(color, board_itself, [row, col])
        board_arr[row][col].set_symbol(:rook)
    end

    #Sets the knights given the row, column, 2d board array, and board instance.
    def set_knights(row, col, color, board_arr, board_itself)
        board_arr[row][col] = SteppingPiece.new(color, board_itself, [row, col])
        board_arr[row][col].set_symbol(:knight)
    end

    #Sets the bishop given the row, column, 2d board array, and board instance.
    def set_bishops(row, col, color, board_arr, board_itself)
        board_arr[row][col] = SlidingPiece.new(color, board_itself, [row, col])
        board_arr[row][col].set_symbol(:bishop)
    end

    #Sets the queens given the row, column, 2d board array, and board instance.
    def set_queens(row, col, color, board_arr, board_itself)
        board_arr[row][col] = SlidingPiece.new(color, board_itself, [row, col])
        board_arr[row][col].set_symbol(:queen)
    end

    #Sets the kings given the row, column, 2d board array, and board instance.
    def set_kings(row, col, color, board_arr, board_itself)
        board_arr[row][col] = SteppingPiece.new(color, board_itself, [row, col])
        board_arr[row][col].set_symbol(:king)
    end

    #Sets all the pieces using the functions above given the row, column,
    #2d board array, and board instance.
    def set_pieces(row, col, board_arr, board_itself)
        if row == 1 || row == 6
            set_pawns(row, col, board_arr, board_itself)
        elsif row == 0 || row == 7
            case col
            when 0, 7
                row == 0 ? set_rooks(row, col, :black, board_arr, board_itself) : set_rooks(row, col, :white, board_arr, board_itself)
            when 1, 6
                row == 0 ? set_knights(row, col, :black, board_arr, board_itself) : set_knights(row, col, :white, board_arr, board_itself)
            when 2, 5
                row == 0 ? set_bishops(row, col, :black, board_arr, board_itself) : set_bishops(row, col, :white, board_arr, board_itself)
            when 3
                row == 0 ? set_queens(row, col, :black, board_arr, board_itself) : set_queens(row, col, :white, board_arr, board_itself)
            when 4
                row == 0 ? set_kings(row, col, :black, board_arr, board_itself) : set_kings(row, col, :white, board_arr, board_itself)
            end
        end
    end

    #Sets the empty spaces to null pieces given the row, column, 2d board array
    #and board instance.
    def set_null(row, col, board_arr, board_itself)
        board_arr[row][col] = NullPiece.new(:color, board_itself, [row, col])
    end

    #Sets up the pieces and empty spaces (using null pieces) on the board.
    def setup_board(board_arr, board_itself)
        valid_rows = [0, 1, 6, 7]
        board_arr.each_with_index do | sub_arr, row_i |
            if valid_rows.include?(row_i)
                sub_arr.each_with_index { | _, col_i | set_pieces(row_i, col_i, board_arr, board_itself) }
            else
                sub_arr.each_with_index { | _, col_i | set_null(row_i, col_i, board_arr, board_itself) }
            end
        end
    end
    
end