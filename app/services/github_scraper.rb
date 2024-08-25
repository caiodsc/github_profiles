# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

class GithubScraper
  USERNAME_REGEXP = /[\w-]+$/

  def initialize(github_url)
    @github_url = github_url
    @contributions_url = github_url.sub(USERNAME_REGEXP) { |username| "users/#{username}/contributions" }
  end

  def user_info
    @document = fetch_page(@github_url)
    @contributions_document = fetch_page(@contributions_url)

    {
      github_name:,
      followers:,
      following:,
      stars:,
      contributions_last_year:,
      profile_image_url:
    }
  end

  private

  def fetch_page(url)
    html = URI.open(url).read
    Nokogiri::HTML(html)
  end

  def github_name
    @document.at_css('span.p-nickname.vcard-username.d-block').text.strip
  end

  def followers
    @document.at_css('a[href$="followers"] span').text.strip.to_i
  end

  def following
    @document.at_css('a[href$="following"] span').text.strip.to_i
  end

  def stars
    @document.at_css('a[href$="stars"] span').text.strip.to_i
  end

  def contributions_last_year
    @contributions_document.at_css('h2').text.strip.to_i
  end

  def profile_image_url
    @document.at_css('img.avatar')['src']
  end
end
