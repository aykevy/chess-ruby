require_relative "player"
require_relative "board"
require_relative "tools/board_modules/display_module"
require_relative "tools/board_modules/prompt_module"
require_relative "tools/test_modules/simulation_module"

class Game

    include Display
    include Prompt
    include Simulation

    def initialize
        @board = Board.new()
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

    def castle_move(s, d, move_list)
        if @board.valid_move?(s, d) || move_list.include?(d)
            if move_list.include?(d)
                puts "VALID CASTLE MOVE!"
                puts
                do_castle(s, d)
            else
                puts "VALID MOVE!"
                puts
                @board.move_piece(s, d)
            end
        end
    end

    def play

        simulation_7(@board)

        while true

            white_king, black_king = self.get_kings
            white_castle_moves, black_castle_moves = white_king.castle, black_king.castle
            in_check_white, in_check_black = false, false
            white_exit_moves, black_exit_moves = [], []
            
            print_castle_moves(white_castle_moves, black_castle_moves)
            print_board(@board.rows)

            #Test For King Capture Incase for Both
            #--------------------------------------
            if @board.check(white_king.pos)
                puts "White king in check. Resolve check first."
                check_exits = @board.checkmate_exit(white_king)
                if check_exits.empty?
                    puts "Checkmate. Black wins!"
                    break
                else
                    white_exit_moves = check_exits
                    in_check_white = true
                end
            end

            if @board.check(black_king.pos)
                puts "Black king in check. Resolve check first."
                check_exits2 = @board.checkmate_exit(black_king)
                if check_exits2.empty?
                    puts "Checkmate. White wins!"
                    break
                else
                    black_exit_moves = check_exits2
                    in_check_black = true
                end
            end
            #--------------------------------------

            #add draw if only two kings left on board.

            #--------------------------------------


            #--------------------------------------

            s, d = prompt_move
            

            #Avoid check moves are made here.
            if in_check_white
                check_move(s, d, white_exit_moves)

            elsif in_check_black
                check_move(s, d, black_exit_moves)

            #Before moving on, check if its a piece in the first place.
            elsif is_null?(s)
                prompt_non_piece_error

            #Regular or special moves are made here.
            else

                if is_king?(s) && @board.rows[s[0]][s[1]].color == :white
                    castle_move(s, d, white_castle_moves)
                    
                elsif is_king?(s) && @board.rows[s[0]][s[1]].color == :black
                    castle_move(s, d, black_castle_moves)

                elsif is_pawn?(s) && [0, 7].include?(d[0])
                    promotion_move(s, d)
                    
                else
                    normal_move(s, d)
                end

            end
        end
    end

end

if __FILE__ == $PROGRAM_NAME
    p = Player.new("Player 1", :white)
    p = Player.new("Player 2", :black)
    g = Game.new()
    g.play
end