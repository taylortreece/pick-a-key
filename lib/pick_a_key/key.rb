require './lib/pick_a_key'


class PickAKey::Key

    attr_accessor :type, :name, :notes, :chords, :relative_fifth, :relative_minor, :hash

    def initialize(hash={})
    @hash=hash
    hash.each_pair do |type, name|
        @type = type
        hash[type].each_pair do |name, attribute|
            @name = name
          hash[type][name].each_pair do |attribute, value|
              instance_variable_set("@#{attribute}", value)
              self.class.instance_eval { attr_accessor attribute.to_sym }
            end
          end
        end
        @name = name_modifier
        PickAKey::CLI.current_key = self
    end

    def information
      puts " "
      puts "Key:"
      puts @name
      puts " "
      puts "notes:"
      puts @notes
      puts " "
      puts "chords:" 
      puts @chords
      puts " "
      puts "relative_fifth:"
      puts @relative_fifth
      puts " "
      if @relative_minor.include?("Major")
        puts "relative Major:" else puts "relative minor:" end
        puts @relative_minor
      end

    def generate_progression
        puts @chords[rand(6)]
    end

    # def self.create_new_key
    #     puts "Enter the name of the key you like to see:"
    #     puts " "
    #     puts "Major:"
    #     PickAKey::Scraper.all_scale_names[0]
    #     puts " "
    #     puts "minor:"
    #     PickAKey::Scraper.all_scale_names[1]
    #     @user_input = gets.strip
    #     PickAKey::Scraper.key_information_creator
    # end   

    def name_modifier
      if @name.to_s.include?("sharp")
        a = @name.to_s.capitalize.split(" sharp")
        b = a[0]+"♯"+a[1]
        b.split(" ").map(&:capitalize).join(" ")
      elsif @name.to_s.include?("flat")
        a = @name.to_s.capitalize.split(" flat")
        b = a[0]+"♭"+a[1]
        b.split(" ").map(&:capitalize).join(" ")
      else
        @name = @name.to_s.capitalize
      end
    end
    
end