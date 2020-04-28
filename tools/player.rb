#The player class is used to create player objects that are given a color
#and name.

class Player

    attr_accessor :name, :color

    #Initializes the name and color of the object.
    def initialize(name, color)
        @name = name
        @color = color
    end
    
end