require './lib/pick_a_key'

class PickAKey::Scraper

    def self.scrape_major_key_scale_overview
        doc = Nokogiri::HTML(open("https://piano-music-theory.com/2016/05/31/major-scales/"))
        major = doc.css("p").map {|a| a.text.split("\n")}
        @major_scales_information = major.flatten.select {|a| a.include?("Major Scale")}
    end
    
    def self.scrape_major_key_names
        scrape_major_key_scale_overview
        name = @major_scales_information.map {|a| a.split(":")}.flatten
        @major_scale_names = name.select {|a| a.include?("Major Scale")}.delete_if {|a| a.include?("\t" || "Categories")}
    end
    
    def self.scrape_major_key_notes
        scrape_major_key_scale_overview
        @major_scale_notes = @major_scales_information.map {|a| a.split(":")}.flatten.delete_if {|a| a == "Categories" || a.include?("Scale")}
    end

    def self.scrape_minor_key_scale_overview
        doc = Nokogiri::HTML(open("https://piano-music-theory.com/2016/06/01/minor-scales-natural-minor-scales/"))
        minor = doc.css("p").map {|a| a.text.split("\n")}
        @minor_scales_information = minor.flatten.select {|a| a.include?("Minor Scale")}
    end

    def self.scrape_minor_key_names
        scrape_minor_key_scale_overview
        name = @minor_scales_information.map {|a| a.split(":")}.flatten
        a = name.select {|a| a.include?("Minor Scale")}.delete_if {|a| a.include?("\t" || "Categories")}
        @minor_scale_names = a.map {|a| a.downcase}
    end

    def self.scrape_minor_key_notes
        scrape_minor_key_scale_overview
        @minor_scale_notes = @minor_scales_information.map {|a| a.split(":")}.flatten.delete_if {|a| a == "Categories" || a.include?("Scale")}
    end


    # Hash creation
   # @major_scale_names.map {|a| a.gsub(" Scale", "") }
    def self.all_scale_names
        @names = []
        @major_scale_names = []
        @minor_scale_names = []
        @major_scale_names << self.scrape_major_key_names
        @minor_scale_names << self.scrape_minor_key_names
        @major_scale_names.map! {|a| a.split(" Scale")}
        @names << @major_scale_names.flatten!
        @minor_scale_names.map! {|a| a.split(" scale")}
        @names << @minor_scale_names.flatten!
        @names
    end

    def self.all_scale_notes
        @notes = []
        @notes << self.scrape_major_key_notes
        @notes << self.scrape_minor_key_notes
    end

    def self.name_modifier
        self.all_scale_names
        @names[0].map! { |scale| scale.split(" ").join("-").downcase }
        @names[1].map! { |scale| scale.split(" ").join("-").downcase }
        @names[0].map! { |scale| scale.delete_suffix("-major")}
        @names            
    end


    def self.all_chords_scraper
        self.name_modifier
        @minor_chords = []
        @major_chords = []
        @names.each do |a|
            a.each do |input|

        if input == "g-flat"
          a = "f-sharp"
        elsif input == "c-flat"
          a = "b"
        else
          a = input
        end

        a.include?("minor") ? b = @minor_chords : b = @major_chords

        doc = Nokogiri::HTML(open("http://www.piano-keyboard-guide.com/key-of-#{a}.html"))
        b << doc.at_css(".entry-content ul").text.split("\n").delete_if {|a| a == ""}.map! {|a| a.split(/chord/i)}.flatten.reject {|a| a.empty?}.map! {|a| a.lstrip}.flatten   
       end
      end
     end

    def self.individual_chord_scraper
        if PickAKey::CLI.current_key != nil && PickAKey::CLI.switch=="a"
            @user_input = PickAKey::CLI.current_key.relative_minor.downcase
        elsif PickAKey::CLI.current_key != nil && PickAKey::CLI.switch=="b"
            @user_input = PickAKey::CLI.current_key.relative_fifth.downcase
        else
           @user_input = gets.strip.capitalize
        end

        if @user_input.include?("♯")
            @user_input["\u266F"] = " Sharp"
        elsif @user_input.include?("♭")
            @user_input["\u266D"] = " Flat" 
        else
            @user_input
        end
        
        if @user_input == "c flat major" || @user_input == "C Flat Major"
           @modified_user_input = "b"
        elsif @user_input == "g flat major" || @user_input == "G Flat Major"            
           @modified_user_input = "f-sharp"
        elsif @user_input == "g sharp major" || @user_input == "g Sharp major" || @user_input == "G Sharp Major"
            @user_input = "A Flat Major"
            @modified_user_input = "a-flat"
        elsif @user_input.downcase == "e sharp minor"
            @user_input = "f minor"
        end

        if @user_input.include?("minor")
            @modified_user_input = @user_input.split(" ").join("-").downcase
        else
          a = @user_input.split(" ").join("-").downcase
          @modified_user_input = a.delete_suffix("-major")
        end

        doc = Nokogiri::HTML(open("http://www.piano-keyboard-guide.com/key-of-#{@modified_user_input}.html"))
        if @user_input == "g flat major" || @user_input == "G Flat Major" then @user_input_chords=doc.css(".entry-content ul").children[14..28].text.split("\n").delete_if {|a| a == ""} end
        @user_input_chords=doc.at_css(".entry-content ul").text.split("\n").delete_if {|a| a == ""}.map! {|a| a.split(/chord/i)}.flatten.reject {|a| a.empty?}.map! {|a| a.lstrip}.flatten
    end

    def self.create_hash_for_keys
        self.all_scale_names
        self.all_scale_notes
        self.all_chords_scraper

        @keys_info = {}
        @keys_info["Major"] = {}
        @keys_info["minor"] = {}

        @names[0].each do |name|          
            @keys_info["Major"][:"#{name.capitalize}"] = {
                :notes => @notes[0][@keys_info["Major"].length].lstrip,    
                :relative_fifth => @notes[0][@keys_info["Major"].length].split(" ")[8]+" Major",
                :relative_minor => @notes[0][@keys_info["Major"].length].split(" ")[10].downcase+" minor",
                :chords => @major_chords[@keys_info["Major"].length],
              # :popular_chord_progressions => 
                    # @major_chords[@keys_info["Major"].length][0]
        }
       end
        @names[1].each do |name|          
         @keys_info["minor"][:"#{name}"] = {
             :notes => @notes[1][@keys_info["minor"].length],
             :relative_fifth => @notes[1][@keys_info["minor"].length].split(" ")[8].downcase+" minor",
             :relative_major => @notes[1][@keys_info["minor"].length].split(" ")[4]+" Major",
             :chords => @minor_chords[@keys_info["minor"].length]
        }
       end
      @keys_info
    end

    def self.key_information_creator
        self.individual_chord_scraper
        self.all_scale_names
        self.all_scale_notes
        @user_input_name = @user_input
        @user_key_info = {}
     
        if @user_input_name.include?("minor")
         @user_key_info["minor"] = {}
         user_notes_index = @minor_scale_names.find_index(@user_input_name.downcase).to_i
     
         @user_key_info["minor"][:"#{@user_input_name}"] = {
            :notes => @notes[1][user_notes_index].lstrip,    
            :relative_fifth => @notes[1][user_notes_index].split(" ")[8]+" minor",
            :relative_minor => @notes[1][user_notes_index].split(" ")[4]+" Major",
            :chords => @user_input_chords
        }

        else
         @user_key_info["Major"] = {}
         user_notes_index = @major_scale_names.find_index(@user_input_name.split(" ").map(&:capitalize).join(" "))
     
         @user_key_info["Major"][:"#{@user_input_name.capitalize}"] = {
            :notes => @notes[0][user_notes_index.to_i].lstrip,    
            :relative_fifth => @notes[0][user_notes_index.to_i].split(" ")[8]+" Major",
            :relative_minor => @notes[0][user_notes_index.to_i].split(" ")[10]+" minor",
            :chords => @user_input_chords
     }   
         end 
       @key = PickAKey::Key.new(@user_key_info)
       PickAKey::CLI.current_key = @key 
     end 

end

