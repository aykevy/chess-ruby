require_relative "board"
require_relative "tools/board_modules/simulation_module"

class Game

    include Simulation

    def initialize
        @board = Board.new()
        @board.print_board
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
    

    def play

        simulation_2(@board)

        while true

            @board.print_board

            white_king, black_king = self.get_kings

            white_exit_moves = []
            black_exit_moves = []

            #Test For King Capture Incase for Both
            #--------------------------------------
            if @board.check(white_king.pos)
                puts "White king in check"
                check_exits = @board.checkmate_exit(white_king)
                if check_exits.empty?
                    puts "Black Wins!"
                    break
                else
                    white_exit_moves = check_exits
                end
                
            end

            if @board.check(black_king.pos)
                puts "Black king in check"
                check_exits2 = @board.checkmate_exit(black_king)
                if check_exits2.empty?
                    puts "White Wins!"
                    break
                else
                    black_exit_moves = check_exits2
                end
            end

            #--------------------------------------

            puts "Please choose a piece to move: "
            start = gets.chomp.split(",")
            s = start.map(&:to_i)
            puts "Please choose a the destination: "
            destination = gets.chomp.split(",")
            d = destination.map(&:to_i)


            #Make a 2nd option here, if in check, go to check list for valid
            if @board.valid_move?(s, d)
                puts "VALID MOVE!"
                @board.move_piece(s, d)
            else
                puts "INVALID MOVE!"
            end

        end

    end

end

if __FILE__ == $PROGRAM_NAME
    g = Game.new()
    g.play
end
