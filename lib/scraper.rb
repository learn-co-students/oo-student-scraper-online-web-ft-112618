require 'open-uri'
require 'pry'
require 'nokogiri'

class Scraper
  
  
  def self.scrape_index_page(index_url)
    
    scraped_students = []
    
    doc = Nokogiri::HTML(open(index_url))
    
    doc.css(".student-card").each do |student|
    scraped_students << {:name => student.css("h4").text , :location => student.css("p").text , :profile_url => student.css("a")[0]["href"]}
    end
    
    scraped_students
    
  end



  def self.scrape_profile_page(profile_url)
    
    profile_doc = Nokogiri::HTML(open(profile_url)) 

    vital_doc = profile_doc.css(".vitals-text-container")
  
    social_doc = profile_doc.css(".social-icon-container")

    bio_doc = profile_doc.css(".description-holder")
      
    holder_hash = {}  
    
    social_doc.css("a").each do |href|
    
    href_var = href.attr('href')
    #binding.pry
     if href_var.include? "twitter.com"
       holder_hash.merge! ({:twitter => href_var})
     
     elsif href_var.include? "linkedin.com"
       holder_hash.merge! ({:linkedin => href_var})
     
     elsif href_var.include? "github.com"
       holder_hash.merge! ({:github => href_var})
     
     else 
       holder_hash.merge! ({:blog => href_var})
     end
    end
    if vital_doc != nil
    	quote_doc = vital_doc.css(".profile-quote").text
    	if quote_doc != nil
    		holder_hash.merge! ({:profile_quote => "#{quote_doc}"})
    	end	
    end	
    if bio_doc != nil
    	bio_quote = bio_doc.css("p").text
    	if bio_quote != nil
    		holder_hash.merge! ({:bio => "#{bio_quote}"})
    	end	
    end	
   holder_hash
  end
  
end