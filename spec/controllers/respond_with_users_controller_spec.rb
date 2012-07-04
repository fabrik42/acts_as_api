require 'spec_helper'
#
# RSpec.configure do |config|
#   config.include SharedEngine::Engine.routes.url_helpers
# end

describe SharedEngine::RespondWithUsersController do

  before(:each) do
    setup_models
  end

  after(:each) do
   clean_up_models
  end

  # see spec/support/controller_examples.rb
  it_behaves_like "a controller with ActsAsApi responses"

  describe "default ActionController::Responder behavior" do

    context 'json responses' do

      context "creating valid models" do

        before(:each) do
          post :create, :user => { :first_name => "Luke", :last_name => "Skywalker" }, :api_template => :name_only, :format => 'json'
        end

        it "should return HTTP 201 status" do
          response.code.should == "201"
        end

        it "should contain the specified attributes" do
          response_body_json["user"].should have_key("first_name")
          response_body_json["user"].should have_key("last_name")
        end

        it "should contain the specified values" do
          response_body_json["user"]["first_name"].should eql("Luke")
          response_body_json["user"]["last_name"].should eql("Skywalker")
        end
      end

      context "creating invalid models" do

        before(:each) do
          post :create, :user => {}, :api_template => :name_only, :format => 'json'
        end

        it "should return HTTP 422 status" do
          response.code.should == "422"
        end

        it "should return errors as json" do
          response_body_json['errors']['first_name'].should include("can't be blank")
          response_body_json['errors']['last_name'].should include("can't be blank")
        end

      end
      
      context "returning all models without default root and no order" do

        before(:each) do
          get :index_no_root_no_order, :api_template => :name_only, :format => 'json'
        end

        it "should return HTTP 200 status" do
          response.code.should == "200"
        end

        it "should contain the specified attributes" do
          response_body_json["users"].each do |user|
            user.should have_key( "first_name" )
            user.should have_key( "last_name" )
          end
        end

      end

    end

    context 'xml responses' do

      context "creating valid models" do

        before(:each) do
          post :create, :user => { :first_name => "Luke", :last_name => "Skywalker" }, :api_template => :name_only, :format => 'xml'
        end

        it "should return HTTP 201 status" do
          response.code.should == "201"
        end

        it "should include HTTP Location header" do
          response.headers["Location"].should match "/shared/users/#{User.last.id}"
        end

        it "should contain the specified attributes" do
          response_body.should have_selector("user > first-name")
          response_body.should have_selector("user > last-name")
        end

      end

      context "creating invalid models" do

        before(:each) do
          post :create, :user => {}, :api_template => :name_only, :format => 'xml'
        end

        it "should return HTTP 422 status" do
          response.code.should == "422"
        end

        it "should return errors as xml" do
          response_body.should have_selector("errors > error")
        end

      end

      context "returning all models without default root and no order" do

        before(:each) do
          get :index_no_root_no_order, :api_template => :name_only, :format => 'xml'
        end

        it "should return HTTP 200 status" do
          response.code.should == "200"
        end

        it "should contain the specified attributes" do
          response_body.should have_selector( "users > user > first-name", :count => 3 )
          response_body.should have_selector( "users > user > last-name", :count => 3 )
        end

      end
    end

  end

end
