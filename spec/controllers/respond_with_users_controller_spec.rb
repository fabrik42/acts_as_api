require 'spec_helper'

describe SharedEngine::RespondWithUsersController, type: :controller do
  routes { SharedEngine::Engine.routes }

  before(:each) do
    setup_models
  end

  after(:each) do
    clean_up_models
  end

  # see spec/support/controller_examples.rb
  it_behaves_like 'a controller with ActsAsApi responses'

  describe 'default ActionController::Responder behavior' do
    context 'json responses' do
      context 'creating valid models' do
        before(:each) do
          post :create, format: 'json', params: { user: { first_name: 'Luke', last_name: 'Skywalker' }, api_template: :name_only }
        end

        it 'should return HTTP 201 status' do
          expect(response.code).to eq('201')
        end

        it 'should contain the specified attributes' do
          expect(response_body_json['user']).to have_key('first_name')
          expect(response_body_json['user']).to have_key('last_name')
        end

        it 'should contain the specified values' do
          expect(response_body_json['user']['first_name']).to eql('Luke')
          expect(response_body_json['user']['last_name']).to eql('Skywalker')
        end
      end

      context 'creating invalid models' do
        before(:each) do
          post :create, format: 'json', params: { user: { first_name: 'Luke' }, api_template: :name_only }
        end

        it 'should return HTTP 422 status' do
          expect(response.code).to eq('422')
        end

        it 'should return errors as json' do
          expect(response_body_json['errors']['last_name']).to include('can\'t be blank')
        end
      end

      context 'returning all models without default root and no order' do
        before(:each) do
          get :index_no_root_no_order, format: 'json', params: { api_template: :name_only }
        end

        it 'should return HTTP 200 status' do
          expect(response.code).to eq('200')
        end

        it 'should contain the specified attributes' do
          response_body_json['users'].each do |user|
            expect(user).to have_key('first_name')
            expect(user).to have_key('last_name')
          end
        end
      end
    end

    context 'xml responses' do
      context 'creating valid models' do
        before(:each) do
          post :create, format: 'xml', params: { user: { first_name: 'Luke', last_name: 'Skywalker' }, api_template: :name_only }
        end

        it 'should return HTTP 201 status' do
          expect(response.code).to eq('201')
        end

        it 'should include HTTP Location header' do
          expect(response.headers['Location']).to match "/shared/users/#{User.last.id}"
        end

        it 'should contain the specified attributes' do
          expect(response_body).to have_selector('user > first-name')
          expect(response_body).to have_selector('user > last-name')
        end
      end

      context 'creating invalid models' do
        before(:each) do
          post :create, format: 'xml', params: { user: { first_name: 'Luke' }, api_template: :name_only }
        end

        it 'should return HTTP 422 status' do
          expect(response.code).to eq('422')
        end

        it 'should return errors as xml' do
          expect(response_body).to have_selector('errors > error')
        end
      end

      context 'returning all models without default root and no order' do
        before(:each) do
          get :index_no_root_no_order, format: 'xml', params: { api_template: :name_only }
        end

        it 'should return HTTP 200 status' do
          expect(response.code).to eq('200')
        end

        it 'should contain the specified attributes' do
          expect(response_body).to have_selector('users > user > first-name', count: 3)
          expect(response_body).to have_selector('users > user > last-name', count: 3)
        end
      end
    end
  end
end
