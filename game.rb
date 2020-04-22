require_relative "player"
require_relative "board"
require_relative "tools/board_modules/simulation_module"
require_relative "tools/board_modules/display_module"

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

    def prompt
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
    
    def play

        simulation_3(@board)

        while true

            print_board(@board.rows)

            white_king, black_king = self.get_kings
            in_check_white, in_check_black = false, false
            white_exit_moves, black_exit_moves = [], []

            #Test For King Capture Incase for Both
            #--------------------------------------
            if @board.check(white_king.pos)
                puts "White king in check."
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
                puts "Black king in check."
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

            s, d = prompt

            #Make a 2nd option here, if in check, go to check list for valid

            if in_check_white
                #print white_exit_moves
                #print [s, d]
                puts "===ERROR: MUST REMOVE CHECK WHITE!==="
                if white_exit_moves.include?([s, d])
                    
                    puts "VALID MOVE!"
                    puts
                    @board.move_piece(s, d)
                else
                    puts "INVALID MOVE!"
                    puts
                end

            elsif in_check_black
                puts "===ERROR: MUST REMOVE CHECK BLACK!==="
                if black_exit_moves.include?([s, d])
                    puts "VALID MOVE!"
                    puts
                    @board.move_piece(s, d)
                else
                    puts "INVALID MOVE!"
                    puts
                end

            elsif !@board.piece?(s)
                puts "INVALID MOVE! (That is not a piece you selected)"
                puts

            else
                if @board.valid_move?(s, d) && !is_king?(d) #test this
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

if __FILE__ == $PROGRAM_NAME
    p = Player.new("Player 1", :white)
    p = Player.new("Player 2", :black)
    g = Game.new()
    g.play
end