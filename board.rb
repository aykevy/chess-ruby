require_relative "tools/piece"
require_relative "tools/null_piece"
require_relative "tools/sliding_piece"
require_relative "tools/stepping_piece"
require_relative "tools/pawns"
require_relative "tools/board_modules/setup_module"
require_relative "tools/board_modules/display_module"

class Board

    include Setup
    include Display

    attr_accessor :rows, :moves_list

    def initialize
        @moves_list = []
        @rows = Array.new(8) { Array.new(8) }
        setup_board(@rows, self)
    end

    def copy
        dup_board = Board.new()
        dup_board.simulate(@moves_list)
        dup_board
    end

    def simulate(moves_list)
        moves_list.each do | start, dest = sub_arr |
            move_piece(start, dest)
        end
    end

    def piece?(pos)
        x, y = pos
        @rows[x][y].is_a?(Piece) && !@rows[x][y].is_a?(NullPiece)
    end

    def opposite_color?(pos)
        x, y = pos
        @board.rows[x][y].color != @color
    end

    def check(pos)
        @rows.each do | row |
            row.each do | piece |
                if piece?(piece.pos)
                    return true if piece.get_moves.include?(pos)
                end
            end
        end
        false
    end

    def check_king_exits(king)
        #The purpose of this function is to find moves and destinations for the king to go to
        #that would not put them in check including pieces.

        #TO SELF: MAKE EDGE CASE TO CHECK KING EXIT POSSIBLY ATTACKING A KING POSITION

        valid = []          #Actual Moves [[start_pos, dest_pos]] 
        invalid_des = []    #Invalid Destinations [dest_pos]

        moves = king.get_moves
        moves.each_with_index do | move, idx |

            dup_board = copy
            dup_piece = king.copy_king(king.color, dup_board, move, king.symbol)

            r1, c1 = king.pos
            r2, c2 = move

            dup_board.rows[r2][c2] = dup_piece
            dup_board.rows[r1][c1] = NullPiece.new(:color, dup_board, [r1, c1])
            dup_board.check(move) ? invalid_des << move : valid << [[r1, c1], move]

        end
        [valid, invalid_des]
    end

    def check_king_rescue(king)
        #The purpose of this function is to check if there are any pieces that can capture
        #the attacking piece that is currently checking the king.

        checking_pieces = []

        @rows.each do | row |
            row.each do | piece |
                checking_pieces << piece if piece?(piece.pos) && piece.get_moves.include?(king.pos)
            end
        end

        viable_moves = []

        #If amount of pieces checking you == 2 or higher AND valid is empty
        #simply return checkmated.
        if checking_pieces.length > 1
            return viable_moves

        #If amount of pieces checking you == 1
        #Simply see if any of ur other pieces can kill OFF that piece.
        #If so, then u are not checkmated.
        else
            to_kill = checking_pieces.pop
            @rows.each do | row |
                row.each do | piece |
                    if piece.color == king.color && piece.symbol != king.symbol
                        viable_moves << [piece.pos, to_kill.pos] if piece?(piece.pos) && piece.get_moves.include?(to_kill.pos)
                    end
                end
            end
        end

        puts "Not yet checkmated, possible moves kill checker: #{viable_moves}" unless viable_moves.empty?
        return viable_moves
    end

    def checkmate_exit(king)
        valid_moves, _ = check_king_exits(king)

        #Gotta implement block pieces for the king before doing rescue

        if valid_moves.empty?
            return check_king_rescue(king)
        else
            valid_moves += check_king_rescue(king)
            puts "Not yet checkmated, possible moves: #{valid_moves}"
            return valid_moves
        end
    end

    def stalemate(color)
        puts "Stalemate"
    end

    def valid_move?(start, dest)
        x, y = start
        valid_moves = @rows[x][y].get_moves
        puts
        print "Valid destinations: #{valid_moves}"
        puts
        valid_moves.include?(dest)
    end

    def move_piece(start_pos, end_pos)
        moves_list << [start_pos, end_pos]
        r1, c1 = start_pos
        r2, c2 = end_pos

        #if @rows[r1][c1].is_a?(NullPiece)
            #raise "Error, starting position is a null_piece"
        #elsif @rows[r2][c2].is_a?(Piece) && !@rows[r2][c2].is_a?(NullPiece) #specify error on null cause null derives from piece
            #raise "Error, there is a piece there." #Tentative, will change for capturing.
        #end

        piece_color = @rows[r1][c1].color
        piece_type = @rows[r1][c1].symbol

        @rows[r1][c1] = NullPiece.new(:color, self, [r1, c1])

        case piece_type
        when :pawn
            @rows[r2][c2] = Pawn.new(piece_color, self, [r2, c2])
        when :rook, :bishop, :queen
            @rows[r2][c2] = SlidingPiece.new(piece_color, self, [r2, c2])
        when :knight, :king
            @rows[r2][c2] = SteppingPiece.new(piece_color, self, [r2, c2])
        end
        @rows[r2][c2].set_symbol(piece_type)
        
    end
end