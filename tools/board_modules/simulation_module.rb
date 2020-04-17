module Simulation

    #King can capture a piece checking him while there is two pieces
    def simulation_1(board)
        simulate_intro = [
            [[1,3], [2,3]], 
            [[2,3], [3,3]], 
            [[6,3], [5,3]], 
            [[5,3], [4,3]],
            [[0,3], [2,3]],
            [[2,3], [4,1]],
            [[4,1], [4,3]],
            [[4,3], [7,3]],
            [[6,5], [5,5]],
            [[0,2], [5,6]]
        ]
        simulate_intro.each do | start, dest = sub_arr |
            board.move_piece(start, dest)
        end
    end

    #Another piece of the kings color can capture a piece that is currently
    #checkign the king.
    def simulation_2(board)
        simulate_intro = [
            [[1,3], [2,3]], 
            [[2,3], [3,3]], 
            [[6,3], [5,3]], 
            [[5,3], [4,3]],
            [[0,3], [2,3]],
            [[2,3], [4,1]],
            [[4,1], [4,3]],
            [[4,3], [7,3]],
            [[0,1], [5,4]],
            [[7,1], [5,2]],
            [[7,0], [4,3]]
        ]

        simulate_intro.each do | start, dest = sub_arr |
            board.move_piece(start, dest)
        end
    end

end