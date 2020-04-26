#This module is used for giving us different prompts to the user depending on the
#situation such as pawn promotion and asking for moves. It is also a place to
#put any functions that will print messages.

module Prompt

    #Asks the user what piece to move and where to move.
    def prompt_move
        puts
        puts "Please choose a piece to move: "
        start = gets.chomp.split(",")
        s = start.map(&:to_i)
        puts "Please choose a the destination: "
        destination = gets.chomp.split(",")
        d = destination.map(&:to_i)
        puts
        puts
        [s, d]
    end

    #Asks the user what piece they would like to promote their pawn to.
    def prompt_promotion
        puts
        puts "Please choose a piece for pawn at position to promote to: "
        puts "q for queen"
        puts "r for rook"
        puts "b for bishop"
        puts "n for knight"
        puts
        result = gets.chomp
        case result
        when "q"
            return "q"
        when "r"
            return "r"
        when "b"
            return "b"
        when "n"
            return "n"
        else
            return "none"
        end
    end
    
end