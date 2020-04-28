#This module is mainly used to create test cases. By simulating the board before
#manually making the moves, it makes things easier to test.

module Simulation

    #Test 1:
    #King can capture a piece checking him while there is two pieces checking him.
    def simulation_1(board)
        simulate_intro = [
            [[1, 3], [2, 3]], [[2, 3], [3, 3]], [[6, 3], [5, 3]], 
            [[5, 3], [4, 3]], [[0, 3], [2, 3]], [[2, 3], [4, 1]],
            [[4, 1], [4, 3]], [[4, 3], [7, 3]], [[6, 5], [5, 5]],
            [[0, 2], [5, 6]]
        ]
        simulate_intro.each do | start, dest = sub_arr |
            board.move_piece(start, dest)
        end
    end

    #Test 2:
    #Another piece of the king's color can capture a piece that is currently
    #checking the king if the king can't escape or capture.
    def simulation_2(board)
        simulate_intro = [
            [[1, 3], [2, 3]], [[2, 3], [3, 3]], [[6, 3], [5, 3]], 
            [[5, 3], [4, 3]], [[0, 3], [2, 3]], [[2, 3], [4, 1]],
            [[4, 1], [4, 3]], [[4, 3], [7, 3]], [[0, 1], [5, 4]],
            [[7, 1], [5, 2]], [[7, 0], [4, 3]]
        ]
        simulate_intro.each do | start, dest = sub_arr |
            board.move_piece(start, dest)
        end
    end

    #Test 3:
    #Another simulation to show that you can capture with the king himself or capture
    #with another piece when in check.
    def simulation_3(board)
        simulate_intro = [
            [[1, 3], [2, 3]], [[2, 3], [3, 3]], [[6, 3], [5, 3]], 
            [[5, 3], [4, 3]], [[0, 3], [2, 3]], [[2, 3], [4, 1]],
            [[4, 1], [4, 3]], [[4, 3], [7, 3]], [[7, 1], [5, 2]],
            [[7, 0], [4, 3]]
        ]
        simulate_intro.each do | start, dest = sub_arr |
            board.move_piece(start, dest)
        end
    end

    #Test 4:
    #Another simulation with just two kings left and a pawn.
    def simulation_4(board)
        simulate_intro = [
            [[1, 3], [2, 3]], [[2, 3], [3, 3]], [[6, 3], [5, 3]], 
            [[5, 3], [4, 3]], [[0, 3], [2, 3]], [[2, 3], [4, 1]],
            [[4, 1], [4, 3]], [[4, 3], [7, 3]], [[7, 1], [5, 2]],
            [[7, 0], [4, 3]], [[7, 3], [5, 2]], [[6, 1], [5, 2]],
        ]
        simulate_intro.each do | start, dest = sub_arr |
            board.move_piece(start, dest)
        end
    end

    #Test 5:
    #Another simulation to show that you can block to protect the king in check.
    def simulation_5(board)
        simulate_intro = [
            [[1, 3], [2, 3]], [[2, 3], [3, 3]], [[6, 3], [5, 3]], 
            [[5, 3], [4, 3]], [[0, 3], [2, 3]], [[2, 3], [4, 1]],
            [[4, 1], [4, 3]], [[4, 3], [7, 3]], [[7, 1], [5, 2]],
            [[7, 0], [4, 3]], [[7, 3], [5, 2]]
        ]
        simulate_intro.each do | start, dest = sub_arr |
            board.move_piece(start, dest)
        end
    end

    #Test 6:
    #Sets the board up and allows you to make a castling move.
    def simulation_6(board)
        simulate_intro = [
            [[6, 1], [5, 1]], [[6, 2], [5, 2]], [[6, 3], [5, 3]], 
            [[7, 1], [5, 0]], [[7, 2], [6, 1]], [[7, 3], [6, 3]],
            [[1, 3], [3, 3]], [[6, 4], [4, 4]], [[0, 3], [2, 3]],
            [[2, 3], [4, 5]], [[4, 5], [5, 4]], [[7, 5], [6, 4]],
            [[7, 6], [5, 7]]
        ]
        simulate_intro.each do | start, dest = sub_arr |
            board.move_piece(start, dest)
        end
    end

    #Test 7:
    #Castling works if there is a piece checking through a pathway where
    #the king is not passing through, this is the edge case for where there are
    #three empty spaces between king and rook on the left of the board. The most
    #left empty space does not have to check for checks as only the rook will 
    #pass through it.
    def simulation_7(board)
        simulate_intro = [
            [[6, 1], [5, 1]], [[6, 2], [5, 2]], [[6, 3], [5, 3]], 
            [[7, 1], [5, 0]], [[7, 2], [6, 1]], [[7, 3], [6, 3]],
            [[1, 3], [3, 3]], [[6, 4], [4, 4]], [[0, 3], [2, 3]],
            [[2, 3], [4, 5]], [[4, 5], [5, 4]], [[7, 5], [6, 4]],
            [[7, 6], [5, 7]], [[5, 4], [5, 3]], [[5, 3], [5, 2]],
            [[5, 2], [5, 1]], [[5, 1], [6, 1]], [[6, 1], [3, 1]],
            [[6, 3], [4, 2]], [[4, 2], [1, 2]], [[1, 2], [0, 1]],
            [[0, 1], [1, 1]], [[0, 2], [2, 4]], [[1, 1], [3, 1]],
            [[2, 4], [1, 3]]
        ]
        simulate_intro.each do | start, dest = sub_arr |
            board.move_piece(start, dest)
        end
    end

    #Test 8:
    #Sets up board before you can do a castle to cause other king to be in check.
    def simulation_8(board)
        simulate_intro = [
            [[6, 1], [5, 1]], [[6, 2], [5, 2]], [[6, 3], [5, 3]], 
            [[7, 1], [5, 0]], [[7, 2], [6, 1]], [[7, 3], [6, 3]],
            [[1, 3], [3, 3]], [[6, 4], [4, 4]], [[0, 3], [2, 3]],
            [[2, 3], [4, 5]], [[4, 5], [5, 4]], [[7, 5], [6, 4]],
            [[7, 6], [5, 7]], [[5, 4], [5, 3]], [[5, 3], [5, 2]],
            [[5, 2], [5, 1]], [[5, 1], [6, 1]], [[6, 1], [3, 1]],
            [[6, 3], [4, 2]], [[4, 2], [1, 2]], [[1, 2], [0, 1]],
            [[0, 1], [1, 1]], [[0, 2], [2, 4]], [[1, 1], [3, 1]],
            [[2, 4], [1, 3]], [[7, 4], [7, 3]], [[3, 1], [3, 3]],
            [[3, 3], [5, 1]], [[1, 3], [2, 4]]
        ]
        simulate_intro.each do | start, dest = sub_arr |
            board.move_piece(start, dest)
        end
    end
    
    #Test 9:
    #This is to setup for testing stalemate.
    def simulation_9(board)
        simulate_intro = [
            [[6, 1], [5, 1]], [[6, 2], [5, 2]], [[6, 3], [5, 3]], 
            [[7, 1], [5, 0]], [[7, 2], [6, 1]], [[7, 3], [6, 3]],
            [[1, 3], [3, 3]], [[6, 4], [4, 4]], [[0, 3], [2, 3]],
            [[2, 3], [4, 5]], [[4, 5], [5, 4]], [[7, 5], [6, 4]],
            [[7, 6], [5, 7]], [[5, 4], [5, 3]], [[5, 3], [5, 2]],
            [[5, 2], [5, 1]], [[5, 1], [6, 1]], [[6, 1], [3, 1]],
            [[6, 3], [4, 2]], [[4, 2], [1, 2]], [[1, 2], [0, 1]],
            [[0, 1], [1, 1]], [[0, 2], [2, 4]], [[1, 1], [3, 1]],
            [[2, 4], [1, 3]], [[7, 4], [7, 3]], [[3, 1], [3, 3]],
            [[3, 3], [5, 1]], [[1, 3], [2, 4]], [[1, 5], [3, 5]],
            [[3, 5], [4, 5]], [[4, 5], [5, 5]], [[5, 5], [6, 6]],
            [[0, 0], [0, 1]], [[0, 1], [5, 1]], [[5, 1], [5, 0]],
            [[5, 0], [6, 0]], [[7, 0], [7, 2]], [[7, 2], [2, 2]],
            [[2, 2], [2, 4]], [[2, 4], [2, 6]], [[2, 6], [1, 6]],
            [[1, 6], [1, 7]], [[1, 7], [0, 7]], [[0, 7], [0, 6]],
            [[6, 0], [6, 4]], [[6, 4], [6, 5]], [[6, 5], [5, 5]],
            [[0, 6], [6, 6]], [[5, 5], [4, 7]], [[4, 7], [5, 7]],
            [[0, 5], [2, 7]], [[6, 6], [2, 7]], [[2, 7], [1, 0]],
            [[7, 3], [5, 7]], [[1, 0], [6, 7]], [[5, 7], [6, 7]],
            [[6, 7], [7, 7]], [[4, 4], [1, 4]], [[7, 7], [3, 5]]
        ]
        simulate_intro.each do | start, dest = sub_arr |
            board.move_piece(start, dest)
        end
    end

    #Test 10:
    #Should not cause your own colored king to be in check if you do a move.
    def simulation_10(board)
        simulate_intro = [
            [[6, 1], [5, 1]], [[6, 2], [5, 2]], [[6, 3], [5, 3]], 
            [[7, 1], [5, 0]], [[7, 2], [6, 1]], [[7, 3], [6, 3]],
            [[1, 3], [3, 3]], [[6, 4], [4, 4]], [[0, 3], [2, 3]],
            [[2, 3], [4, 5]], [[4, 5], [5, 4]], [[7, 5], [6, 4]],
            [[7, 6], [5, 7]], [[5, 4], [5, 3]], [[5, 3], [5, 2]],
            [[5, 2], [5, 1]], [[5, 1], [6, 1]], [[6, 1], [3, 1]],
            [[6, 3], [4, 2]], [[4, 2], [1, 2]], [[1, 2], [0, 1]],
            [[0, 1], [1, 1]], [[0, 2], [2, 4]], [[1, 1], [3, 1]],
            [[2, 4], [1, 3]], [[7, 4], [7, 2]], [[3, 1], [3, 2]],
            [[0, 0], [0, 2]]
        ]
        simulate_intro.each do | start, dest = sub_arr |
            board.move_piece(start, dest)
        end
    end

    #Test 11:
    #Enpassant should not cause king in check.
    def simulation_11(board)
        simulate_intro = [
            [[6, 1], [5, 1]], [[6, 2], [5, 2]], [[6, 3], [5, 3]], 
            [[7, 1], [5, 0]], [[7, 2], [6, 1]], [[7, 3], [6, 3]],
            [[1, 3], [3, 3]], [[6, 4], [4, 4]], [[0, 3], [2, 3]],
            [[2, 3], [4, 5]], [[4, 5], [5, 4]], [[7, 5], [6, 4]],
            [[7, 6], [5, 7]], [[5, 4], [5, 3]], [[5, 3], [5, 2]],
            [[5, 2], [5, 1]], [[5, 1], [6, 1]], [[6, 1], [3, 1]],
            [[6, 3], [4, 2]], [[4, 2], [1, 2]], [[1, 2], [0, 1]],
            [[0, 1], [1, 1]], [[0, 2], [2, 4]], [[1, 1], [3, 1]],
            [[2, 4], [1, 3]], [[7, 4], [7, 3]], [[3, 1], [3, 3]],
            [[3, 3], [5, 1]], [[1, 3], [2, 4]], [[7, 3], [5, 4]],
            [[0, 0], [3, 4]], [[2, 4], [0, 2]], [[1, 4], [1, 3]],
            [[3, 4], [1, 4]], [[4, 4], [3, 4]]
        ]
        simulate_intro.each do | start, dest = sub_arr |
            board.move_piece(start, dest)
        end
    end

    #Test 12:
    #Promotion should not cause king in check.
    def simulation_12(board)
        simulate_intro = [
            [[6, 1], [5, 1]], [[6, 2], [5, 2]], [[6, 3], [5, 3]], 
            [[7, 1], [5, 0]], [[7, 2], [6, 1]], [[7, 3], [6, 3]],
            [[1, 3], [3, 3]], [[6, 4], [4, 4]], [[0, 3], [2, 3]],
            [[2, 3], [4, 5]], [[4, 5], [5, 4]], [[7, 5], [6, 4]],
            [[7, 6], [5, 7]], [[5, 4], [5, 3]], [[5, 3], [5, 2]],
            [[5, 2], [5, 1]], [[5, 1], [6, 1]], [[6, 1], [3, 1]],
            [[6, 3], [4, 2]], [[4, 2], [1, 2]], [[1, 2], [0, 1]],
            [[0, 1], [1, 1]], [[0, 2], [2, 4]], [[1, 1], [3, 1]],
            [[2, 4], [1, 3]], [[7, 4], [7, 3]], [[3, 1], [3, 3]],
            [[3, 3], [5, 1]], [[1, 3], [2, 4]], [[7, 3], [5, 4]],
            [[0, 0], [3, 4]], [[2, 4], [0, 2]], [[1, 4], [1, 3]],
            [[3, 4], [1, 4]], [[4, 4], [3, 4]], [[5, 4], [5, 5]],
            [[0, 4], [6, 3]], [[1, 3], [6, 2]], [[0, 2], [6, 1]],
            [[5, 1], [0, 1]]
        ]
        simulate_intro.each do | start, dest = sub_arr |
            board.move_piece(start, dest)
        end
    end

    #Test 13:
    #Enpassant is the last option move to prevent checkmate.
    def simulation_13(board)
        simulate_intro = [
            [[6, 1], [5, 1]], [[6, 2], [5, 2]], [[6, 3], [5, 3]], 
            [[7, 1], [5, 0]], [[7, 2], [6, 1]], [[7, 3], [6, 3]],
            [[1, 3], [3, 3]], [[6, 4], [4, 4]], [[0, 3], [2, 3]],
            [[2, 3], [4, 5]], [[4, 5], [5, 4]], [[7, 5], [6, 4]],
            [[7, 6], [5, 7]], [[5, 4], [5, 3]], [[5, 3], [5, 2]],
            [[5, 2], [5, 1]], [[5, 1], [6, 1]], [[6, 1], [3, 1]],
            [[6, 3], [4, 2]], [[4, 2], [1, 2]], [[1, 2], [0, 1]],
            [[0, 1], [1, 1]], [[0, 2], [2, 4]], [[1, 1], [3, 1]],
            [[2, 4], [1, 3]], [[7, 4], [4, 3]], [[6, 5], [3, 5]],
            [[0, 6], [2, 6]], [[0, 0], [0, 2]], [[0, 7], [5, 6]],
            [[0, 4], [2, 3]] 
        ]
        simulate_intro.each do | start, dest = sub_arr |
            board.move_piece(start, dest)
        end
    end

    #Test 14:
    def simulation_14(board)
        simulate_intro = [
            [[6, 1], [5, 1]], [[6, 2], [5, 2]], [[6, 3], [5, 3]], 
            [[7, 1], [5, 0]], [[7, 2], [6, 1]], [[7, 3], [6, 3]],
            [[1, 3], [3, 3]], [[6, 4], [4, 4]], [[0, 3], [2, 3]],
            [[2, 3], [4, 5]], [[4, 5], [5, 4]], [[7, 5], [6, 4]],
            [[7, 6], [5, 7]], [[5, 4], [5, 3]], [[5, 3], [5, 2]],
            [[5, 2], [5, 1]], [[5, 1], [6, 1]], [[6, 1], [3, 1]],
            [[6, 3], [4, 2]], [[4, 2], [1, 2]], [[1, 2], [0, 1]],
            [[0, 1], [1, 1]], [[0, 2], [2, 4]], [[1, 1], [3, 1]],
            [[2, 4], [1, 3]], [[7, 4], [4, 3]], [[6, 5], [3, 5]],
            [[0, 6], [2, 6]], [[0, 0], [0, 2]], [[0, 7], [5, 6]],
            [[0, 4], [2, 3]], [[5, 7], [4, 4]], [[4, 4], [5, 7]],
            [[1, 3], [6, 2]]
        ]
        simulate_intro.each do | start, dest = sub_arr |
            board.move_piece(start, dest)
        end
    end

    #Test 15:
    #Stalemate with enpassant being the last available move.
    def simulation_15(board)

    end

    #Test 16:
    #Insufficient Material Draw
    def simulation_15(board)

    end

end