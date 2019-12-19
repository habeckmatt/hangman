require_relative "hangman"

hangman = Hangman.new


  user_game_choice = ""

  acceptable_choice = false
  while !acceptable_choice
    acceptable_choice = true
    puts "Welcome to Hangman featuring Stick-Stickly!"
    puts
    puts "New Game?(N)"
    puts "Load Saved Game?(S)"
    user_game_choice = gets.chomp

    if user_game_choice.downcase != "n" && user_game_choice != "s"
      acceptable_choice = false
      puts "Sorry, that input is not recognized"
      puts
    end
  end

  if user_game_choice.downcase == "s"
    file_exists = false
    while !file_exists
        file_exists = true
        puts
        puts "What Game # would you like to load? (Enter number just before the .txt)"
        directory = Dir.getwd
        puts
        puts Dir.glob("#{directory}/*.{txt, TXT}").join(",\n")
        puts
        game_to_load = gets.chomp
        if !File.exists?("saved_game_#{game_to_load}")
            file_exists = false
            puts
            puts "I'm sorry, that file does not exist."
        end
    end
          
    hangman.load_game(game_to_load)
  else
    puts
    puts "NEW GAME"
  end


  until hangman.game_over?
    puts "-----------------------------------"
    puts "##########This is Game Number: #{hangman.this_game_number} ##########"
    puts
    puts "Can you save Stick-Stickly from being hung!?"
    puts
    puts "Incorrect Guesses Remaining: #{hangman.remaining_incorrect_guesses}"
    puts
    puts "Attempted Chars: #{hangman.attempted_chars}"
    puts
    puts "Word: #{hangman.guess_word}"
    puts
    choice = ""

    acceptable_choice = false
    while !acceptable_choice
      acceptable_choice = true
      puts "Would you like to save before continuing?(Y/N)"
      choice = gets.chomp

      if choice.downcase != "n" && choice.downcase != "y"
        acceptable_choice = false
        puts "Sorry, that input is not recognized."
        puts
      end
    end

    if choice.downcase == "n"
      puts
      hangman.ask_user_for_guess
    else        
      hangman.save_game
      puts "Game Number #{hangman.this_game_number} has been saved!"
      puts
      hangman.ask_user_for_guess
    end
  end