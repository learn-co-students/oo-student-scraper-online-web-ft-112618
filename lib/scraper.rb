require 'open-uri' 
require 'pry'

class Scraper

  @@scraped_students = []
  
  def self.scrape_index_page(index_url)
    learn_students = Nokogiri::HTML(open(index_url))

    learn_students.css(".student-card").each do |student|
      @@scraped_students << {
        :name => student.css("h4.student-name").text,
        :location => student.css(".card-text-container .student-location").text,
        :profile_url => student.css("a").attr("href").value
      }
      end
      @@scraped_students
  end

  def self.scrape_profile_page(profile_url)
    student = {}
    learn_student = Nokogiri::HTML(open(profile_url))
    
    new_array = learn_student.css(".social-icon-container").children.css("a").map{|x| x.attr("href")}
      new_array.each do |element|
        if element.include?("twitter")
          student[:twitter] = element
        elsif element.include?("github")
          student[:github] = element
        elsif element.include?("linkedin")
          student[:linkedin] = element
        else 
           student[:blog] = element
        end
      end
        student[:bio] = learn_student.css(".bio-content .description-holder").text.gsub("\n", "").strip
        
        student[:profile_quote] = learn_student.css(".profile-quote").text
        
    student
  end
end

