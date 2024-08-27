# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersHelper, type: :helper do
  describe '#shortened_github_url' do
    let(:user) { create(:user, unique_identifier:) }
    let(:unique_identifier) { 1_000_000 }
    let(:expected_shortened_url) { 'http://localhost:3000/s/4c92' }

    subject(:shortened_github_url) { helper.shortened_github_url(user) }

    it 'returns the correct shortened GitHub URL' do
      expect(shortened_github_url).to eq(expected_shortened_url)
    end
  end
end
