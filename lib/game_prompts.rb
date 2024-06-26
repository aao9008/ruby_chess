# frozen_string_literal: true

# contains game messages for chess game
module GamePrompts
  def select_game_mode
    user_mode = gets.chomp
    return user_mode if user_mode.match?(/^[12]$/)

    puts 'Input error! Enter 1-digit (1 or 2).'
    select_game_mode
  end

  def repeat_game
    puts repeat_game_choices
    input = gets.chomp
    choice = input.upcase == 'Q' ? :quit : :repeat
    return choice if input.match?(/^[QP]$/i)

    puts 'Input error! Enter Q or P.'
    repeat_game
  end

  def final_message
    return unless @player_count.positive?

    if @board.king_in_check?(@current_turn)
      puts "\e[36m#{previous_color}\e[0m wins! The #{@current_turn} king is in checkmate."
    else
      puts "\e[36m#{previous_color}\e[0m wins in a stalemate!"
    end
  end

  private

  def game_mode_choices
    <<~HEREDOC

      \e[36mWelcome to Chess!\e[0m

      Each turn will be played in two different steps.

      \e[36mStep One:\e[0m
      Enter the coordinates of the piece you want to move.

      \e[36mStep Two:\e[0m
      Enter the coordinates of any legal move \e[31;100m \u25CF \e[0m or capture \e[41m \u265F \e[0m.


      To begin, enter one of the following to play:
        \e[36m[1]\e[0m to play a \e[36mnew 2-player\e[0m game
        \e[36m[2]\e[0m to play a \e[36msaved\e[0m game
    HEREDOC
  end

  def repeat_game_choices
    <<~HEREDOC

      Would you like to quit or play again?
      \e[36m[Q]\e[0m to Quit or \e[36m[P]\e[0m to Play
    HEREDOC
  end

  def user_piece_selection
    <<~HEREDOC

      Enter the coordinates of the piece you want to move.
      \e[36m[Q]\e[0m to Quit or \e[36m[S]\e[0m to Save

    HEREDOC
  end

  def user_move_selection
    <<~HEREDOC

      Enter the coordinates of a legal move \e[91;100m \u25CF \e[0m or capture \e[101m \u265F \e[0m.
      Enter  \e[36m[Q]\e[0m to Quit

    HEREDOC
  end

  def en_passant_warning
    <<~HEREDOC
      One of these moves is to capture the opposing pawn that just moved. To capture this pawn en passant (in passing) enter the \e[41mhighlighted coordinates\e[0m.

      As part of en passant, \e[36myour pawn will be moved to the square in front of the captured pawn\e[0m.

    HEREDOC
  end

  def king_check_warning
    puts "\e[91mWARNING!\e[0m Your king is currently in check!"
  end

  def castling_warning
    <<~HEREDOC
      One of these moves will move the king two spaces and will castle with the rook.

      As part of castling, \e[36myour rook will be moved to the square that the king passes through\e[0m.

    HEREDOC
  end

  def resign_game
    puts "\e[36m#{previous_color}\e[0m wins because #{@current_turn} resigned!"
    @player_count = 0
  end

  def previous_color
    @current_turn == :white ? 'Black' : 'White'
  end
end