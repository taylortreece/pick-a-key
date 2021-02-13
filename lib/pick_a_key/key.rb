require './lib/pick_a_key'


class PickAKey::Key

    attr_accessor :type, :name, :notes, :chords, :relative_fifth, :relative_minor, :hash, :popular_chord_progressions

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
        @popular_chord_preogressions = popular_chord_progressions
        PickAKey::CLI.current_key = self
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

    def popular_chord_progressions
      @popular_chord_progressions = {}

      if @type == "Major"
      progressions={
       "I-IV-V" => [1,4,5],
       "I-IV-V-ii" => [1,4,5,2],
       "I-IV-V-vi" => [1,4,5,6],
       "ii-V-I" => [2,5,1]
    }
      elsif @type == "minor"
      progressions={
       "i-iv-v" => [1,4,5],
       "i iidim V i" => [1,4,5,2],
       "i VI iii VII" => [1,4,5,6],
       "ii-V-I" => [2,5,1]
     }
      end

      progressions.each_pair do |name, pattern|
        @popular_chord_progressions[:"#{name}"]= []
        pattern.each do |degree| 
          @popular_chord_progressions[:"#{name}"] << @chords[degree-1] 
      end
    end
    @popular_chord_progressions
  end
    
end