require 'spec_helper'

describe ActsAsApi::Base do

  describe "acts_as_api is enabled", :orm => :active_record do

    it "indicates that acts_as_api is enabled" do
      User.acts_as_api?.should be_true
    end

    it "does respond to api_accessible" do
      User.should respond_to :api_accessible
    end
  end
end
