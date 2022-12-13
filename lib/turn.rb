class Turn
  attr_reader :board, :input

  def initialize (board)
    @board = board
    @input = nil
  end

  def column_space_check(input)
    @input = input
		exit if @input.upcase == 'EXIT'
    board.board[@input].any? do |column|
      column.include?('.')
    end
  end

  def player_valid_move?
    if column_space_check(input) == false
      return 'Uh-oh! That column is full. Choose another column.'
    else
      player_place_piece
    end     
  end 

  def computer_valid_move?
    @input = input
    if column_space_check(input) == false
      return 'Computer chooses another column.'
    else
      computer_intelligent_move
    end     
  end 

  def player_place_piece
    board.board[@input].reverse.find do |column|
    column.replace(board.player.piece) if column.include?('.')
    end
    player__turn_message
  end

  def player__turn_message
    puts '------------------------------------------------------'
    p "Your move"
    board.show_board
    return 'Nice move!'
  end

  def computer_place_piece
    board.board[@input].reverse.find do |column|
    column.replace(board.computer.piece) if column.include?('.')
    end
    computer_turn_message
  end

  def computer_turn_message
    board.show_board
    puts '------------------------------------------------------'
    return 'End of computer turn.'
  end

  # Intelligent computer addition

  def intelligent_computer_win
    board.computer_column_win
    board.computer_row_win
    board.computer_diagonal_win
  end

  def intelligent_computer_block
    board.computer_column_block
    board.computer_row_block
    board.computer_diagonal_block
  end 

  def intelligent_computer_move
    intelligent_computer_win
    intelligent_computer_block
  
    if !board.column_win.empty? 
      board.computer_column_win
    elsif !board.win_odd.empty? || !board.win_even.empty?
      board.block_odd.clear
      board.block_even.clear
      board.computer_input_rows
    elsif !board.win_d_odd.empty? || !board.win_d_even.empty?
      board.block_d_odd.clear
      board.block_d_even.clear
      board.computer_input_diagonal
    elsif !board.block_d_odd.empty? || !board.block_d_even.empty?
      board.computer_input_diagonal
    elsif !board.block_odd.empty? || !board.block_even.empty?
      board.computer_input_rows
    elsif !board.column_block.empty? 
      board.computer_column_block
    else
      board.computer.give_input
    end
    computer_place_piece
    computer_turn_message
  end
end