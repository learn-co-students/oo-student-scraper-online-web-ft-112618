require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = Nokogiri::HTML(open(index_url))
    html.css("div.student-card").each.with_object([]) do |student, array|
      array << {
        name: student.css("h4.student-name").text,
        location: student.css("p.student-location").text,
        profile_url: student.css("a").attribute("href").value
      }
    end
  end

  def self.scrape_profile_page(profile_url)
    html = Nokogiri::HTML(open(profile_url))
    html.css("div.social-icon-container").each.with_object({}) do |social, hash|
      social.css("a").each do |site|
        x = site.attribute("href").value
        if x.include?("twitter")
          hash[:twitter] = x
        elsif x.include?("linkedin")
          hash[:linkedin] = x
        elsif x.include?("github")
          hash[:github] = x
        elsif x.include?(".com")
          hash[:blog] = x
        end
      end
      hash[:profile_quote] = html.css("div.profile-quote").text
      hash[:bio] = html.css("div.description-holder p").text
    end
  end

end
