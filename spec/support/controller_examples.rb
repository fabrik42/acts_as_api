shared_examples_for "a controller with ActsAsApi responses" do

  include ApiTestHelpers

  before(:each) do
    setup_active_record_models
  end

  after(:each) do
   clean_up_active_record_models
  end

  describe 'xml responses' do

    describe 'get all users' do

      before(:each) do
        get :index, :format => 'xml', :api_template => :name_only
      end

      it "should have a root node named users" do
        response_body.should have_selector("users")
      end

      it "should contain all users" do
        response_body.should have_selector("users > user") do |users|
          users.size.should eql(3)
        end
      end

      it "should contain the specified attributes" do
        response_body.should have_selector("users > user > first-name")
        response_body.should have_selector("users > user > last-name")
      end

    end

    describe 'get a single user' do

      before(:each) do
        get :show, :format => 'xml', :api_template => :name_only, :id => @luke.id
      end

      it "should have a root node named user" do
        response_body.should have_selector("user")
      end

      it "should contain the specified attributes" do
        response_body.should have_selector("user > first-name")
        response_body.should have_selector("user > last-name")
      end

    end

  end


  describe 'json responses' do

    describe 'get all users' do

      before(:each) do
        get :index, :format => 'json', :api_template => :name_only
      end

      it "should have a root node named users" do
        response_body_json.should have_key("users")
      end

      it "should contain all users" do
        response_body_json["users"].should be_a(Array)
      end

      it "should contain the specified attributes" do
        response_body_json["users"].first.should have_key("first_name")
        response_body_json["users"].first.should have_key("last_name")
      end

      it "should contain the specified values" do
        response_body_json["users"].first["first_name"].should eql("Luke")
        response_body_json["users"].first["last_name"].should eql("Skywalker")
      end

    end

    describe 'get a single user' do

      before(:each) do
        get :show, :format => 'json', :api_template => :name_only, :id => @luke.id
      end

      it "should have a root node named user" do
        response_body_json.should have_key("user")
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

    describe 'get a single user with a nil profile' do

      before(:each) do
        Profile.acts_as_api
        Profile.api_accessible :include_profile do |t|
          t.add :avatar
          t.add :homepage
        end

        get :show, :format => 'json', :api_template => :include_profile, :id => @han.id
      end

      it "should have a root node named user" do
        response_body_json.should have_key("user")
      end

      it "should contain the specified attributes" do
        response_body_json["user"].should have(1).keys
        response_body_json["user"].should have_key("profile")
      end

      it "should contain the specified values" do
        response_body_json["user"]["profile"].should be_nil
      end

    end

  end

  describe 'Rails 3 default style json responses' do

    before(:each) do
      @org_include_root_in_json_collections = ActsAsApi::Config.include_root_in_json_collections
      ActsAsApi::Config.include_root_in_json_collections = true
    end

    after(:each) do
      ActsAsApi::Config.include_root_in_json_collections = @org_include_root_in_json_collections
    end

    describe 'get all users' do

      before(:each) do
        get :index, :format => 'json', :api_template => :name_only
      end

      it "should have a root node named users" do
        response_body_json.should have_key("users")
      end

      it "should contain all users" do
        response_body_json["users"].should be_a(Array)
      end

      it "should contain the specified attributes" do
        response_body_json["users"].first["user"].should have_key("first_name")
        response_body_json["users"].first["user"].should have_key("last_name")
      end

      it "contains the user root nodes" do
        response_body_json["users"].collect(&:keys).flatten.uniq.should eql(["user"])
      end

      it "should contain the specified values" do
        response_body_json["users"].first["user"]["first_name"].should eql("Luke")
        response_body_json["users"].first["user"]["last_name"].should eql("Skywalker")
      end

    end

    describe 'get a single user' do

      before(:each) do
        get :show, :format => 'json', :api_template => :name_only, :id => @luke.id
      end

      it "should have a root node named user" do
        response_body_json.should have_key("user")
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

  end

  describe 'jsonp responses with callback' do

    it "should be disabled by default" do
      @callback = "mycallback"
      get :index, :format => 'json', :api_template => :name_only, :callback => @callback
      response_body_jsonp(@callback).should be_nil
    end

    describe "enabled jsonp callbacks" do

      before(:each) do
        @callback = "mycallback"

        User.acts_as_api do |config|
          config.allow_jsonp_callback = true
        end
      end

      after(:each) do
        # put things back to the way they were
        User.acts_as_api do |config|
          config.allow_jsonp_callback = false
        end
      end

      describe 'get all users' do

        before(:each) do
          get :index, :format => 'json', :api_template => :name_only, :callback => @callback
        end

        it "should wrap the response in the callback" do
          response_body_jsonp(@callback).should_not be_nil
        end

      end

      describe 'get a single user' do

        before(:each) do
          get :show, :format => 'json', :api_template => :name_only, :id => @luke.id, :callback => @callback
        end

        it "should wrap the response in the callback" do
          response_body_jsonp(@callback).should_not be_nil
        end

      end

    end
  end


end