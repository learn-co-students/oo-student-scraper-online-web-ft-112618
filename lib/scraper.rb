require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  @@scraped_students = []
  # @@scraped_student = {}

  def self.scrape_index_page(index_url)
    # binding.pry
    learn_students = Nokogiri::HTML(open(index_url))

    # binding.pry

    learn_students.css(".student-card").each do |student|
      # binding.pry
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
    #binding.pry
    new_array = learn_student.css(".social-icon-container").children.css("a").map{|x| x.attr("href")}
      new_array.each do |element|
        if element.include?("twitter")
          student[:twitter] = element
        elsif element.include?("github")
          student[:github] = element
        elsif element.include?("linkedin")
          student[:linkedin] = element
        else #element.include?("blog")
          student[:blog] = element
        end
      end
        student[:bio] = learn_student.css(".bio-content .description-holder").text.gsub("\n", "").strip
        #binding.pry
        student[:profile_quote] = learn_student.css(".profile-quote").text
  student
  # scraped_student
end

  # students

end
