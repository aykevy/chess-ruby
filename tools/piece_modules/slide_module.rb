#This module gets you all the positions of every direction on the board
#relative to the piece. It does not check for valid or invalid positions nor does
#it check for blocked positions, it simply returns all possible placements on the 
#board for bishops, rooks, and queens.

module Slideable

    #Gets you all positions from the given start position to the top left diagonally.
    def top_left_diagonal(pos)
        possible_moves = []
        x, y = pos
        until x <= 0 || y <= 0
            possible_moves << [x - 1, y - 1] if x - 1 >= 0 && y - 1 >= 0
            x -= 1
            y -= 1
        end
        possible_moves
    end

    #Gets you all positions from the given start position to the top right diagonally.
    def top_right_diagonal(pos)
        possible_moves = []
        x, y = pos
        until x <= 0 || y >= 7
            possible_moves << [x - 1, y + 1] if x - 1 >= 0 && y + 1 <= 7
            x -= 1
            y += 1
        end
        possible_moves
    end

    #Gets you all positions from the given start position to the bottom left diagonally.
    def bottom_left_diagonal(pos)
        possible_moves = []
        x, y = pos
        until x >= 7 || y <= 0
            possible_moves << [x + 1, y - 1] if x + 1 <= 7 && y - 1 >= 0
            x += 1
            y -= 1
        end
        possible_moves
    end

    #Gets you all positions from the given start position to the bottom right diagonally.
    def bottom_right_diagonal(pos)
        possible_moves = []
        x, y = pos
        until x >= 7 || y >= 7
            possible_moves << [x + 1, y + 1] if x + 1 <= 7 && y + 1 <= 7
            x += 1
            y += 1
        end
        possible_moves
    end

    #Gets you all positions from the given start position to the top vertically.
    def center_top(pos)
        possible_moves = []
        x, y = pos
        until x <= 0
            possible_moves << [x - 1, y] if x - 1 >= 0
            x -= 1
        end
        possible_moves
    end

    #Gets you all positions from the given start position to the bottom vertically.
    def center_bottom(pos)
        possible_moves = []
        x, y = pos
        until x >= 7
            possible_moves << [x + 1, y] if x + 1 <= 7
            x += 1
        end
        possible_moves
    end

    #Gets you all positions from the given start position to the left horizontally.
    def center_left(pos)
        possible_moves = []
        x, y = pos
        until y <= 0
            possible_moves << [x, y - 1] if y - 1 >= 0
            y -= 1
        end
        possible_moves
    end

    #Gets you all positions from the given start position to the right horizontally.
    def center_right(pos)
        possible_moves = []
        x, y = pos
        until y >= 7
            possible_moves << [x, y + 1] if y + 1 <= 7
            y += 1
        end
        possible_moves
    end

    #Gets you an array of directions that are arrays of all possible positions
    #diagonally. Primarily used for bishops.
    def diagonal_moves(pos) 
        top_left = top_left_diagonal(pos)
        top_right = top_right_diagonal(pos)
        bottom_left = bottom_left_diagonal(pos)
        bottom_right = bottom_right_diagonal(pos)
        [top_left, top_right, bottom_left, bottom_right]
    end

    #Gets you an array of directions that are arrays of all possible positions
    #horizontally and vertically. Primarily used for rooks.
    def horizontal_vertical_moves(pos)
        top = center_top(pos)
        left = center_left(pos)
        right = center_right(pos)
        bottom = center_bottom(pos)
        [top, left, right, bottom]
    end

    #Gets you an array of directions that are arrays of all possible positions
    #diagonally, horizontally, and vertically. Primarily used for queens.
    def all_directions(pos)
        diagonal_moves(pos) + horizontal_vertical_moves(pos)
    end

end