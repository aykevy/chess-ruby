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

    def check_valid_moves(piece, checking_pos = nil)

        valid = [] #[ [[start_row, start_col], [dest_row, dest_col]] ] 
        moves = piece.get_moves
        moves.each_with_index do | move, idx |

            dup_board = copy
            dup_piece = piece.copy(piece.color, dup_board, move, piece.symbol)

            r1, c1 = piece.pos
            r2, c2 = move

            dup_board.rows[r2][c2] = dup_piece
            dup_board.rows[r1][c1] = NullPiece.new(:color, dup_board, [r1, c1])

            if checking_pos.nil?
                valid << [[r1, c1], move] unless dup_board.check(move)
            else
                valid << [[r1, c1], move] unless dup_board.check(checking_pos)
            end

        end
        valid
    end


    def check_king_exits(king)
        valid = check_valid_moves(king)

        unless valid.empty?
            puts "Not yet checkmated, possible moves by the king to avoid check: \n"
            print_moves(valid)
        end

        puts
        valid
    end

    def check_king_guards(king)
        valid = []

        @rows.each do | row |
            row.each do | piece |
                if piece?(piece.pos) && piece.color == king.color
                    valid += check_valid_moves(piece, king.pos)
                end
            end
        end

        unless valid.empty?
            puts "Not yet checkmated, possible moves that will block/capture checker: \n"
            print_moves(valid)
        end

        puts
        valid
    end

    def checkmate_exit(king)
        valid_moves = check_king_exits(king)
        valid_moves += check_king_guards(king)
        puts "=================================================================================="
        puts
        valid_moves
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