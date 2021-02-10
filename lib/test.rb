require 'nokogiri'
require 'pry'
require 'open-uri'

def test
    doc = Nokogiri::HTML(open("http://www.piano-keyboard-guide.com/key-of-a-minor.html"))
    puts doc.at_css(".entry-content ul").text
end

test