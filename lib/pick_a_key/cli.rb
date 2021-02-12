require './lib/pick_a_key'
require 'pp'


class PickAKey::CLI

  @@all = []

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
         puts PickAKey::CLI.current_key.information
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

    #relative key
    if user_input.include?("m") || user_input.include?("M")
      PickAKey::CLI.switch="a"
      if PickAKey::CLI.current_key != nil
      PickAKey::Scraper.key_information_creator
      puts PickAKey::CLI.current_key.information
      PickAKey::CLI.switch=nil
      PickAKey::CLI.menu
      PickAKey::CLI.commands
      else
        puts " "
        puts "**You are not currently viewing an individual key. Please choose a valid selection**"
        PickAKey::CLI.menu
        PickAKey::CLI.commands
      end

    #relative fifth
    elsif user_input.include?("fi")
      PickAKey::CLI.switch="b"
        if PickAKey::CLI.current_key != nil
        PickAKey::Scraper.key_information_creator
        PickAKey::CLI.switch=nil
        puts PickAKey::CLI.current_key.information
        PickAKey::CLI.menu
        PickAKey::CLI.commands
        else
          
          puts " "
          puts "**You are not currently viewing an individual key. Please choose a valid selection**"
          PickAKey::CLI.menu
          PickAKey::CLI.commands
          PickAKey::CLI.switch=nil
        end

    #chord progression
    elsif user_input.include?("ch")
      puts " "
      puts "Enter the number of chords you would like your progression to be (e.g. 4)"
      PickAKey::CLI.switch=gets.chomp.to_i
      puts "Random #{PickAKey::CLI.switch} chord progression written in #{PickAKey::CLI.current_key.name}"
      puts " "
      puts PickAKey::CLI.current_key.chord_progression
      PickAKey::CLI.menu
      PickAKey::CLI.commands
      PickAKey::CLI.switch=nil

    #song creation
    elsif user_input.include?("so")
      puts " "
      puts "Generating your masterpiece in #{PickAKey::CLI.current_key.name}."
      PickAKey::CLI.current_key.song
      PickAKey::CLI.menu
      PickAKey::CLI.commands
      PickAKey::CLI.switch=nil

    #new key
    elsif user_input.include?("ne")
      PickAKey::CLI.new.start

    #all keys
    elsif user_input.include?("al")
      puts " "
      puts "loading..."
      puts " "
      pp PickAKey::Scraper.create_hash_for_keys
      PickAKey::CLI.menu
      PickAKey::CLI.commands
      PickAKey::CLI.switch=nil

    elsif user_input.include?("ex")
      puts "See you soon."
    end

  end

  def self.switch=(value)
    @switch=value
  end

  def self.switch
    @switch
  end

end