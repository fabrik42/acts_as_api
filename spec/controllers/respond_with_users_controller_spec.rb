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

end
