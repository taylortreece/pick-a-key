require './lib/pick_a_key'
require 'pp'


class PickAKey::CLI

    def start
         puts "Welcome to your basic music theory coordinator!"
         puts ""
         puts "If you want to check out a key, choose from the list below by typing the key as you see it listed."
         puts ""
         puts "Pick a key:"
         puts " "
         puts "Major:"
         puts PickAKey::Scraper.all_scale_names[0]
         puts " "
         puts "Minor:"
         puts PickAKey::Scraper.all_scale_names[1]
     
              PickAKey::Scraper.key_information_creator
         puts " "
         puts "loading ..."
         puts " "
         puts PickAKey::CLI.current_key_information
              PickAKey::CLI.menu
              PickAKey::CLI.commands

  end

  def self.current_key=(key)
    @current_key=key
  end

  def self.current_key
    @current_key
  end

  def self.menu
    puts "________________________________________"
    puts " "
    puts "What would you like to do?\n"
    puts "____________________________________________________________________________"
    puts "To find this key's relative Major/minor, type 'Major' or 'minor" # Done.
    puts "To find this key's relative fifth, type 'fifth'" #Done.
    puts "To generate a random chord progression in this key, type 'chord'" #Done.
    puts "To get a random song generated in this key, type 'song'" #Done.
    puts "To look up a new key, type 'new' to review and choose from the list of keys." #Done.
    puts "To see all keys at once, type 'all'" #Done.
    puts "To exit, type 'exit'" #Done.
  end

  def self.commands
    user_input=gets.strip
   #relative keys
   if user_input.downcase.include?("m") || user_input.include?("fi")
    PickAKey::CLI.relative_key_selector(user_input)
   #chord progression
   elsif user_input.downcase.include?("ch")
    PickAKey::CLI.generate_chord_progression
   #song creation
   elsif user_input.include?("so")
     PickAKey::CLI.song_output
   #new key
   elsif user_input.include?("ne")
     PickAKey::CLI.new.start 
   #all keys
   elsif user_input.include?("al")
     PickAKey::CLI.list_all_keys 
   elsif user_input.include?("ex")
      puts "See you soon."
    end
  end

  #COMMAND METHODS

  #"To find this key's relative Major/minor, type 'Major' or 'minor" # Done.
  #"To find this key's relative fifth, type 'fifth'" #Done.

  def self.relative_key_selector(user_input)
    if user_input.downcase.include?("m")
      switch="a"
      PickAKey::CLI.relative_key(switch)
    elsif user_input.include?("fi")
      switch="b"
      PickAKey::CLI.relative_key(switch)
    end
  end

  def self.relative_key(switch)
    if PickAKey::CLI.current_key != nil
      PickAKey::Scraper.key_information_creator(switch)
      puts PickAKey::CLI.current_key_information
      PickAKey::CLI.menu
      PickAKey::CLI.commands
    else
      puts " "
      puts "**You are not currently viewing an individual key. Please choose a valid selection**"
      PickAKey::CLI.menu
      PickAKey::CLI.commands
    end
  end

  #"To generate a random chord progression in this key, type 'chord'" #Done.

  def self.generate_chord_progression
    puts " "
    puts "Enter the number of chords you would like your progression to be (e.g. 4)"
    user_input=gets.chomp.to_i
    puts "Random #{user_input} chord progression written in #{PickAKey::CLI.current_key.name}"
    puts " "
    puts PickAKey::CLI.chord_progression(user_input)
    PickAKey::CLI.menu
    PickAKey::CLI.commands
  end

  #"To get a random song generated in this key, type 'song'" #Done.

  def self.song_output
    puts " "
    puts "Generating your masterpiece in #{@current_key.name}."
    PickAKey::CLI.song_creation
    PickAKey::CLI.menu
    PickAKey::CLI.commands
  end

  def self.list_all_keys
    puts " "
    puts "loading..."
    puts " "
    pp PickAKey::Scraper.create_hash_for_keys
    PickAKey::CLI.menu
    PickAKey::CLI.commands
  end

  #   **TRANSFERING KEY METHODS TO CLI**

  def self.current_key_information
    puts " "
    puts "Key:"
    puts @current_key.name
    puts " "
    puts "notes:"
    puts @current_key.notes
    puts " "
    puts "chords:"
    puts @current_key.chords
    puts " "
    puts "relative_fifth:"
    puts @current_key.relative_fifth
    puts " "
    if @current_key.relative_minor.include?("Major")
      puts "relative Major:" 
    else 
      puts "relative minor:" 
    end
      puts @current_key.relative_minor
    end

    def self.chord_progression(user_input=nil)
      @progression = []
      i=0

      if user_input == nil then user_input=4 end

      if @current_key.type.include?("ajor")
        while i < user_input
        @progression << @current_key.chords[rand(6)]
        i += 1
        end
      else
        while i < user_input
        @progression << @current_key.chords.delete_if {|a| a.include?("dim")}[rand(6)]
        i += 1
        end
    end
    @progression
  end

  def self.song_creation
    puts " "
    puts "1st Chorus:"
    puts @chorus = PickAKey::CLI.chord_progression
    puts "1st Verse:"
    puts @verse = PickAKey::CLI.chord_progression
    puts "2nd Chorus:"
    puts @chorus
    puts "2nd verse:"
    puts @verse
    puts "Bridge:"
    puts @bridge = PickAKey::CLI.chord_progression
    puts "3rd Chorus:"
    puts @chorus
    puts " "
    puts "End. Don't tell people I'm giving out free songs..."
  end

end