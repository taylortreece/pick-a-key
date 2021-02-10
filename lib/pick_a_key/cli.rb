class PickAKey::CLI

    def start
         puts "Welcome to your basic music theory coordinator!"
         puts ""
         puts "If you want to check out a key, choose from the list below by typing the key as you see it listed."
         puts "*not yet functional* If you want to generate a random chord progression in a certain key, just pick the key from the list and say generate"
         puts ""
         puts "Pick a key:"
         puts " "
         puts "Major:"
         puts PickAKey::Scraper.all_scale_names[0]
         puts " "
         puts "Minor:"
         puts PickAKey::Scraper.all_scale_names[1]
     
         PickAKey::Scraper.key_information_creator
  end
end