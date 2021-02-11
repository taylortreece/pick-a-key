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

    def chord_progression
      @progression = []
      i=0

      if PickAKey::CLI.switch == nil then PickAKey::CLI.switch=4 end

      if @type.include?("ajor")
        while i < PickAKey::CLI.switch
        @progression << @chords[rand(6)]
        i += 1
        end
      else
        while i < PickAKey::CLI.switch
        puts @chords.delete_if {|a| a.include?("dim")}[rand(6)]
        i += 1
        end
    end
    @progression
  end

    def song

      puts " "
      puts "1st Chorus:"
      puts @chorus = chord_progression
      puts "1st Verse:"
      puts @verse = chord_progression
      puts "2nd Chorus:"
      puts @chorus
      puts "2nd verse:"
      puts @verse
      puts "Bridge:"
      puts @bridge = chord_progression
      puts "3rd Chorus:"
      puts @chorus
      puts " "
      puts "end"

    end

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