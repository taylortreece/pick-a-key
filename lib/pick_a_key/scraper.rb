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

    def self.all_scale_names
        @names = []
        @major_scale_names = []
        @minor_scale_names = []
        @major_scale_names << self.scrape_major_key_names
        @minor_scale_names << self.scrape_minor_key_names
        @major_scale_names.map! {|a| a.split("Scale")}
        @names << @major_scale_names.flatten!
        @minor_scale_names.map! {|a| a.split(" scale")}
        @names << @minor_scale_names.flatten!
        @names
    end

    def self.name_modifyer
        self.all_scale_names
        @names[0].map! { |scale| scale.split(" ").join("-").downcase }
        @names[1].map! { |scale| scale.split(" ").join("-").downcase }
        @names[0].map! { |scale| scale.delete_suffix("-major")}
        @names            
    end

    def self.all_chords_scraper
        self.name_modifyer
        @minor_chords = []
        @major_chords = []
        @names.each do |a|
            a.each do |input|
        if input == "b-flat"
           b_flat_maj = Nokogiri::HTML(open("http://www.piano-keyboard-guide.com/key-of-b-flat.html"))
           b = b_flat_maj.css(".entry-content ul li").text.split(")").delete_if {|a| a.include?(".") || a.include?("ii – V – I") || a.include?("I – vi – IV – V") || a.include?(":")}
           a = b.map {|a| a + ")"}.select {|a| a.include?("Chord") || a.include?("chord")}
           a.map! {|a| a.split(/chord/i)}
           @major_chords << a.flatten.reject {|a| a.empty?}
        elsif input == "c-flat"
           b_flat_maj = Nokogiri::HTML(open("http://www.piano-keyboard-guide.com/key-of-b-flat.html"))
           b = b_flat_maj.css(".entry-content ul li").text.split(")").delete_if {|a| a.include?(".") || a.include?("ii – V – I") || a.include?("I – vi – IV – V") || a.include?(":")}
           a = b.map {|a| a + ")"}.select {|a| a.include?("Chord") || a.include?("chord")}
           a.map! {|a| a.split(/chord/i)}
           @major_chords << a.flatten.reject {|a| a.empty?}
        elsif input == "e-flat"
           e_flat_maj = Nokogiri::HTML(open("http://www.piano-keyboard-guide.com/key-of-e-flat.html"))
           e = e_flat_maj.css(".entry-content ul li").text.split(")").delete_if {|a| a.include?("Chord") || a.include?("Eb – Ab – Bb") || a.include?("#") || a.include?(".") || a.include?("ii – V – I") || a.include?("I – vi – IV – V")}
           @major_chords << e.map {|a| a + ")"}.flatten
        elsif input == "f-sharp"
           f_sharp_maj = Nokogiri::HTML(open("http://www.piano-keyboard-guide.com/key-of-f-sharp.html"))
           f = f_sharp_maj.css(".entry-content ul li").text.split(")").delete_if {|a| a.include?("Chord") || a.include?(".") || a.include?("flat") || a.include?("ii – V – I") || a.include?("I – vi – IV – V")}
           @major_chords << f.map {|a| a + ")"}.flatten
        elsif input == "g-flat"
           g_flat_maj = Nokogiri::HTML(open("http://www.piano-keyboard-guide.com/key-of-f-sharp.html"))
           g = g_flat_maj.css(".entry-content ul li").text.split(")").delete_if {|a| a.include?("Chord") || a.include?("#") || a.include?(".") || a.include?("sharp") || a.include?("Bmaj") || a.include?("ii – V – I") || a.include?("I – vi – IV – V")} 
           @major_chords << g.map {|a| a + ")"}.flatten
        elsif input == "c-sharp"
           c_sharp_maj = Nokogiri::HTML(open("http://www.piano-keyboard-guide.com/key-of-c-sharp.html"))
           c = c_sharp_maj.css(".entry-content ul li").text.split(")").delete_if {|a| a.include?("Chord") || a.include?("#") || a.include?("ii – V – I") || a.include?("I – vi – IV – V")}
           @major_chords << c.map {|a| a + ")"}.flatten
        elsif input.include?("minor")
           g_min = Nokogiri::HTML(open("http://www.piano-keyboard-guide.com/key-of-#{input}.html"))
           g = g_min.css(".entry-content ul li").text.split(")").delete_if {|a| a.include?(":") || a.include?(".") || a.include?("ii – v – i") || a.include?("i – VI – III – VII") || a.include?("i – iv – v") || a.include?("i – iv – VII") || a.include?("i – VI – VII")}
           @minor_chords << g.map {|a| a + ")"}
        else
           doc = Nokogiri::HTML(open("http://www.piano-keyboard-guide.com/key-of-#{input}.html"))
           c = doc.css(".entry-content ul li").text.split(")").delete_if {|a| a.include?("Chord") || a.include?("ii – V – I") || a.include?("I – vi – IV – V") || a.include?(".")}
           @major_chords << c.map {|a| a + ")"}.flatten
        end        
       end 
      end
     end

    def self.all_scale_notes
        @notes = []
        @notes << self.scrape_major_key_notes
        @notes << self.scrape_minor_key_notes
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

    #Individual Chord Scraper

    def self.key_information_creator

        self.individual_chord_scraper
     
        self.all_scale_names
        self.all_scale_notes
     
     
        @user_input_name = @user_input
     
        @user_key_info = {}
     
        if @user_input_name.include?("minor")
         @user_key_info["minor"] = {}
         user_notes_index = @minor_scale_names.find_index(@user_input_name)
     
         @user_key_info["minor"][:"#{@user_input_name}"] = {
            :notes => @notes[1][user_notes_index].lstrip,    
            :relative_fifth => @notes[1][user_notes_index].split(" ")[8]+" minor",
            :relative_minor => @notes[1][user_notes_index].split(" ")[4]+" Major",
            :chords => @user_input_chords
        }
        else
         @user_key_info["Major"] = {}
         user_notes_index = @major_scale_names.find_index(@user_input_name)
     
         @user_key_info["Major"][:"#{@user_input_name.capitalize}"] = {
            :notes => @notes[0][user_notes_index.to_i].lstrip,    
            :relative_fifth => @notes[0][@user_key_info["Major"].length].split(" ")[8]+" Major",
            :relative_minor => @notes[0][@user_key_info["Major"].length].split(" ")[10]+" minor",
            :chords => @user_input_chords
     }   
       end
       @key = PickAKey::Key.new(@user_key_info)
       puts @key.chords
     end 

     def self.individual_chord_scraper
     
         @user_input = gets.strip
     
         if @user_input.include?("minor")
           @modified_user_input = @user_input.split(" ").join("-").downcase
         else
           a = @user_input.split(" ").join("-").downcase
           @modified_user_input = a.delete_suffix("-major")
         end
     
        #  case @modified_user_input
        #  when "b-flat" || "c-flat"
        #    scrape_key("http://www.piano-keyboard-guide.com/key-of-b-flat.html")
     
             if @modified_user_input == "b-flat"
                b_flat_maj = Nokogiri::HTML(open("http://www.piano-keyboard-guide.com/key-of-b-flat.html"))
                b = b_flat_maj.css(".entry-content ul li").text.split(")").delete_if {|a| a.include?(".") || a.include?("ii – V – I") || a.include?("I – vi – IV – V") || a.include?(":")}
                a = b.map {|a| a + ")"}.select {|a| a.include?("Chord") || a.include?("chord")}
                a.map! {|a| a.split(/chord/i)}
                @user_input_chords = a.flatten.reject {|a| a.empty?}
             elsif @modified_user_input == "c-flat"
                b_flat_maj = Nokogiri::HTML(open("http://www.piano-keyboard-guide.com/key-of-b-flat.html"))
                b = b_flat_maj.css(".entry-content ul li").text.split(")").delete_if {|a| a.include?(".") || a.include?("ii – V – I") || a.include?("I – vi – IV – V") || a.include?(":")}
                a = b.map {|a| a + ")"}.select {|a| a.include?("Chord") || a.include?("chord")}
                a.map! {|a| a.split(/chord/i)}
                @user_input_chords = a.flatten.reject {|a| a.empty?}
             elsif @modified_user_input == "e-flat"
                e_flat_maj = Nokogiri::HTML(open("http://www.piano-keyboard-guide.com/key-of-e-flat.html"))
                e = e_flat_maj.css(".entry-content ul li").text.split(")").delete_if {|a| a.include?("Chord") || a.include?("Eb – Ab – Bb") || a.include?("#") || a.include?(".") || a.include?("ii – V – I") || a.include?("I – vi – IV – V")}
                @user_input_chords = e.map {|a| a + ")"}.flatten
             elsif @modified_user_input == "f-sharp"
                f_sharp_maj = Nokogiri::HTML(open("http://www.piano-keyboard-guide.com/key-of-f-sharp.html"))
                f = f_sharp_maj.css(".entry-content ul li").text.split(")").delete_if {|a| a.include?("Chord") || a.include?(".") || a.include?("flat") || a.include?("ii – V – I") || a.include?("I – vi – IV – V")}
                @user_input_chords = f.map {|a| a + ")"}.flatten
             elsif @modified_user_input == "g-flat"
                g_flat_maj = Nokogiri::HTML(open("http://www.piano-keyboard-guide.com/key-of-f-sharp.html"))
                g = g_flat_maj.css(".entry-content ul li").text.split(")").delete_if {|a| a.include?("Chord") || a.include?("#") || a.include?(".") || a.include?("sharp") || a.include?("Bmaj") || a.include?("ii – V – I") || a.include?("I – vi – IV – V")} 
                @user_input_chords = g.map {|a| a + ")"}.flatten
             elsif @modified_user_input == "c-sharp"
                c_sharp_maj = Nokogiri::HTML(open("http://www.piano-keyboard-guide.com/key-of-c-sharp.html"))
                c = c_sharp_maj.css(".entry-content ul li").text.split(")").delete_if {|a| a.include?("Chord") || a.include?("#") || a.include?("ii – V – I") || a.include?("I – vi – IV – V")}
                @user_input_chords = c.map {|a| a + ")"}.flatten
             elsif @modified_user_input.include?("minor")
                g_min = Nokogiri::HTML(open("http://www.piano-keyboard-guide.com/key-of-#{@modified_user_input}.html"))
                g = g_min.css(".entry-content ul li").text.split(")").delete_if {|a| a.include?(":") || a.include?(".") || a.include?("ii – v – i") || a.include?("i – VI – III – VII") || a.include?("i – iv – v") || a.include?("i – iv – VII") || a.include?("i – VI – VII")}
                @user_input_chords = g.map {|a| a + ")"}
             else 
                doc = Nokogiri::HTML(open("http://www.piano-keyboard-guide.com/key-of-#{@modified_user_input}.html"))
                c = doc.css(".entry-content ul li").text.split(")").delete_if {|a| a.include?("Chord") || a.include?("ii – V – I") || a.include?("I – vi – IV – V") || a.include?(".")}
                @user_input_chords = c.map {|a| a + ")"}.flatten
             end        
        @user_input_chords
     end
   end

