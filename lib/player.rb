class Player
    attr_reader :name
    attr_accessor :input
    def initialize(name)
        @name = name
        @input = nil
    end
    
    def valid_input?
        valid_inputs = ['A', 'B', 'C', 'D', 'E', 'F', 'G']
        if valid_inputs.include?(@input.upcase)
            true
        else
            false
        end
    end
end