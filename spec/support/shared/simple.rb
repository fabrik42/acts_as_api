shared_examples_for "listing attributes in the api template" do

  before(:each) do
    @response = @luke.as_api_response(:name_only)
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
