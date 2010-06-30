require File.dirname(__FILE__) + '/spec_helper.rb'

# Time to add your specs!
# http://rspec.info/
describe "setting up acts_as_api" do

  before(:each) do
    @luke = Customer.new({ :firstname => 'Luke', :lastname => 'Skywalker', :age => 25, :active => true  })
    @han  = Customer.new({ :firstname => 'Han',  :lastname => 'Solo',      :age => 35, :active => true  })
    @leia = Customer.new({ :firstname => 'Princess',  :lastname => 'Leia', :age => 25, :active => false })

    # always reset the api_accessible values
    Customer.write_inheritable_attribute(:api_accessible, Set.new )
  end
  
  it "should be disabled by default" do
    Customer.acts_as_api?.should be_false
    Customer.should_not respond_to :api_accessible
    # now enable it
    Customer.acts_as_api
    # should respond now
    Customer.acts_as_api?.should be_true
    Customer.should respond_to :api_accessible
  end

  it "check simple attributes list" do

    Customer.api_accessible :firstname, :lastname

    response = @luke.as_api_response

    response.should be_kind_of(Hash)

    response.should have(2).keys

    response.keys.should include(:firstname, :lastname)

    response.values.should include(@luke.firstname, @luke.lastname)

  end

  it "check method call in attributes list" do

    Customer.api_accessible :full_name

    response = @luke.as_api_response

    response.should be_kind_of(Hash)

    response.should have(1).keys

    response.keys.should include(:full_name)

    response.values.should include(@luke.full_name)

  end

  
  it "check renaming the node/key of an attribute" do

  end

  it "check renaming the node/key of a method" do

  end

  it "check included associations in attributes list (DON'T act_as_api themselves)" do
    
  end


  it "check included associations in attributes list (DO act_as_api themselves)" do

  end

  it "check creating a sub node and putting an attribute in it" do

  end



  it "check creating multiple sub nodes and putting an attribute in it" do

  end


end
