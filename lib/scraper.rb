require 'open-uri'
require 'pry'

class Scraper

  # Scraper #scrape_index_page is a class method that scrapes
  # the student index page 
  # ('./fixtures/sudent-site/index.html') and returns an 
  # array of hashes in which each hash represents one student
  
  def self.scrape_index_page(index_url)
    # get index_url
    # Nokogiri using open-uri
    # returns [{:name, :location, :profile_url},
    # {:name, :location, :profile}] from Nokogiri
    # using open-URI
    # .css(".student-card")
    studentCards = Nokogiri::HTML(open(index_url))
                    .css(".student-card")
    studentHashes = []
    
    # :name => .css("h4").text
    # :location => .css("p").text
    # :profile_url => .css("a").attribute("href").value
    studentCards.each {|student|
      studentHashes << {name: student.css("h4").text,
                        location: student.css("p").text,
                        profile_url: student.css("a").attribute("href").value}
    }
    studentHashes
    #binding.pry
  end

  # #scrape_profile_page is a class method that scrapes a 
  # student's profile page and returns a hash of attributes
  # describing an individual student.
  # can handle profile pages without all of the social 
  # links.
  def self.scrape_profile_page(profile_url)
    # :twitter => .css("vitals-container")
    #.css("social-icon-container").css("a")[0]
    #.attribute("href").text
    # :linkedin => .css("vitals-container")
    #.css("social-icon-container").css("a")[1]
    #.attribute("href").text
    # :github => .css("vitals-container")
    #.css("social-icon-container").css("a")[2]
    #.attribute("href").text
    # :blog => .css("vitals-container")
    #.css("social-icon-container").css("a")[3]
    #.attribute("href").text
    # :profile_quote => .css(".vitals-container")
    #.css(".vitals-text-container")
    #.css(".profile-quote").text
    # :bio => .css(".details-container")
    # .css(".bio-block.details-block")
    # .css(".description-holder").css("p").text
    studentVitals = Nokogiri::HTML(open(profile_url))
                    .css(".vitals-container")
                    .css("a")
    
    studentQuote = Nokogiri::HTML(open(profile_url))
                    .css(".vitals-container")
                    .css(".vitals-text-container")
                    .css(".profile-quote").text
    
    studentBio = Nokogiri::HTML(open(profile_url))
                  .css(".details-container")
                  .css(".bio-block.details-block")
                  .css(".description-holder").css("p")
                  .text
                  
    # Stores student information
    informationHash = {}
    
    studentVitals.each {|information|
      if (information.attribute("href").text
          .include? "twitter")
        informationHash[:twitter] =
        information.attribute("href").text
      elsif (information.attribute("href").text
          .include? "linkedin")
        informationHash[:linkedin] =
        information.attribute("href").text
      elsif (information.attribute("href").text
          .include? "github")
        informationHash[:github] =
        information.attribute("href").text
      elsif (information.attribute("href").text != "")
        informationHash[:blog] =
        information.attribute("href").text
      end
    }
    informationHash[:bio] = studentBio
    informationHash[:profile_quote] = studentQuote
    
    informationHash
    #binding.pry
  end
  
end

