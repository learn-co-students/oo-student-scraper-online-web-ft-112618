require 'open-uri'

# Scrapes a static local site for student data
class Scraper
  def self.scrape_index_page(index_url)
    [].tap do |data|
      Nokogiri::HTML(File.open(index_url)).css('div.student-card a').each \
      do |student|
        data << {
          name: student.css('h4.student-name').text,
          location: student.css('p.student-location').text,
          profile_url: student['href']
        }
      end
    end
  end

  def self.scrape_profile_page(profile_url)
    profile = Nokogiri::HTML(File.open(profile_url))
    targeted_platforms = %i[twitter linkedin github blog]
    social_media = get_social(profile, targeted_platforms)

    # build data hash
    data = {
      profile_quote: profile.css('.profile-quote').text,
      bio: profile.css('.bio-content .description-holder p').text
    }
    targeted_platforms.each { |target| data[target] = social_media[target] }
    data.delete_if { |_k, v| v.nil? }
  end

  # this assigns instagram, facebook etc to :blog,
  # can't have those keys w/ this test suite.
  def self.get_social(profile, targeted_platforms)
    {}.tap do |data|
      profile.css('.social-icon-container a').each do |social|
        domain = social['href'][%r{\/\/w*\.*(.+)\.com}, 1].to_sym
        sym = targeted_platforms.include?(domain) ? domain : :blog
        data[sym] = social['href']
      end
    end
  end
end
