require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper
 
  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    students = []
    doc.css(".roster-cards-container").map do |card|
      card.css(".student-card a").map do |student|
        student_name = student.css(".student-name").text
        student_location = student.css(".student-location").text
        student_url = student.attr("href")
        students << {:name => student_name, :location => student_location, :profile_url => student_url}
    end
   end
      students
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    profile = {}
    
    links = doc.css(".social-icon-container a").map {|link| link.attribute("href").value}
    
    links.map do |link|
      if link.include?("linkedin")
        profile[:linkedin] = link
      elsif link.include?("github")
        profile[:github] = link
      elsif link.include?("twitter")
        profile[:twitter] = link
      else 
        profile[:blog] = link
      end   
      
    quotes = doc.css(".profile-quote").text  
    profile[:profile_quote] = quotes
    bioph = doc.css(".content-holder p").text
    profile[:bio] = bioph
  end
   profile
 end 
 
end

