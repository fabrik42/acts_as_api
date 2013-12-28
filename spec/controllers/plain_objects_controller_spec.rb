require 'spec_helper'

describe SharedEngine::PlainObjectsController do
  include ApiTestHelpers

  before(:each) do
    class SharedEngine::PlainObjectsController
      include SimpleFixtures
    end
  end

  describe 'get all users as a an array of plain objects, autodetecting the root node name' do

    before(:each) do
      get :index, :format => 'json', :api_template => :name_only
    end

    it "should have a root node named users" do
      response_body_json.should have_key("plain_objects")
    end

    it "should contain all users" do
      response_body_json["plain_objects"].should be_a(Array)
    end

    it "should contain the specified attributes" do
      response_body_json["plain_objects"].first.should have_key("first_name")
      response_body_json["plain_objects"].first.should have_key("last_name")
    end

    it "should contain the specified values" do
      response_body_json["plain_objects"].first["first_name"].should eql("Han")
      response_body_json["plain_objects"].first["last_name"].should eql("Solo")
    end
  end
end
