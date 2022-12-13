class Board
	attr_accessor :board
	attr_reader :computer, 
              :player, 
              :rows,
              :column_block,
              :column_win,
              :block_odd,
              :block_even,
              :win_odd,
              :win_even,
              :block_d_even,
              :block_d_odd,
              :win_d_even,
              :win_d_odd,
              :reverse_d,
              :block_rd_even,
              :block_rd_odd,
              :win_rd_even,
              :win_rd_odd

	def initialize(player, computer)
		@player = player	
		@rows = []
		@computer = computer
		@temp_array = []
    @column_block = []
    @column_win = []
    @block_odd = []
    @block_even = []
    @win_odd = []
    @win_even = []
    @row_sections = []
    @row_check = []
    @block_d_even = []
    @block_d_odd = []
    @win_d_even = []
    @win_d_odd = []
    @reverse_d = []
    @block_rd_even = []
    @block_rd_odd = []
    @win_rd_even = []
    @win_rd_odd = []
	end

	def create_board
		@rows = []
		@temp_array = []
		@board = {
			'A' => ['.', '.', '.', '.', '.', '.'],
			'B' => ['.', '.', '.', '.', '.', '.'],
			'C' => ['.', '.', '.', '.', '.', '.'],
			'D' => ['.', '.', '.', '.', '.', '.'],
			'E' => ['.', '.', '.', '.', '.', '.'],
			'F' => ['.', '.', '.', '.', '.', '.'],
			'G' => ['.', '.', '.', '.', '.', '.']
		}
	end

	def full?
		all_positions = @board.values.flatten
		if all_positions.include?('.')
			false
		else
			true
		end
	end

	def show_board
		# Board prints in rows, so created an array of rows in the proccess
		puts "A B C D E F G"
		counter = 0
		6.times do
			row = []
			board.each do |key, value|
				print "#{value[counter]} "
				row << "#{value[counter]}"
			end
			puts "\n"
			counter += 1
		@rows << row
		end
	end

	def row_winner_check
		n = 0
		winner_array_checks = []
		@rows.map {|n| n.each_cons(4) {|element| winner_array_checks.push(element)}}

		check_array_for_winner(winner_array_checks)
	end

	def column_winner_check
		winner_array_checks = []
		@board.values.map {|n| n.each_cons(4) {|element| winner_array_checks.push(element)}}
		check_array_for_winner(winner_array_checks)
	end

	def diagonal_arrays(array)
		diagonal_arrays_set_one(array)
		diagonal_arrays_set_two(array)
		diagonal_arrays_set_three(array)
		diagonal_arrays_set_four(array)

		@temp_array.delete_if {|n| n.include?(nil)}
		return @temp_array
	end

	def diagonal_arrays_set_one(array)
		i = 0
		n = 3
		until n == 6
			@temp_array << (i..n).collect {|i| array[i][i]}
			@temp_array << (i..n).collect {|i| array[i+1][i]}
			@temp_array << (i..n).collect {|i| array[i][i+1]}
			i += 1
			n += 1
		end
		@temp_array
	end

	def diagonal_arrays_set_two(array)
		i = 0
		n = 1
		@temp_array << (i..3).collect {|i| array[i][n+=1]}
	end

	def diagonal_arrays_set_three(array)
		i = 0
		n = 3
		2.times do
			@temp_array << (i..n).collect {|i| array[i+2][i]}
			i += 1
			n += 1
		end
		@temp_array
	end

	def diagonal_arrays_set_four(array)
		i = 0
		n = -1
		@temp_array << (i..3).collect {|i| array[i+3][n+=1]}
	end

	def reversed_board_columns
		temp_board = @board.dup
		reverse_board = temp_board.map {|key, value| value.reverse}
	end

	def diagonal_winner_check
		winner_array_checks = []
		temp_board = @board.dup
		winner_array_checks.concat(diagonal_arrays(temp_board.values))
		winner_array_checks.concat(diagonal_arrays(reversed_board_columns))
		check_array_for_winner(winner_array_checks)
	end

	def check_array_for_winner(array)
		winner = nil
		array.each do |array|
			if array == ['X', 'X', 'X', 'X']
				winner = player
				break
			elsif array == ["O", "O", "O", "O"]
				winner = computer
				break
			end
		end
		return winner
	end

	def winner
		game_winner = []
		game_winner << column_winner_check
		game_winner << row_winner_check
		game_winner << diagonal_winner_check
		game_winner.compact!
		return game_winner[0]
	end

  # Start of Intelligent Computer
  def computer_column_block
    board.each do |key, value|
      board[key].each_cons(4) do |element|
        @column_block << key if element == ['.','X', 'X', 'X']
      end
    end 
    computer.input = @column_block.first if !@column_block.empty?
  end

  def computer_column_win
    board.each do |key, value|
      board[key].each_cons(4) do |element|
        @column_win << key if element == ['.','O', 'O', 'O']
      end
    end 
    computer.input = @column_win.first if !@column_win.empty?
  end

  def computer_row_check
    @rows.shift(6)
    n = 0
    @rows.reverse.map {|n| n.each_cons(4) {|element| @row_sections.push(element)}}

    @row_check.push(@row_sections.slice(0,4))
    @row_check.push(@row_sections.slice(4,4))
    @row_check.push(@row_sections.slice(8,4))
    @row_check.push(@row_sections.slice(12,4))
    @row_check.push(@row_sections.slice(16,4))
    @row_check.push(@row_sections.slice(20,4))
  
  end 

  def computer_row_block
    n = 0
    6.times do
      @row_check[n].find do |section|
        @block_odd = [@row_check[n].index(section)] if section == ['.', 'X', 'X', 'X']
      end 
      n += 1
    end 
    
    n = 0
    6.times do
      @row_check[n].find do |section|
        @block_even = [@row_check[n].index(section)] if section == ['X', 'X', 'X', '.']
      end 
      n += 1
    end

    @row_check.clear 
  end

  def computer_row_win
    computer_row_check 
   
    n = 0
    6.times do
      @row_check[n].find do |section|
      @win_odd = [@row_check[n].index(section)] if section == ['.', 'O', 'O', 'O']
      end 
      n += 1
    end 

    n = 0
    6.times do
      @row_check[n].find do |section|
      @win_even = [@row_check[n].index(section)] if section == ['O', 'O', 'O', '.']
      end 
      n += 1
    end 
  end

  def computer_input_rows
    if @block_odd.first == 0 || @win_odd.first == 0
      return computer.input = 'A'
    elsif @block_odd.first == 1 || @win_odd.first == 1
      return computer.input = 'B'
    elsif @block_odd.first == 2 || @win_odd.first == 2
      return computer.input = 'C'
    elsif @block_odd.first == 3 || @win_odd.first == 3
      return computer.input = 'D'
    elsif @block_even.first == 0 || @win_even.first == 0
      computer.input = 'D'
    elsif @block_even.first == 1 || @win_even.first == 1
      computer.input = 'E'
    elsif @block_even.first == 2 || @win_even.first == 2
      computer.input = 'F'
    elsif @block_even.first == 3 || @win_even.first == 3
      computer.input = 'G'
    end 
  end

  def computer_diagonal_block
    diagonal_arrays(board.values)
    @temp_array.find do |section|
      @block_d_odd = [@temp_array.index(section)] if section == ['.', 'X', 'X', 'X']
    end 

    @temp_array.find do |section|
      @block_d_even = [@temp_array.index(section)] if section == ['X', 'X', 'X', '.']
    end 
    @temp_array.clear
  end 

  def computer_reverse_diagonal_block
    @reverse_d.find do |section|
      @block_rd_odd = [@reverse_d.index(section)] if section == ['.', 'X', 'X', 'X']
    end 

    @reverse_d.find do |section|
      @block_rd_even = [@reverse_d.index(section)] if section == ['X', 'X', 'X', '.']
    end
    @reverse_d.clear
  end 

  def computer_reverse_diagonal_win
    @reverse_d = diagonal_arrays(reversed_board_columns)
    @reverse_d.find do |section|
      @win_rd_odd = [@reverse_d.index(section)] if section == ['.', 'O', 'O', 'O']
    end 

    @reverse_d.find do |section|
      @win_rd_even = [@reverse_d.index(section)] if section == ['O', 'O', 'O', '.']
    end 
  end 

  def computer_diagonal_win
    diagonal_arrays(board.values)
    @temp_array.find do |section|
      @win_d_odd = [@temp_array.index(section)] if section == ['.', 'O', 'O', 'O']
    end 

   @temp_array.find do |section|
      @win_d_even = [@temp_array.index(section)] if section == ['O', 'O', 'O', '.']
    end 
  end 

  def computer_input_diagonal
    index_set_1 = [0, 2, 8]
    index_set_2 = [1, 3, 5]
    index_set_3 = [7, 10, 11]
    index_set_4 = [4, 9]
    index_set_5 = [6, 4, 9]

    if index_set_1.include?(@block_d_odd.first) || index_set_1.include?(@win_d_odd.first) || index_set_1.include?(@block_rd_odd.first) || index_set_1.include?(@win_rd_odd.first)
      computer.input = 'A'
    elsif index_set_2.include?(@block_d_odd.first) || index_set_2.include?(@win_d_odd.first) || index_set_2.include?(@block_rd_odd.first) || index_set_2.include?(@win_rd_odd.first) 
      computer.input = 'B'
    elsif index_set_3.include?(@block_d_odd.first) || index_set_3.include?(@win_d_odd.first) || index_set_3.include?(@block_rd_odd.first) || index_set_3.include?(@win_rd_odd.first)
      computer.input = 'D'
    elsif index_set_4.include?(@block_d_odd.first) || index_set_4.include?(@win_d_odd.first) || index_set_5.include?(@block_rd_odd.first) || index_set_5.include?(@win_rd_odd.first)
      computer.input = 'C'
    elsif @block_d_odd.first == 6 || @win_d_odd.first == 6
      computer.input = 'C'
    elsif index_set_1.include?(@block_d_even.first) || index_set_1.include?(@win_d_even.first) || index_set_1.include?(@block_rd_even.first) || index_set_1.include?(@win_rd_even.first)
      computer.input = 'D'
    elsif index_set_2.include?(@block_d_even.first) || index_set_2.include?(@win_d_even.first) || index_set_2.include?(@block_rd_even.first) || index_set_2.include?(@win_rd_even.first)
      computer.input = 'E'
    elsif index_set_3.include?(@block_d_even.first) || index_set_3.include?(@win_d_even.first) || index_set_3.include?(@block_rd_even.first) || index_set_3.include?(@win_rd_even.first) 
      computer.input = 'G'
    elsif index_set_4.include?(@block_d_even.first) || index_set_4.include?(@win_d_even.first) || index_set_5.include?(@block_rd_even.first) || index_set_5.include?(@win_rd_even.first)
      computer.input = 'F'
    elsif @block_d_even.first == 6 || @win_d_even.first == 6
      computer.input = 'G'
    end 
  end 
end