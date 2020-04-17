module Slideable

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

    def center_top(pos)
        possible_moves = []
        x, y = pos
        until x <= 0
            possible_moves << [x - 1, y] if x - 1 >= 0
            x -= 1
        end
        possible_moves
    end

    def center_bottom(pos)
        possible_moves = []
        x, y = pos
        until x >= 7
            possible_moves << [x + 1, y] if x + 1 <= 7
            x += 1
        end
        possible_moves
    end

    def center_left(pos)
        possible_moves = []
        x, y = pos
        until y <= 0
            possible_moves << [x, y - 1] if y - 1 >= 0
            y -= 1
        end
        possible_moves
    end

    def center_right(pos)
        possible_moves = []
        x, y = pos
        until y >= 7
            possible_moves << [x, y + 1] if y + 1 <= 7
            y += 1
        end
        possible_moves
    end

    def diagonal_moves(pos) 
        top_left = top_left_diagonal(pos)
        top_right = top_right_diagonal(pos)
        bottom_left = bottom_left_diagonal(pos)
        bottom_right = bottom_right_diagonal(pos)
        [top_left, top_right, bottom_left, bottom_right]
    end

    def horizontal_vertical_moves(pos)
        top = center_top(pos)
        left = center_left(pos)
        right = center_right(pos)
        bottom = center_bottom(pos)
        [top, left, right, bottom]
    end

    def all_directions(pos)
        diagonal_moves(pos) + horizontal_vertical_moves(pos)
    end

end