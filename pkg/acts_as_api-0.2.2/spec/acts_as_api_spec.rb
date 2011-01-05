require File.dirname(__FILE__) + '/spec_helper.rb'

describe "acts_as_api" do

  before(:each) do
    @luke = Customer.new({ :firstname => 'Luke', :lastname => 'Skywalker', :age => 25, :active => true  })
    @han  = Customer.new({ :firstname => 'Han',  :lastname => 'Solo',      :age => 35, :active => true  })
    @leia = Customer.new({ :firstname => 'Princess',  :lastname => 'Leia', :age => 25, :active => false })
  end
  
  describe "acts_as_api is disabled by default" do
    it "should indicate that acts_as_api is disabled" do
      Customer.acts_as_api?.should be_false
    end

    it "should not respond to api_accessible" do
      Customer.should_not respond_to :api_accessible
    end
  end

  describe "acts_as_api is enabled" do

    before(:each) do
      Customer.acts_as_api
    end

    it "should indicate that acts_as_api is enabled" do
      Customer.acts_as_api?.should be_true
    end

    it "should not respond to api_accessible" do
      Customer.should respond_to :api_accessible
    end

    describe "listing attributes in the api template" do

      before(:each) do
        Customer.api_accessible :v1_default => [ :firstname, :lastname ]
        @response = @luke.as_api_response(:v1_default)
      end
      
      it "should return a hash" do
        @response.should be_kind_of(Hash)
      end

      it "should return the correct number of keys" do
        @response.should have(2).keys
      end

      it "should return all specified fields" do
        @response.keys.should include(:firstname, :lastname)
      end

      it "should return the correct values for the specified fields" do
        @response.values.should include(@luke.firstname, @luke.lastname)
      end
      
    end

    describe "calling a method in the api template" do

      before(:each) do
        Customer.api_accessible :v1_only_full_name => [ :full_name ]
        @response = @luke.as_api_response(:v1_only_full_name)
      end

      it "should return a hash" do
        @response.should be_kind_of(Hash)
      end

      it "should return the correct number of keys" do
        @response.should have(1).key
      end

      it "should return all specified fields" do
        @response.keys.should include(:full_name)
      end

      it "should return the correct values for the specified fields" do
        @response.values.should include(@luke.full_name)
      end      

    end
  
    describe "renaming an attribute in the api template" do
       
    end

    describe "renaming the node/key of a method in the api template" do

    end

    describe "including a scoped association in the api template" do

    end

    describe "including an association (which doesn't acts_as_api) in the api template" do
    
    end

    describe "including an association (which does acts_as_api) in the api template" do

    end

    describe "creating a sub node in the api template and putting an attribute in it" do

    end

    describe "creating multiple sub nodes in the api template and putting an attribute in it" do

    end

  end

end
