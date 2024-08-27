# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ShortLinks', type: :request do
  alias_method :any_url, :anything

  describe 'GET #show' do
    subject(:make_request) { get short_link_path(short_id) }

    let(:short_id) { ShortCode.encode(user.unique_identifier) }
    let(:user) { create(:user) }

    it "redirects to user's github_url" do
      make_request

      expect(response).to redirect_to(user.github_url)
    end

    it 'returns a 302 status code for a valid short code' do
      make_request

      expect(response).to have_http_status(:found)
    end

    context 'non existent short code' do
      subject(:make_request) { get short_link_path('nonexistent') }

      it 'returns a 404 status code' do
        make_request

        expect(response).to have_http_status(:not_found)
      end

      it { is_expected.not_to redirect_to(any_url) }
    end
  end
end
