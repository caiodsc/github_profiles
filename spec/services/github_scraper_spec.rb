# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GithubScraper do
  let(:github_url) { 'https://github.com/matz' }
  let(:scraper) { described_class.new(github_url) }

  describe '#user_info' do
    subject { scraper.user_info }
    let(:expected_user_info) do
      {
        github_name: 'matz',
        followers: '9.7k',
        following: '1',
        stars: '17',
        contributions_last_year: '757',
        profile_image_url: 'https://avatars.githubusercontent.com/u/30733?v=4',
        location: 'Matsue, Japan',
        organization: 'Ruby Association,NaCl'
      }
    end

    context 'with a valid GitHub profile' do
      it 'returns the correct metadata' do
        VCR.use_cassette('github_profile') do
          expect(subject).to eq(expected_user_info)
        end
      end
    end
  end
end
