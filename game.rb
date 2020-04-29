require_relative "board"
require_relative "tools/player"
require_relative "tools/board_modules/prompt_module"
require_relative "tools/board_modules/display_module"

#This class allows you to keep track of the turns and movement of the game.
#It allows you to make the following moves regarding chess:
#   -Normal moves for every piece
#   -Castling moves for unmoved kings and rooks
#   -Promotion moves for pawns located in the second to last row across the board
#   -Enpassant moves for pawns that have been passed by an opposing pawn
#The above are available while also making sure they are valid when in check or
#to not get the player into check if the move were to be made.

class Game

    include Prompt
    include Display

    attr_accessor :board, :player1, :player2, :turn

    #Initializes the board, turn, and player objects.
    def initialize
        @board = Board.new
        @player1 = Player.new("Player 1", :white)
        @player2 = Player.new("Player 2", :black)
        @turn = @player1
    end

    #Changes the player turn.
    def change_turn
        @turn = @turn.color == :white ? @player2 : @player1
    end

    #Gets opposite color of a piece.
    def get_opposite_color(piece)
        piece.color == :white ? :black : :white
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
    def get_kings_info(king)
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

    #Gets the valid positions to where the pawn can promote.
    def get_promotion_positions(s)
        row, col = s
        piece = @board.rows[row][col]
        get_positions = piece.get_moves
        king_pos = get_kings.select { | king_piece | king_piece.color == @turn.color }.first.pos
        get_positions.select { | move | @board.check_valid_pawn_special?(move, piece, king_pos) }
    end

    #Helper function that promotes the pawn.
    def do_promotion(s, d)
        valid = get_promotion_positions(s)
        if valid.include?(d)
            p_row, p_col = s
            get_promo = prompt_promotion
            if ["q", "r", "b", "n"].include?(get_promo)
                promotion = [@board.rows[p_row][p_col].color, get_promo]
                @board.move_piece(s, d, promotion)
                change_turn
            else
                puts "INVALID PIECE CHOICE!\n\n"
            end
        else
            puts "INVALID PROMO MOVE!\n\n"
        end
    end

    #Gets the positions on the board of pieces that can enpassant (does not
    #check for validity, just gives positions).
    def get_enpassant_positions
        unless @board.moves_list.empty?
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
        end
        []
    end

    #Gets the destination of the move where a pawn will go to after doing enpassant.
    def get_enpassant_destination
        unless @board.moves_list.empty?
            _, prev_dest = @board.moves_list.last
            prev_r, prev_c = prev_dest
            if @turn.color == :white
                return [prev_r - 1, prev_c]
            else
                return [prev_r + 1, prev_c]
            end
        end
        []
    end

    #Helper function that does the enpassant.
    def do_enpassant(s, d)
        king_piece = get_kings.select { | king_piece | king_piece.color == @turn.color }
        king_pos = king_piece.first.pos
        current_piece = @board.rows[s[0]][s[1]]
        _, prev_dest = @board.moves_list.last
        prev_r, prev_c = prev_dest
        if @board.check_valid_pawn_special?(d, current_piece, king_pos, prev_dest)
            puts "VALID ENPASSANT MOVE!\n\n"
            @board.move_piece(s, prev_dest)
            @board.move_piece(prev_dest, d)
            change_turn
        else
            puts "INVALID ENPASSANT MOVE! That enpassant will check your king.\n\n"
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

    #Checks if the current turn is in checkmate or drawn.
    def checkmate_or_drawn?(king)
        if @board.check(king.pos)
            puts "Check, #{king.color} king in check.\n\n"
            check_exits = @board.checkmate_exit(king)
            check_enpass_exit = checkmate_or_stalemate_enpassant_moves(king)
            if check_exits.empty? && check_enpass_exit.empty?
                puts "Checkmate, #{get_opposite_color(king)} wins!\n\n"
                return ["Done"]
            else
                return [true, check_exits + check_enpass_exit]
            end
        elsif @board.stalemate(king.color)
            check_enpass_exit = checkmate_or_stalemate_enpassant_moves(king)
            if check_enpass_exit.empty?
                puts "Draw, stalement since #{king.color} has no legal moves.\n\n"
                return ["Done"]
            else
                return ["Continue"]
            end
        elsif @board.insufficient_material
            puts "Draw, insufficient material.\n\n"
            return ["Done"]
        else
            return ["Continue"]
        end
    end

    #Checks if the current turn in check or stalemate can extend the game
    #by an enpassant move.
    def checkmate_or_stalemate_enpassant_moves(king)
        valid = []
        enpass_pos = get_enpassant_positions
        unless enpass_pos.empty?
            _, prev_dest = @board.moves_list.last
            enpass_dest = get_enpassant_destination
            @board.rows.each do | row |
                row.each do | piece |
                    if piece.symbol == :pawn && piece.color == king.color && enpass_pos.include?(piece.pos)
                        if @board.check_valid_pawn_special?(enpass_dest, piece, king.pos, prev_dest)
                            valid << [piece.pos, enpass_dest]
                        end
                    end
                end
            end
        end
        unless valid.empty?
            puts "Not yet checkmated or stalemated, possible moves by the king to:\n\n"
            print_moves(valid)
        end
        valid
    end

    #Moves the piece from start to destination.
    def normal_move(s, d)
        if @board.valid_move?(s, d)
            puts "VALID MOVE!\n\n"
            @board.move_piece(s, d)
            change_turn
        else
            puts "INVALID MOVE!\n\n"
        end
    end

    #Makes a move that gets the king out of check.
    def check_move(s, d, exit_moves)
        if exit_moves.include?([s, d])
            if get_enpassant_positions.include?(s) && d == get_enpassant_destination
                do_enpassant(s, d)
            else
                puts "VALID MOVE!\n\n"
                @board.move_piece(s, d)
                change_turn
            end
        else
            puts "INVALID MOVE!\n\n"
        end
    end

    #Gives the king the option to do a normal move or castle.
    def king_move(s, d, castle_move_list)
        if @board.valid_move?(s, d) || castle_move_list.include?(d)
            if castle_move_list.include?(d)
                puts "VALID CASTLE MOVE!\n\n"
                do_castle(s, d)
                change_turn
            else
                puts "VALID MOVE!\n\n"
                puts
                @board.move_piece(s, d)
                change_turn
            end
        else
            puts "INVALID MOVE!\n\n"
        end
    end

    #Gives the pawn the option to do a promotion, enpassant, or normal move.
    #Piece color should already be checked for in move selection, so only
    #worry about if your pawns positions are included in enpassant move list.
    def pawn_move(s, d)
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

    #Checks if the input is not garbage.
    def not_garbage_input(s, d)
        begin
            s_row, s_col = s
            d_row, d_col = d
            s_valid = s_row >= 0 && s_row <= 7 && s_col >= 0 && s_col <= 7
            d_valid = d_row >= 0 && d_row <= 7 && d_col >= 0 && d_col <= 7
            if s_valid && d_valid
                return true
            else
                puts "That input is not in range.\n\n"
                return false
            end
        rescue
            puts "The input is garbage.\n\n"
            return false
        end
        false
    end

    #This is the move selection list.
    def move_selection(s, d, in_check, exit_moves, castle_moves)
        if not_garbage_input(s, d)
            if @board.rows[s[0]][s[1]].color != @turn.color
                puts "That is not your piece or it is a empty space!\n\n"
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
    end

end