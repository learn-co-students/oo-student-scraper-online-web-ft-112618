require 'open-uri'
require 'pry'

class Scraper

  #attr_accessor :name, :location, :profile_url

  def self.scrape_index_page(index_url)
    doc = open(index_url)
    html = Nokogiri::HTML(doc)
    students = []
    html.css("div.roster-cards-container").each do |card|
      card.css(".student-card a").each do |student|
        student_profile_link = "#{student.attr('href')}"
        student_location = student.css('.student-location').text
        student_name = student.css('.student-name').text
        students << {name: student_name, location: student_location, profile_url: student_profile_link}
      end
    end
    students
  end
  #twitter link html.css('.social-icon-container a').attribute('href').value
#=> "https://twitter.com/jmburges"
  def self.scrape_profile_page(profile_url)
    doc = open(profile_url)
    html = Nokogiri::HTML(doc)
    socials = {}

    html.css('.social-icon-container a'). each do |site|
      if site.attr('href').include?("twitter")
      socials[:twitter] = site.attribute('href').value
    elsif site.attr('href').include?("linkedin")
      socials[:linkedin] = site.attribute('href').value
    elsif site.attr('href').include?("github")
      socials[:github] = site.attribute('href').value
    elsif site.attr('href').include?("youtube")
      socials[:youtube] = site.attribute('href').value
    else
      socials[:blog] = site.attribute('href').value
      end
      socials[:profile_quote] = html.css('.vitals-text-container .profile-quote').text

      socials[:bio] = html.css('.bio-content .description-holder p').text
    end
    socials
  end



end
