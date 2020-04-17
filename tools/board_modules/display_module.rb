module Display
    
    def print_board(board_rows)
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

end