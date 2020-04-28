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

    #Creates a copy of the board by creating a new board instance and passing
    #a set of moves for the duplicate to simulate and be up to date with the
    #current board.
    def copy
        dup_board = Board.new()
        dup_board.simulate(@moves_list)
        dup_board
    end

    #When given a list, the function will move all the pieces in order as given.
    def simulate(moves_list)
        moves_list.each do | sub_arr |
            if sub_arr.length == 2
                start, dest = sub_arr
                move_piece(start, dest)
            else
                start, dest, promo = sub_arr
                move_piece(start, dest, promo)
            end
        end
    end

    #This function gets you the a king's location based on the given color.
    def kings_location(color)
        @rows.each do | row |
            row.each do | piece |
                return piece.pos if piece.symbol == :king && piece.color == color
            end
        end
    end

    #Will check if the current position is part of the piece class and check if
    #it is also not a empty space.
    def piece?(pos)
        x, y = pos
        @rows[x][y].is_a?(Piece) && !@rows[x][y].is_a?(NullPiece)
    end

    #Will check if the given position is in check.
    def check(pos)
        king_color = @rows[pos[0]][pos[1]].color #New
        @rows.each do | row |
            row.each do | piece |
                if piece?(piece.pos) && piece.color != king_color
                    return true if piece.get_moves.include?(pos)
                end
            end
        end
        false
    end

    #Helper function. Will check if the given piece has any valid moves.
    #Given a piece, it will check to see if they have any valid moves and on
    #top of that have moves that won't affect a kings position. King_pos is nil
    #by default because you may want to check valid moves on a king piece so you
    #do not need require the king_pos. Returns a list of valid moves.
    def check_valid_moves(piece, king_pos = nil)
        valid = [] #[ [[start_row, start_col], [dest_row, dest_col]], ... , etc. ]
        moves = piece.get_moves
        moves.each_with_index do | move, idx |
            dup_board = copy
            dup_piece = piece.copy(piece.color, dup_board, move, piece.symbol)

            r1, c1 = piece.pos
            r2, c2 = move

            dup_board.rows[r2][c2] = dup_piece
            dup_board.rows[r1][c1] = NullPiece.new(:color, dup_board, [r1, c1])

            if king_pos.nil?
                valid << [[r1, c1], move] unless dup_board.check(move)
            else
                valid << [[r1, c1], move] unless dup_board.check(king_pos)
            end
        end
        valid
    end

    #Similar to check_valid_moves, this only checks one move and they are special cases.
    #If you are enpassanting, prev_dest will be used to delete an extra place on
    #the board (the piece getting captured). Otherwise you'll be using this for promotion
    #as well. The purpose of this function is to return true or false whether or not
    #the king will be in check from doing these two moves.
    def check_valid_pawn_special?(intended_move, piece, king_pos, prev_dest = nil)
        dup_board = copy
        dup_piece = piece.copy(piece.color, dup_board, intended_move, piece.symbol)

        r1, c1 = piece.pos
        r2, c2 = intended_move

        dup_board.rows[r2][c2] = dup_piece
        dup_board.rows[r1][c1] = NullPiece.new(:color, dup_board, [r1, c1])

        unless prev_dest.nil?
            r3, c3 = prev_dest
            dup_board.rows[r3][c3] = NullPiece.new(:color, dup_board, [r3, c3])
        end

        #If causes king to be in check, return false because of invalid move.
        dup_board.check(king_pos) ? false : true
    end

    #This function checks if the king can move away to a safe position or can
    #capture a position through the king's movements and returns a set of valid
    #moves.
    def check_king_exits(king)
        valid = check_valid_moves(king)
        unless valid.empty?
            puts "Not yet checkmated, possible moves by the king to avoid check: \n"
            print_moves(valid)
        end
        puts
        valid
    end

    #This function checks if the king can be protected by other pieces from check
    #using the ones that are the king's color. This will return a set of valid moves
    #that will either block the king from being in check or capture the checking piece.
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

    #This function returns all of the possible moves when the king is in check. If
    #the moves returned is empty, then it is checkmate for the king.
    def checkmate_exit(king)
        valid_moves = check_king_exits(king)
        valid_moves += check_king_guards(king)
        valid_moves
    end

    #This function will return whether or not the current turn is in stalemate.
    #If a piece has no legal moves and not in check, then its stalemate.
    def stalemate(color)
        count = 0
        @rows.each do | row |
            row.each do | piece |
                if piece.color == color
                    count += get_all_legal_moves(piece.pos).length
                end
            end
        end
        count == 0
    end

    #This function returns a set of destinations after going through a bunch of
    #tests like testing for valid moves that wouldn't put the king in check.
    def get_all_legal_moves(starting_pos)
        x, y = starting_pos
        piece = @rows[x][y]
        if piece.symbol != :king
            king_pos = kings_location(piece.color)
            return check_valid_moves(piece, king_pos).map { | start, dest| dest }
        else
            #We don't add a king_pos cause we're checking the king position
            #itself after it moves.
            return check_valid_moves(piece).map { | start, dest| dest }
        end
    end

    #This function returns true if the given destination is a valid move.
    def valid_move?(start, dest)
        valid_moves = get_all_legal_moves(start)
        #Uncomment if you want to see where the valid destinations are for a move.
        puts
        print "Valid normal move (no castle/enpassant) destinations: #{valid_moves}"
        puts
        valid_moves.include?(dest)
    end

    #Does normal board movement from start to destination.
    def normal_placement(start_pos, end_pos)
        @moves_list << [start_pos, end_pos]
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
        @rows[r2][c2].moved = true

    end

    #Does board movement for promotions of the pawn.
    def promotion_placement(start_pos, end_pos, promotion)
        @moves_list << [start_pos, end_pos, promotion]
        r1, c1 = start_pos
        r2, c2 = end_pos

        piece_color, desired_promo = promotion
        @rows[r1][c1] = NullPiece.new(:color, self, [r1, c1])

        case desired_promo
        when "q"
            @rows[r2][c2] = SlidingPiece.new(piece_color, self, [r2, c2])
            @rows[r2][c2].set_symbol(:queen)
            @rows[r2][c2].moved = true
        when "r"
            @rows[r2][c2] = SlidingPiece.new(piece_color, self, [r2, c2])
            @rows[r2][c2].set_symbol(:rook)
            @rows[r2][c2].moved = true 
        when "b"
            @rows[r2][c2] = SlidingPiece.new(piece_color, self, [r2, c2])
            @rows[r2][c2].set_symbol(:bishop)
            @rows[r2][c2].moved = true 
        when "n"
            @rows[r2][c2] = SteppingPiece.new(piece_color, self, [r2, c2])
            @rows[r2][c2].set_symbol(:knight)
            @rows[r2][c2].moved = true 
        end
    end

    #This function just moves one piece at the a given start position to
    #the destination. It just moves the piece, does not check for validity.
    #This is good for testing if you wanna simulate a premade board for the
    #intro.
    def move_piece(start_pos, end_pos, promotion = nil)
        if promotion.nil?
            normal_placement(start_pos, end_pos)
        else
            promotion_placement(start_pos, end_pos, promotion)
        end
    end

end