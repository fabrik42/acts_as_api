require 'spec_helper'

describe ActsAsApi::Base do

  describe "trying to render an api template that is not defined", :orm => :active_record do

    before(:each) do
      setup_models
    end

    after(:each) do
      clean_up
    end

    it "raises an descriptive error" do
      lambda{ @luke.as_api_response(:does_not_exist) }.should raise_error(ActsAsApi::TemplateNotFoundError)
    end

  end
end
