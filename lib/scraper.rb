require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    #html = open(index_url)
    doc = Nokogiri::HTML(open(index_url))

    #doc1 = doc.css(".roster-cards-container")

    scraped_students = []

    doc.css(".roster-cards-container").each do |student_card|

        student_card.css(".student-card a").each do |student|
          hash = {}
          hash[:name] = student.css(".student-name").text
          hash[:location] = student.css(".student-location").text
          hash[:profile_url] = student.attr('href')
          scraped_students << hash
        end
    end

    scraped_students

  end #end of method

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    profile_page_hash = {}
  #binding.pry
    doc.css("div.social-icon-container").css("a").each do |social_media|

      if social_media.attr('href').include?("twitter")
        profile_page_hash[:twitter] = social_media.attr('href')
      elsif social_media.attr('href').include?("linkedin")
        profile_page_hash[:linkedin] = social_media.attr('href')
      elsif social_media.attr('href').include?("github")
        profile_page_hash[:github] = social_media.attr('href')
      elsif social_media.attr('href')
        profile_page_hash[:blog] = social_media.attr('href')
      end

      # profile_page_hash[:twitter] = social_media.css("a")[0].attr('href') if social_media.css("a")[0]
      # profile_page_hash[:linkedin] = social_media.css("a")[1].attr('href') if social_media.css("a")[1]
      # profile_page_hash[:github] = social_media.css("a")[2].attr('href') if social_media.css("a")[2]
      # profile_page_hash[:blog] = social_media.css("a")[3].attr('href') if social_media.css("a")[3]
    end

    profile_page_hash[:profile_quote] = doc.css("div.profile-quote").text.strip if doc.css("div.profile-quote")
    profile_page_hash[:bio] = doc.css("div.bio-content").css("div.description-holder").text.strip if doc.css("div.bio-content").css("div.description-holder")

    profile_page_hash

  end #end of method

end #end of class
