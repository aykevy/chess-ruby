module Simulation

    #Test 1:
    #King can capture a piece checking him while there is two pieces checking him.
    def simulation_1(board)
        simulate_intro = [
            [[1,3], [2,3]], [[2,3], [3,3]], [[6,3], [5,3]], 
            [[5,3], [4,3]], [[0,3], [2,3]], [[2,3], [4,1]],
            [[4,1], [4,3]], [[4,3], [7,3]], [[6,5], [5,5]],
            [[0,2], [5,6]]
        ]
        simulate_intro.each do | start, dest = sub_arr |
            board.move_piece(start, dest)
        end
    end

    #Test 2:
    #Another piece of the kings color can capture a piece that is currently
    #checking the king if the king can't check.
    def simulation_2(board)
        simulate_intro = [
            [[1,3], [2,3]], [[2,3], [3,3]], [[6,3], [5,3]], 
            [[5,3], [4,3]], [[0,3], [2,3]], [[2,3], [4,1]],
            [[4,1], [4,3]], [[4,3], [7,3]], [[0,1], [5,4]],
            [[7,1], [5,2]], [[7,0], [4,3]]
        ]

        simulate_intro.each do | start, dest = sub_arr |
            board.move_piece(start, dest)
        end
    end

    #Test 3:
    #Another simulation to show that you can capture with a king or just capture
    #with another piece when in check.
    def simulation_3(board)
        simulate_intro = [
            [[1,3], [2,3]], [[2,3], [3,3]], [[6,3], [5,3]], 
            [[5,3], [4,3]], [[0,3], [2,3]], [[2,3], [4,1]],
            [[4,1], [4,3]], [[4,3], [7,3]], [[7,1], [5,2]],
            [[7,0], [4,3]]
        ]
        simulate_intro.each do | start, dest = sub_arr |
            board.move_piece(start, dest)
        end
    end

    #Test 3.4
    #Another simulation with just two kings left and a pawn. This is to remove the
    #king shit

    def simulation_4(board)
        simulate_intro = [
            [[1,3], [2,3]], [[2,3], [3,3]], [[6,3], [5,3]], 
            [[5,3], [4,3]], [[0,3], [2,3]], [[2,3], [4,1]],
            [[4,1], [4,3]], [[4,3], [7,3]], [[7,1], [5,2]],
            [[7,0], [4,3]], [[7,3], [5,2]], [[6,1], [5,2]],
            
        ]
        simulate_intro.each do | start, dest = sub_arr |
            board.move_piece(start, dest)
        end
    end


    #Test 3.5
    #Another simulation to show that you can block to protect the king in check
    def simulation_5(board)
        simulate_intro = [
            [[1,3], [2,3]], [[2,3], [3,3]], [[6,3], [5,3]], 
            [[5,3], [4,3]], [[0,3], [2,3]], [[2,3], [4,1]],
            [[4,1], [4,3]], [[4,3], [7,3]], [[7,1], [5,2]],
            [[7,0], [4,3]], [[7,3], [5,2]]
        ]
        simulate_intro.each do | start, dest = sub_arr |
            board.move_piece(start, dest)
        end
    end

    #EDGE CASE: ENPASSANT TO ADD TO CHECKS FOR CHECKING THE KING

    #Test 4: After castling create a check

    #Test 5: After castling checkmate the other king

    #Test 6: Stalemate

end