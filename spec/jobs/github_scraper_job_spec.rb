# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GithubScraperJob, type: :job do
  describe '#perform' do
    let(:user) { create(:user) }

    context 'when scraping is successful' do
      let(:user_info) do
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

      before do
        allow_any_instance_of(GithubScraper).to receive(:user_info).and_return(user_info)
      end

      it 'updates the user with the correct information' do
        expect do
          described_class.perform_now(user.id)
          user.reload
        end.to change(user, :state_name)
          .to(User::COMPLETED_STATE).and change(user, :attributes)
          .to include(user_info.stringify_keys)
      end
    end

    context 'when scraping fails' do
      before do
        allow_any_instance_of(GithubScraper).to receive(:user_info).and_raise(StandardError)
      end

      it 'updates the user with the failed state' do
        expect do
          GithubScraperJob.perform_now(user.id)
          user.reload
        end.to change(user, :state_name).to(User::FAILED_STATE)
      end
    end
  end
end
