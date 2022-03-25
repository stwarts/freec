require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe 'POST /users' do
    let(:create_user) { post '/users' }

    context 'when is not admin' do
      it 'is forbidden' do
        expect { create_user }.not_to change { User.count }
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when is admin' do
      it 'creates user' do
        expect { create_user }.to change { User.count }.by(1)
        expect(User.find_by(email: email)).to be_present
      end
    end
  end

  describe 'GET /users' do
    let(:list_users) { get '/users', params: params }
    let(:params) { {} }

    before { list_users }

    context 'when is not admin' do
      it 'is forbidden' do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when is admin' do
      it 'returns users' do
        expect(response).to have_http_status(:success)
        returned_user_ids = JSON.parse(response.body).map { |attr| attr.fetch('id') }
        expect(returned_user_ids).to contain_exactly(*users.pluck(:id))
      end

      context 'with pagination' do
        let(:params) { { page: 1, items: 2 } }

        it 'supports pagination' do
          list_users
          expect(response).to have_http_status(:success)
        end
      end


      context 'with searching' do
        let(:params) { { search: 'search' } }

        it 'supports searching by email' do
          expect(response).to have_http_status(:success)
          expect(JSON.parse(response.body).fetch('id')).to eq(user_matched_email.id)
        end
  
        it 'supports searching by name' do
          expect(response).to have_http_status(:success)
          expect(JSON.parse(response.body).fetch('id')).to eq(user_matched_name.id)
        end
      end
    end
  end

  describe 'GET /users/:id' do
    let(:show_user) { get "/users/#{user.id}" }

    before { show_user }

    context 'when is not admin' do
      it 'is forbidden' do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when is admin' do
      it 'returns a correct user' do
        expect(JSON.parse(response.body).fetch('id')).to eq(user.id)
      end
    end
  end

  describe 'PATCH /users/:id' do
    let(:update_user) { patch "/users/#{user.id}" }

    context 'when is not admin' do
      it 'is forbidden' do
        update_user
        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when is admin' do
      context 'when updated user is admin' do
        it 'is forbidden' do
          expect { update_user }.not_to change { user.name }

          expect(response).to have_http_status(:forbidden)
        end
      end

      context 'when updated user is not admin' do
        it 'updates user' do
          expect { update_user }
            .to change { user.name }
            .from('old_name').to('new_name')
            .and change { user.email }
            .from('old_email').to('new_email')

          expect(response).to have_http_status(:success)
        end
      end
    end
  end

  describe 'DELETE /users' do
    let(:delete_user) { delete "/users/#{user.id}" }

    context 'when is not admin' do
      it 'is forbidden' do
        expect { delete_user }.not_to change { User.count }

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'when is admin' do
      context 'when deleted user is admin' do
        it 'is forbidden' do
          expect { delete_user }.not_to change { User.count }

          expect(response).to have_http_status(:forbidden)
        end
      end

      context 'when deleted user is not admin' do
        it 'deletes user' do
          expect { delete_user }.to change { User.count }.by(-1)

          expect(response).to have_http_status(:success)
          expect(User.find_by(email: user.email)).to be_nil
        end
      end
    end
  end
end
