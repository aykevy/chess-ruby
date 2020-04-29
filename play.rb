require_relative "game.rb"
require_relative "tools/board_modules/prompt_module"
require_relative "tools/board_modules/display_module"

#This class allows the player to play a game of chess.

class Play

    include Prompt
    include Display

    attr_accessor :game

    #Initializes a new game.
    def initialize
        @game = Game.new
    end

    #This is the game loop that continues until checkmate or draws.
    def play
        while true
            #Set up king informations on both sides.
            white_king, black_king = @game.get_kings
            white_castle_moves, in_check_white, white_exit_moves = @game.get_kings_info(white_king)
            black_castle_moves, in_check_black, black_exit_moves = @game.get_kings_info(black_king)

            #Print Interface (Can remove trackers by running individual functions from display)
            #Version 1 has the tiles (may be hard on the eyes).
            #Version 2 uses dots (easier on the eyes).
            print_tracker_and_board_v2(@game.turn, white_castle_moves, black_castle_moves, @game.get_enpassant_positions, @game.board.rows, @game.board.tiles)
           
            #Make moves depending on turn.
            if @game.turn.color == :white
                w_update = @game.checkmate_or_drawn?(white_king)
                break if w_update.length == 1 && w_update.first == "Done"
                in_check_white, white_exit_moves = w_update if w_update.length == 2
                s, d = prompt_move
                @game.move_selection(s, d, in_check_white, white_exit_moves, white_castle_moves)
            else
                b_update = @game.checkmate_or_drawn?(black_king)
                break if b_update.length == 1 && b_update.first == "Done"
                in_check_black, black_exit_moves = b_update if b_update.length == 2
                s, d = prompt_move
                @game.move_selection(s, d, in_check_black, black_exit_moves, black_castle_moves)
            end
        end
    end

end

if __FILE__ == $PROGRAM_NAME
    game = Play.new
    game.play
end