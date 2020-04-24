#This module is used for giving us a visual representation of the board
#and any other piece of information that might be useful such as a moves list.

module Display
    
    #This function prints the current chess board.
    #White pieces are denoted by *
    #Black pieces are denoted by $
    #P = Pawn, R = Rook, B = Bishop, N = Knight, Q = Queen, K = King
    def print_board(board_rows)
        puts "============The Board============"
        puts
        puts "   0   1   2   3   4   5   6   7 "
        puts "---------------------------------"
        board_rows.each_with_index do | sub_arr, idx |
            render_row = "#{idx}  "
            sub_arr.each do | piece |
                if piece.is_a?(NullPiece)
                    render_row += ". "
                else
                    piece.color == :white ? render_row += "*" : render_row += "$"
                    case piece.symbol
                    when :pawn
                        render_row += "P"
                    when :rook
                        render_row += "R"
                    when :knight
                        render_row += "N"
                    when :bishop
                        render_row += "B"
                    when :queen
                        render_row += "Q"
                    when :king
                        render_row += "K"
                    end
                end
                render_row += "  "
            end
            puts render_row
        end
        puts
    end

    #Given a set of moves, this will print the move list in a start -> dest visual.
    def print_moves(moves)
        moves.each do | move |
            start, des = move
            puts "#{start} -> #{des} "
        end
    end

    def print_castle_moves(white_castle_moves, black_castle_moves)
        puts "==========Castle Tracker=========="
        puts
        if white_castle_moves.empty?
            puts "White Castle Moves: None"
        else
            puts "White Castle Moves: #{white_castle_moves}"
        end

        if black_castle_moves.empty?
            puts "Black Castle Moves: None"
        else
            puts "Black Castle Moves: #{black_castle_moves}"
        end
        puts
    end

end