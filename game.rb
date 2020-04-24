require_relative "player"
require_relative "board"
require_relative "tools/board_modules/display_module"
require_relative "tools/test_modules/simulation_module"

class Game

    include Simulation
    include Display

    def initialize
        @board = Board.new()
    end

    def get_kings
        white_king = []
        black_king = []
        @board.rows.each do | row |
            row.each do | piece |
                if piece.symbol == :king
                    piece.color == :white ? white_king = piece : black_king = piece
                end
            end
        end
        [white_king, black_king]
    end

    def is_king?(pos)
        row, col = pos
        @board.rows[row][col].symbol == :king
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

    def prompt_move
        puts
        puts "Please choose a piece to move: "
        start = gets.chomp.split(",")
        s = start.map(&:to_i)
        puts "Please choose a the destination: "
        destination = gets.chomp.split(",")
        d = destination.map(&:to_i)
        puts
        puts
        [s, d] #putting puts after returns [nil, nil]
    end

    def prompt_promotion(pawn)
        puts
        puts "Please choose a piece for #{pawn.color} pawn at position #{pawn.pos} to promote to: "
        puts "q for queen"
        puts "r for rook"
        puts "b for bishop"
        puts "n for knight"
        puts
        result = gets.chomp
        case result
        when "q"
            piece =  SlidingPiece.new(pawn.color, pawn.board, pawn.pos)
            piece.set_symbol(:queen)
            return piece
        when "r"
            piece =  SlidingPiece.new(pawn.color, pawn.board, pawn.pos)
            piece.set_symbol(:rook)
            return piece
        when "b"
            piece =  SlidingPiece.new(pawn.color, pawn.board, pawn.pos)
            piece.set_symbol(:bishop)
            return piece
        when "n"
            piece =  SteppingPiece.new(pawn.color, pawn.board, pawn.pos)
            piece.set_symbol(:night)
            return piece
        end
        "ERROR"
    end

    def play

        #simulation_4(@board)

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

            s, d = prompt_move

            #Make a 2nd option here, if in check, go to check list for valid

            if in_check_white
                #print white_exit_moves
                #print [s, d]
                if white_exit_moves.include?([s, d])
                    puts "VALID MOVE!"
                    puts
                    @board.move_piece(s, d)
                else
                    puts "INVALID MOVE!"
                    puts
                end

            elsif in_check_black
                if black_exit_moves.include?([s, d])
                    puts "VALID MOVE!"
                    puts
                    @board.move_piece(s, d)
                else
                    puts "INVALID MOVE!"
                    puts
                end

            elsif !@board.piece?(s)
                puts "INVALID MOVE! (That is not a piece)"
                puts


            #REGULAR MOVES HERE.

            else

                if is_king?(s) && @board.rows[s[0]][s[1]].color == :white

                    if @board.valid_move?(s, d) || white_castle_moves.include?(d)

                        if white_castle_moves.include?(d)
                            puts "VALID CASTLE MOVE!"
                            puts
                            do_castle(s, d)
                        else
                            puts "VALID MOVE!"
                            puts
                            @board.move_piece(s, d)
                        end
                    end
                        

                elsif is_king?(s) && @board.rows[s[0]][s[1]].color == :black

                    if @board.valid_move?(s, d) || black_castle_moves.include?(d)

                        if black_castle_moves.include?(d)
                            puts "VALID CASTLE MOVE!"
                            puts
                            do_castle(s, d)
                        else
                            puts "VALID MOVE!"
                            puts
                            @board.move_piece(s, d)
                        end
                    end


                else
                    if @board.valid_move?(s, d)
                        puts "VALID MOVE!"
                        puts
                        @board.move_piece(s, d)
                    else
                        puts "INVALID MOVE!"
                        puts
                    end

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