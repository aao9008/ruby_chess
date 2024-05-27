# frozen_string_literal: true

# Contains methods to save or load the game.
module Serializer
  def save_game
    # Get the current directory (wherever the script is located)
    current_directory = File.dirname(__FILE__)

    # Construct the path to the project folder
    project_folder = File.expand_path("../", current_directory)

    # Construct the path to the saved_game folder
    saved_game_folder = File.join(project_folder, "saved_games")

    # Check if the saved_game folder exists, and create it if it doesn't
    Dir.mkdir(saved_game_folder) unless Dir.exist?(saved_game_folder)

    # Create a new file name
    file_name = create_file_name

    # Construct path to save fle
    file_path = File.join(saved_game_folder, file_name)

    # Write game to the file
    File.open(file_path, "w+") do |file|
      Marshal.dump(self, file)
    end

    puts "Game was saved as \e[36m#{file_name}\e[0m"
    @player_count = 0
    sleep(3)
  rescue SystemCallError => e
    puts "Error while writing to file #{file_name}."
    puts e
  end

  def create_file_name
    date = Time.now.strftime('%Y-%m-%d').to_s
    time = Time.now.strftime('%H:%M:%S').to_s

    "Chess_#{date}_#{time}"
  end

  def load_game
    # Get saved games folder path
    current_directory = File.dirname(__FILE__)
    project_folder = File.expand_path("../", current_directory)
    saved_games_folder = File.join(project_folder, "saved_games")

    # Get saved game file name
    file_name = find_saved_game(saved_games_folder)

    # Get saved game file path
    file_path = File.join(saved_games_folder, file_name)

    # Load saved game
    File.open(file_path) do |file|
      Marshal.load(file)
    end
  end

  def find_saved_game(saved_games_path)
    saved_games = create_game_list(saved_games_path)

    if saved_games.empty?
      puts "No save files found!"
      exit
    else
      print_saved_games(saved_games)
      file_number = select_saved_game(saved_games.size)
      saved_games[file_number.to_i - 1]
    end
  end

  def create_game_list(saved_games_path)
    list = []
    return list unless Dir.exist?(saved_games_path)

    Dir.entries(saved_games_path).each do |name|
      list << name if name.match(/(Chess)/)
    end

    list
  end

  def print_saved_games(saved_games)
    puts "\e[36m[#]\e[0m File Name(s)"
    saved_games.each_with_index do |name, index|
      puts "\e[36m[#{index + 1}]\e[0m #{name}"
    end
  end

  def select_saved_game(number)
    file_number = gets.chomp
    return file_number if file_number.to_i.between?(1, number)

    puts 'Input error! Enter a valid file number.'

    select_saved_game(number)
  end
end
