require 'nokogiri'
require 'pry'
require 'open-uri'

def self.all_chords_scraper
    self.name_modifier
    @minor_chords = [] @major_chords = []
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
     
    if @user_input.include?("minor")
      @modified_user_input = @user_input.split(" ").join("-").downcase
    elsif @user_input == "c flat major" || @user_input == "C Flat Major"
       @modified_user_input = "b"
    elsif @user_input == "g flat major" || @user_input == "G Flat Major"
       @modified_user_input = "f-sharp"
    else
      a = @user_input.split(" ").join("-").downcase
      @modified_user_input = a.delete_suffix("-major")
    end

    doc = Nokogiri::HTML(open("http://www.piano-keyboard-guide.com/key-of-#{@modified_user_input}.html"))
    if @user_input == "g flat major" || @user_input == "G Flat Major" then @user_input_chords=doc.css(".entry-content ul").children[14..28].text.split("\n").delete_if {|a| a == ""} end
    @user_input_chords=doc.at_css(".entry-content ul").text.split("\n").delete_if {|a| a == ""}.map! {|a| a.split(/chord/i)}.flatten.reject {|a| a.empty?}.map! {|a| a.lstrip}.flatten
end
end