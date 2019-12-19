require "byebug"
require "json"

class Hangman
  DICTIONARY = []

  File.open("5desk.txt").each do |word|
    if word.length >= 5 && word.length <= 12
      DICTIONARY << word.chomp
    end
  end

  def self.random_word
      return DICTIONARY.sample 
  end 

  def self.game_number
    @@game_number
  end

  def initialize
    @secret_word = Hangman.random_word 
    @guess_word = Array.new(@secret_word.length, "_")
    @attempted_chars = []
    @remaining_incorrect_guesses = @secret_word.length + 1
    @this_game_number = rand 10
  end

  def this_game_number
    @this_game_number
  end

  def save_hash(secret_word, guess_word, attempted_chars, remaining_incorrect_guesses, this_game_number)
    save_hash = Hash.new
    save_hash[:secret_word] = secret_word
    save_hash[:guess_word] = guess_word
    save_hash[:attempted_chars] = attempted_chars
    save_hash[:remaining_incorrect_guesses] = remaining_incorrect_guesses
    save_hash[:this_game_number] = this_game_number
    return save_hash
  end

  def save_game
    save = save_hash(@secret_word, @guess_word, @attempted_chars, @remaining_incorrect_guesses, @this_game_number)
    File.open("saved_game_#{@this_game_number}.txt", "w") do |file|
      file.write save.to_json
    end
  end

  def load_game(game_number)
    load_hash = Hash.new

    load_hash = JSON.parse(File.read("saved_game_#{game_number}.txt"))

    load_hash.each do |k, v|
      case k
        when "secret_word"
          @secret_word = v
        when "guess_word" 
          @guess_word = v 
        when "attempted_chars"
          @attempted_chars = v 
        when "remaining_incorrect_guesses"
          @remaining_incorrect_guesses = v
        when "this_game_number"
          @this_game_number = v 
        else
          puts "There was an error loading your file! Closing game."
      end
    end
  end 

  def guess_word
      @guess_word 
  end

  def attempted_chars
      @attempted_chars
  end 

  def remaining_incorrect_guesses
      @remaining_incorrect_guesses
  end 

  def already_attempted?(char)
    if @attempted_chars.include?(char)
       return true
    else  
       return false 
    end 
  end 

  def get_matching_indices(char)
    indices = []
    @secret_word.each_char.with_index do |letter, i|
      if letter == char
          indices << i  
      end 
    end 
    return indices 
  end 

  def fill_indices(char, array_of_indices)
    array_of_indices.each do |k|
      @secret_word.each_char.with_index do |letter, i|
        if k == i
          @guess_word[i] = char  
        end 
      end 
    end 
  end 

  def try_guess(char)
 
    
    if already_attempted?(char)
      puts "Sorry, you've already tried that letter!  Guess again:"
      return false 
    end 


    matching_indices = get_matching_indices(char)
    attempted_chars << char 
    
    if matching_indices == []
       @remaining_incorrect_guesses -= 1
    end 
    
    fill_indices(char, get_matching_indices(char))
    
    return true 
  
  end 

  def ask_user_for_guess
    puts
    puts "Enter a letter you think might be in the word:"
    guess = gets.chomp
    return try_guess(guess)
  end 

  def win?
    if @guess_word.join("") == @secret_word
      puts
      puts "You win!  Congratulations!"
      puts
      return true 
    else  
      return false
    end 
  end 

  def lose?
    if @remaining_incorrect_guesses == 0
      puts
      puts "You lose!  Poor little Stick Stickly has been hung!"
      puts
      return true 
    else  
      return false 
    end 
  end 

  def game_over?
    if win? == true || lose? == true
      puts
      puts "The Secret Word was: #{@secret_word}"
      return true 
    else  
      return false 
    end 
  end 



end