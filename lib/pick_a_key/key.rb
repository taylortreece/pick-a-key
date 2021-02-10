require './lib/pick_a_key'


class PickAKey::Key

    attr_accessor :type, :name, :notes, :chords, :relative_fifth, :relative_key

    def initialize(hash={})
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
    end

    # def generate_progression
    #     puts chords[rand(6)]
    # end

    def self.create_new_key
        puts "Enter the name of the key you like to see:"
        puts " "
        puts "Major:"
        PickAKey::Scraper.all_scale_names[0]
        puts " "
        puts "minor:"
        PickAKey::Scraper.all_scale_names[1]
        @user_input = gets.strip
        @s.key_information_creator
    end
    
end