require 'open-uri'

class Scraper

  def self.scrape_index_page(index_url)
    Array.new.tap do |data|
      Nokogiri::HTML(open(index_url)).css('div.student-card a').each do |student|
        data << {
          name:  student.css('h4.student-name').text,
          location: student.css('p.student-location').text,
          profile_url: student['href'],
        }
      end
    end
  end

  def self.scrape_profile_page(profile_url)
    social_media = {}
    profile = Nokogiri::HTML(open(profile_url))
    targeted_platforms = [:twitter, :linkedin, :github, :blog]

    # get social
    # this assigns instagram, facebook etc to :blog,
    # can't have those keys w/ this test suite.
    profile.css('.social-icon-container a').each do |social|
      domain = social['href'][/\/\/w*\.*(.+)\.com/, 1].to_sym
      sym = targeted_platforms.include?(domain) ? domain : :blog
      social_media[sym] = social['href']
    end

    # build data hash
    data = {
      profile_quote: profile.css('.profile-quote').text,
      bio: profile.css('.bio-content .description-holder p').text,
    }    
    targeted_platforms.each { |target| data[target] = social_media[target] }
    data.delete_if { |k,v| v.nil? }
  end
end
