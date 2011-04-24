require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe ActsAsApi::Base do

  describe "listing attributes in the api template", :orm => :active_record do

    before(:each) do
      setup_models
      @response = @luke.as_api_response(:name_only)
    end

    after(:each) do
      clean_up
    end

    it "returns a hash" do
      @response.should be_kind_of(Hash)
    end

    it "returns the correct number of fields" do
      @response.should have(2).keys
    end

    it "returns the specified fields only" do
      @response.keys.should include(:first_name, :last_name)
    end

    it "the specified fields have the correct value" do
      @response.values.should include(@luke.first_name, @luke.last_name)
    end

  end
end
