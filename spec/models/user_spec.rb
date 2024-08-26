# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }

  describe 'constants' do
    it { expect(User::PENDING_STATE).to eq(:pending) }
    it { expect(User::PROCESSING_STATE).to eq(:processing) }
    it { expect(User::COMPLETED_STATE).to eq(:completed) }
    it { expect(User::FAILED_STATE).to eq(:failed) }
    it { expect(User::SEARCH_COLUMNS).to eq(%w[name github_name location organization]) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:github_url) }

    it { is_expected.to validate_length_of(:name).is_at_most(25) }
    it { is_expected.to validate_length_of(:github_url).is_at_most(50) }

    it { is_expected.to allow_value(valid_github_url).for(:github_url) }
  end

  describe 'encrypt' do
    it { is_expected.to encrypt(:github_url).deterministic(true).downcase(true) }
  end

  describe 'callbacks' do
    subject { build(:user) }

    it 'callbacks start_processing! after create' do
      is_expected.to receive(:start_processing!)
      subject.save!
    end
  end

  describe 'scopes' do
    describe 'search_by_term' do
      subject { User.search_by_term(term) }
      let(:term) { 'example' }

      it { expect(subject.to_sql).to include("WHERE (name ILIKE '%example%' OR github_name ILIKE '%example%' OR location ILIKE '%example%' OR organization ILIKE '%example%')") }
    end
  end

  describe 'methods' do
    describe 'start_processing!' do
      subject { create(:user, skip_callbacks: true) }

      it {
        expect(GithubScraperJob).to receive(:perform_later).with(subject.id)
        subject.start_processing!
      }

      it {
        expect { subject.start_processing! }.to change { subject.state }
          .from('pending')
          .to('processing')
      }
    end

    describe 'reprocess!' do
      subject { create(:user, :processed, skip_callbacks: true) }

      it {
        expect(GithubScraperJob).to receive(:perform_later).with(subject.id)
        subject.reprocess
      }

      it {
        expect { subject.reprocess! }.to change { subject.state }
          .from('completed')
          .to('processing')
      }
    end
  end

  private

  def valid_github_url
    Faker::Internet.url(scheme: 'https', host: 'github.com',
                        path: "/#{Faker::Internet.username(specifier: 6, separators: %w[_ -])}")
  end
end
