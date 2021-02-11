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
    @@all<<@current_key=key
  end

  def self.current_key
    @@all[@@all.length - 1]
  end

  def self.menu
    puts "________________________________________"
    puts " "
    puts "What would you like to do?"
    puts " "
    puts "____________________________________________________________________________"
    puts "To find this key's relative Major/minor, type 'relative Major' or 'relative minor'" # Done.
    puts "To find this key's relative fifth, type 'relative fifth'" # Done.
    puts "To generate a random four chord progression in this key, type the number of chords you would like to get in your progression (e.g. '4')"
    puts "To get a random song generated in this key, type 'generate song'"
    puts "To look up a new key, type 'new key' to review and choose from the list of keys."
    puts "To see all keys at once, type 'all keys'"
    puts "To exit, type 'exit'"
  end

  def self.commands
    user_input=gets.strip
    if user_input.include?("or")
      PickAKey::CLI.switch="a"
      if PickAKey::CLI.current_key != nil
      PickAKey::Scraper.key_information_creator
      puts PickAKey::CLI.current_key.information
      PickAKey::CLI.menu
      PickAKey::CLI.commands
      else
        puts " "
        puts "**You are not currently viewing an individual key. Please choose a valid selection**"
        PickAKey::CLI.menu
        PickAKey::CLI.commands
      end

    elsif user_input.include?("fifth")
      PickAKey::CLI.switch="b"
        if PickAKey::CLI.current_key != nil
        PickAKey::Scraper.key_information_creator
        puts PickAKey::CLI.current_key.information
        PickAKey::CLI.menu
        PickAKey::CLI.commands
        else
          puts " "
          puts "**You are not currently viewing an individual key. Please choose a valid selection**"
          PickAKey::CLI.menu
          PickAKey::CLI.commands
        end

    elsif user_input == "all keys"
      puts " "
      puts "loading..."
      puts " "
      pp PickAKey::Scraper.create_hash_for_keys
      PickAKey::CLI.menu
      PickAKey::CLI.commands
    end

  end

  def self.switch=(letter)
    @switch=letter
  end

  def self.switch
    @switch
  end

end