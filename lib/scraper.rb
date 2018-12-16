require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    student_array = []
    doc = Nokogiri::HTML(open(index_url))
    doc.css(".student-card a").each do |student_node|
      student_array << {
        :name => student_node.css(".student-name").text,
        :location => student_node.css(".student-location").text,
        :profile_url => student_node.attr("href")}
    end
    student_array
  end

  def self.scrape_profile_page(profile_url)
    profile_hash = {}
    doc = Nokogiri::HTML(open(profile_url))
    doc.css(".social-icon-container a").each do |profile_node|
        if profile_node.css(".social-icon").attr("src").value.include?("twitter")
          profile_hash[:twitter] = profile_node.attr("href")
        elsif profile_node.css(".social-icon").attr("src").value.include?("linkedin")
          profile_hash[:linkedin] = profile_node.attr("href")
        elsif profile_node.css(".social-icon").attr("src").value.include?("github")
          profile_hash[:github] = profile_node.attr("href")
        elsif profile_node.css(".social-icon").attr("src").value.include?("rss")
          profile_hash[:blog] = profile_node.attr("href")
        else
          nil
        end
      end
    doc.css(".main-wrapper.profile").each do |profile_node|
        profile_hash[:profile_quote] = profile_node.css(".vitals-container").css(".vitals-text-container").children[5].text.strip
        profile_hash[:bio] = profile_node.css(".details-container").css(".bio-block.details-block").css(".bio-content.content-holder").css(".description-holder").text.strip
    end
    profile_hash
  end
end
