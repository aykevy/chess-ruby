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

    #Changes the player turn.
    def change_turn
        @turn = @turn.color == :white ? @player2 : @player1
    end

    #Gets the kings on the board.
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

    #Generates information for a king before testing for checks and validation.
    def king_info(king)
        castle_moves = king.castle
        in_check = false
        exit_moves = []
        [castle_moves, in_check, exit_moves]
    end

    #Checks if the position is king.
    def is_king?(pos)
        row, col = pos
        @board.rows[row][col].symbol == :king
    end

    #Checks if the position is pawn.
    def is_pawn?(pos)
        row, col = pos
        @board.rows[row][col].symbol == :pawn
    end

    #Checks if the current turn is in checkmate or stalemate.
    #Case 1: If in check, return [true, check_exits]
    #Case 2: If in checkmate, return ["Done"]
    #Case 3: If in stalemate, return ["Done"]
    #Case 4: If none above, return ["Continue"]
    def checkmate_or_stalemate?(king)
        opposite_color = king.color == :white ? :black : :white
        if @board.check(king.pos)
            puts "Check, #{king.color} king in check."
            check_exits = @board.checkmate_exit(king)
            if check_exits.empty?
                puts "Checkmate, #{opposite_color} wins!"
                return ["Done"]
            else
                return [true, check_exits]
            end
        elsif @board.stalemate(king.color)
            puts "Stalemate, #{king.color} has no legal moves."
            return ["Done"]
        else
            return ["Continue"]
        end
    end

    #Moves the piece from start to destination.
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

    #Makes a move that gets the king out of check.
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

    #Helper function that does the castling.
    def do_castle(king_s, king_d)
        case king_d
        when [7, 2]
            rook_s, rook_d = [[7, 0], [7, 3]]
            @board.move_piece(king_s, king_d)
            @board.move_piece(rook_s, rook_d)
        when [7, 6]
            rook_s, rook_d = [[7, 7], [7, 5]]
            @board.move_piece(king_s, king_d)
            @board.move_piece(rook_s, rook_d)
        when [0, 2]
            rook_s, rook_d = [[0, 0], [0, 3]]
            @board.move_piece(king_s, king_d)
            @board.move_piece(rook_s, rook_d)
        when [0, 6]
            rook_s, rook_d = [[0, 7], [0, 5]]
            @board.move_piece(king_s, king_d)
            @board.move_piece(rook_s, rook_d)
        end
    end

    #Gives the king the option to do a normal move or castle.
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

    def get_enpassant_positions
        previous = @board.moves_list.last
        if previous.length == 2 #Length can be 3 for promotions.
            s, d = previous
            start_r, start_c = s
            dest_r, dest_c = d
            piece = @board.rows[dest_r][dest_c]

            enpass_case_one = start_r == 1 && dest_r == 3 && start_c == dest_c
            enpass_case_two = start_r == 6 && dest_r == 4 && start_c == dest_c

            if piece.symbol == :pawn && (enpass_case_one || enpass_case_two)
                moves = [[dest_r, dest_c - 1], [dest_r, dest_c + 1]]
                return moves.select { | row, col = move | col >= 0 && col <= 7 }
            end
        end
        []
    end

    def get_enpassant_destination
        _, prev_dest = @board.moves_list.last
        prev_r, prev_c = prev_dest
        @turn.color == :white ? [prev_r - 1, prev_c] : [prev_r + 1, prev_c]
    end

    def do_enpassant(s, d)
        _, prev_dest = @board.moves_list.last
        prev_r, prev_c = prev_dest
        @board.rows[prev_r][prev_c] = NullPiece.new(:color, @board, [prev_r, prev_c])
        puts "VALID MOVE!"
        puts
        @board.move_piece(s, d)
        change_turn #NEW
    end

    #Makes a move that promotes the pawn.
    def do_promotion(s, d)
        p_row, p_col = s
        get_promo = prompt_promotion
        promotion = [@board.rows[p_row][p_col].color, get_promo]
        #Check for valid input later
        @board.move_piece(s, d, promotion)
        change_turn #NEW
    end

    def pawn_move(s, d)
        #Piece color and stuff should already be checked for in move selection, 
        #so only worry about if your pawns positions are included in enpassant move list.

        pos_that_can_enpass = get_enpassant_positions
        enpass_dest = get_enpassant_destination

        if [0, 7].include?(d[0])
            do_promotion(s, d)

        elsif pos_that_can_enpass.include?(s) && d == enpass_dest
            do_enpassant(s, d)

        else
            normal_move(s, d)
        end
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
                elsif is_pawn?(s)
                    pawn_move(s, d)
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

            #Set up king informations on both sides.
            white_king, black_king = self.get_kings
            white_castle_moves, in_check_white, white_exit_moves = king_info(white_king)
            black_castle_moves, in_check_black, black_exit_moves = king_info(black_king)

            #Print Interface (Can comment out everything but the board to remove trackers)
            print_turn(@turn)
            print_castle_moves(white_castle_moves, black_castle_moves)
            print_enpassant_moves(get_enpassant_positions)
            print_board(@board.rows)
           
            #Make moves depending on turn.
            if @turn.color == :white
                w_update = checkmate_or_stalemate?(white_king)
                break if w_update.length == 1 && w_update.first == "Done"
                in_check_white, white_exit_moves = w_update if w_update.length == 2
                s, d = prompt_move
                move_selection(s, d, in_check_white, white_exit_moves, white_castle_moves)

            else
                b_update = checkmate_or_stalemate?(black_king)
                break if b_update.length == 1 && b_update.first == "Done"
                in_check_black, black_exit_moves = b_update if b_update.length == 2
                s, d = prompt_move
                move_selection(s, d, in_check_black, black_exit_moves, black_castle_moves)
            end
        end
    end

end

if __FILE__ == $PROGRAM_NAME
    g = Game.new()
    g.play
end