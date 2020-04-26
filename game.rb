require_relative "player"
require_relative "board"
require_relative "tools/board_modules/display_module"
require_relative "tools/board_modules/prompt_module"
require_relative "tools/test_modules/simulation_module"

class Game

    include Display
    include Prompt
    include Simulation

    attr_accessor :player1, :player2, :turn

    def initialize
        @board = Board.new()
        @player1 = Player.new("Player 1", :white)
        @player2 = Player.new("Player 2", :black)
        @turn = @player1
    end

    def change_turn
        @turn = @turn.color == :white ? @player2 : @player1
    end

    def get_kings
        white = []
        black = []
        @board.rows.each do | row |
            row.each do | piece |
                if piece.symbol == :king
                    piece.color == :white ? white = piece : black = piece
                end
            end
        end
        [white, black]
    end

    def king_info(king)
        castle_moves = king.castle
        in_check = false
        exit_moves = []
        [castle_moves, in_check, exit_moves]
    end

    def is_king?(pos)
        row, col = pos
        @board.rows[row][col].symbol == :king
    end

    def is_pawn?(pos)
        row, col = pos
        @board.rows[row][col].symbol == :pawn
    end

    def is_null?(pos)
        !@board.piece?(pos)
    end

    def normal_move(s, d)
        if @board.valid_move?(s, d)
            puts "VALID MOVE!"
            puts
            @board.move_piece(s, d)
            change_turn #NEW
        else
            puts "INVALID MOVE!"
            puts
        end
    end

    def check_move(s, d, exit_moves)
        if exit_moves.include?([s, d])
            puts "VALID MOVE!"
            puts
            @board.move_piece(s, d)
            change_turn #NEW
        else
            puts "INVALID MOVE!"
            puts
        end
    end

    def promotion_move(s, d)
        p_row, p_col = s
        get_promo = prompt_promotion
        promotion = [@board.rows[p_row][p_col].color, get_promo]
        #Check for valid input later
        @board.move_piece(s, d, promotion)
        change_turn #NEW
    end

    def do_castle(king_pos, king_dest)
        case king_dest
        when [7, 2]
            rook_start, rook_dest = [[7, 0], [7, 3]]
            @board.move_piece(king_pos, king_dest)
            @board.move_piece(rook_start, rook_dest)
        when [7, 6]
            rook_start, rook_dest = [[7, 7], [7, 5]]
            @board.move_piece(king_pos, king_dest)
            @board.move_piece(rook_start, rook_dest)
        when [0, 2]
            rook_start, rook_dest = [[0, 0], [0, 3]]
            @board.move_piece(king_pos, king_dest)
            @board.move_piece(rook_start, rook_dest)
        when [0, 6]
            rook_start, rook_dest = [[0, 7], [0, 5]]
            @board.move_piece(king_pos, king_dest)
            @board.move_piece(rook_start, rook_dest)
        end
    end

    def king_move(s, d, castle_move_list)
        if @board.valid_move?(s, d) || castle_move_list.include?(d)
            if castle_move_list.include?(d)
                puts "VALID CASTLE MOVE!"
                puts
                do_castle(s, d)
                change_turn #NEW
            else
                puts "VALID MOVE!"
                puts
                @board.move_piece(s, d)
                change_turn #NEW
            end
        else
            puts "INVALID MOVE!"
            puts
        end
    end

    #Case 1: If in check, return [true, check_exits]
    #Case 2: If in checkmate, return ["Done"]
    #Case 3: If in stalemate, return ["Done"]
    #Case 4: If none above, return ["Continue"]
    def checkmate_or_stalemate?(king)
        info_updates = []
        opposite_color = king.color == :white ? :black : :white
        if @board.check(king.pos)
            puts "Check, #{king.color} king in check. Resolve check first."
            check_exits = @board.checkmate_exit(king)
            if check_exits.empty?
                puts "Checkmate, #{opposite_color} wins!"
                info_updates = ["Done"]
            else
                info_updates = [true, check_exits]
            end
        elsif @board.stalemate(king.color)
            puts "Stalemate, #{king.color} has no legal moves."
            info_updates = ["Done"]
        else
            info_updates = ["Continue"]
        end
        info_updates 
    end

    def move_selection(s, d, in_check, exit_moves, castle_moves)
        if @board.rows[s[0]][s[1]].color != @turn.color
            puts "That is not your piece or it is a empty space!"
        else
            if in_check
                check_move(s, d, exit_moves)
            else
                if is_king?(s)
                    king_move(s, d, castle_moves)
                elsif is_pawn?(s) && [0, 7].include?(d[0])
                    promotion_move(s, d)
                else
                    normal_move(s, d)
                end
            end
        end
    end


    def play

        #Simulations test place here:
        simulation_7(@board)

        while true

            #Set up king informations on both sides
            #--------------------------------------
            white_king, black_king = self.get_kings
            white_castle_moves, in_check_white, white_exit_moves = king_info(white_king)
            black_castle_moves, in_check_black, black_exit_moves = king_info(black_king)

            print_turn(@turn)
            print_castle_moves(white_castle_moves, black_castle_moves)
            print_board(@board.rows)
            #--------------------------------------

            if @turn.color == :white
                w_update = checkmate_or_stalemate?(white_king)
                break if w_update.length == 1 && w_update.first == "Done"
                in_check_white, white_exit_moves = w_update if w_update.length == 2
            else
                b_update = checkmate_or_stalemate?(black_king)
                break if b_update.length == 1 && b_update.first == "Done"
                in_check_black, black_exit_moves = b_update if b_update.length == 2
            end

            #Actual Move Making
            s, d = prompt_move

            if @turn.color == :white
                move_selection(s, d, in_check_white, white_exit_moves, white_castle_moves)
            else
                move_selection(s, d, in_check_black, black_exit_moves, black_castle_moves)
            end

        end
    end

end

if __FILE__ == $PROGRAM_NAME
    g = Game.new()
    g.play
end