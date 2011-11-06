require 'spec_helper'

describe "Mongoid", :orm => "mongoid" do
  
  before(:each) do
    setup_mongoid_models
  end

  after(:each) do
    clean_up_mongoid_models
  end
  
  describe :act_as_api do
    it_supports "including an association in the api template"
    it_supports "calling a closure in the api template"
    it_supports "conditional if statements"
    it_supports "conditional unless statements" 
    it_supports "acts_as_api is enabled"
    it_supports "extending a given api template"
    it_supports "calling a method in the api template"
    it_supports "renaming"
    it_supports "listing attributes in the api template"
    it_supports "creating a sub hash in the api template"
    it_supports "trying to render an api template that is not defined"
    it_supports "untouched models"
    it_supports "defining a model callback"
  end
  
end
