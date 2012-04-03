require 'spec_helper'

describe RespondWithUsersController do

  context "using active record", :orm => :active_record do

    before(:each) do
      setup_active_record_models
    end

    after(:each) do
     clean_up_active_record_models
    end

    # see spec/support/controller_examples.rb
    it_behaves_like "a controller with ActsAsApi responses"
  end

  context "using mongoid", :orm => :mongoid do

    before(:each) do
      setup_mongoid_models
    end

    after(:each) do
     clean_up_mongoid_models
    end

    # see spec/support/controller_examples.rb
    it_behaves_like "a controller with ActsAsApi responses"
  end


  describe "default ActionController::Responder behavior" do

    context 'json responses' do

      context "creating valid models" do

        before(:each) do
          post :create, :user => { :first_name => "Luke", :last_name => "Skywalker" }, :api_template => :name_only, :format => 'json', :orm => :active_record
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
          post :create, :user => {}, :api_template => :name_only, :format => 'json', :orm => :active_record
        end

        it "should return HTTP 422 status" do
          response.code.should == "422"
        end

        it "should return errors as json", :meow => true do
          puts "*" * 50
          puts response_body_json
          puts "*" * 50          
          response_body_json['first_name'].should include("can't be blank")
          response_body_json['last_name'].should include("can't be blank")
        end

      end

    end

    context 'xml responses' do

      context "creating valid models" do

        before(:each) do
          post :create, :user => { :first_name => "Luke", :last_name => "Skywalker" }, :api_template => :name_only, :format => 'xml', :orm => :active_record
        end

        it "should return HTTP 201 status" do
          response.code.should == "201"
        end

        it "should include HTTP Location header" do
          response.headers["Location"].should == user_url(User.last)
        end

        it "should contain the specified attributes" do
          response_body.should have_selector("user > first-name")
          response_body.should have_selector("user > last-name")
        end

      end

      context "creating invalid models" do

        before(:each) do
          post :create, :user => {}, :api_template => :name_only, :format => 'xml', :orm => :active_record
        end

        it "should return HTTP 422 status" do
          response.code.should == "422"
        end

        it "should return errors as json" do
          response_body.should have_selector("errors > error")
        end

      end
    end

  end


end
