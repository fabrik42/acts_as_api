require 'spec_helper'

describe SharedEngine::PlainObjectsController, type: :controller do
  include ApiTestHelpers
  routes { SharedEngine::Engine.routes }

  before(:each) do
    class SharedEngine::PlainObjectsController
      include SimpleFixtures
    end
  end

  describe 'get all users as a an array of plain objects, autodetecting the root node name' do
    before(:each) do
      get :index, format: 'json', params: { api_template: :name_only }
    end

    it 'should have a root node named users' do
      expect(response_body_json).to have_key('plain_objects')
    end

    it 'should contain all users' do
      expect(response_body_json['plain_objects']).to be_a(Array)
    end

    it 'should contain the specified attributes' do
      expect(response_body_json['plain_objects'].first).to have_key('first_name')
      expect(response_body_json['plain_objects'].first).to have_key('last_name')
    end

    it 'should contain the specified values' do
      expect(response_body_json['plain_objects'].first['first_name']).to eql('Han')
      expect(response_body_json['plain_objects'].first['last_name']).to eql('Solo')
    end
  end
end
