# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let!(:user) { create(:user) }

  describe 'GET /users' do
    let!(:user1) { create(:user, name: 'John Doe') }
    let!(:user2) { create(:user, name: 'Jane Smith') }
    let!(:user3) { create(:user, name: 'Johnny Appleseed') }

    it 'returns a successful response' do
      get users_path
      expect(response).to have_http_status(:ok)
    end

    it 'returns all users' do
      get users_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('John Doe')
      expect(response.body).to include('Jane Smith')
      expect(response.body).to include('Johnny Appleseed')
    end
  end

  describe 'GET /users with search term' do
    let!(:user1) { create(:user, name: 'John Doe') }
    let!(:user2) { create(:user, name: 'Jane Smith') }
    let!(:user3) { create(:user, name: 'Johnny Appleseed') }

    context 'when there is a search term' do
      it 'returns users matching the search term' do
        get users_path, params: { query: 'John' }

        expect(response).to have_http_status(:ok)
        expect(response.body).to include('John Doe')
        expect(response.body).to include('Johnny Appleseed')
        expect(response.body).not_to include('Jane Smith')
      end
    end

    context 'when the search term does not match any user' do
      it 'returns no users' do
        get users_path, params: { query: 'Nonexistent' }

        expect(response).to have_http_status(:ok)
        expect(response.body).not_to include('John Doe')
        expect(response.body).not_to include('Jane Smith')
        expect(response.body).not_to include('Johnny Appleseed')
      end
    end
  end

  describe 'GET /users/:id' do
    it 'returns a successful response' do
      get user_path(user)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /users/new' do
    it 'returns a successful response' do
      get new_user_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /users/:id/edit' do
    it 'returns a successful response' do
      get edit_user_path(user)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /users' do
    context 'with valid parameters' do
      let(:valid_params) { { user: { name: 'New User', github_url: 'https://github.com/newuser' } } }

      it 'creates a new user' do
        expect do
          post users_path, params: valid_params
        end.to change(User, :count).by(1)
      end

      it 'redirects to the users index' do
        post users_path, params: valid_params
        expect(response).to redirect_to(users_path)
      end

      it 'returns a success notice' do
        post users_path, params: valid_params
        expect(flash[:notice]).to eq('User was successfully created.')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { user: { name: '', github_url: '' } } }

      it 'does not create a new user' do
        expect do
          post users_path, params: invalid_params
        end.not_to change(User, :count)
      end

      it 'renders the new template with an unprocessable entity status' do
        post users_path, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH/PUT /users/:id' do
    context 'with valid parameters' do
      let(:new_attributes) { { name: 'Updated Name', github_url: 'https://github.com/updated' } }

      it 'updates the user' do
        patch user_path(user), params: { user: new_attributes }
        user.reload
        expect(user.name).to eq('Updated Name')
        expect(user.github_url).to eq('https://github.com/updated')
      end

      it 'redirects to the user show page' do
        patch user_path(user), params: { user: new_attributes }
        expect(response).to redirect_to(user_path(user))
      end

      it 'returns a success notice' do
        patch user_path(user), params: { user: new_attributes }
        expect(flash[:notice]).to eq('User was successfully updated.')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) { { name: '', github_url: '' } }

      it 'does not update the user' do
        patch user_path(user), params: { user: invalid_attributes }
        user.reload
        expect(user.name).not_to eq('')
      end

      it 'renders the edit template with an unprocessable entity status' do
        patch user_path(user), params: { user: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /users/:id' do
    it 'destroys the user' do
      expect do
        delete user_path(user)
      end.to change(User, :count).by(-1)
    end

    it 'redirects to the users index with a success notice' do
      delete user_path(user)
      expect(response).to redirect_to(users_path)
      expect(flash[:notice]).to eq('User was successfully destroyed.')
    end
  end

  describe 'POST /users/:id/reprocess' do
    it 'triggers the reprocess action' do
      expect_any_instance_of(User).to receive(:reprocess!)
      post reprocess_user_path(user)
    end

    it 'redirects to the users index with a success notice' do
      post reprocess_user_path(user)
      expect(response).to redirect_to(users_path)
      expect(flash[:notice]).to eq('Reprocessing in progress, check back shortly for updated details.')
    end
  end
end
