shared_examples_for "creating a sub hash in the api template" do

  describe "and putting an attribute in it" do

    before(:each) do
      @response = @luke.as_api_response(:sub_node)
    end

    it "returns a hash" do
      @response.should be_kind_of(Hash)
    end

    it "returns the correct number of fields" do
      @response.should have(1).keys
    end

    it "returns all specified fields" do
      @response.keys.should include(:sub_nodes)
    end

    it "returns the correct values for the specified fields" do
      @response[:sub_nodes].should be_a Hash
    end

    it "provides the correct number of sub nodes" do
      @response[:sub_nodes].should have(1).keys
    end

    it "provides the correct sub nodes values" do
      @response[:sub_nodes][:foo].should eql("something")
    end
  end

  describe "multiple times and putting an attribute in it" do

    before(:each) do
      @response = @luke.as_api_response(:nested_sub_node)
    end

    it "returns a hash" do
      @response.should be_kind_of(Hash)
    end

    it "returns the correct number of fields" do
      @response.should have(1).keys
    end

    it "returns all specified fields" do
      @response.keys.should include(:sub_nodes)
    end

    it "returns the correct values for the specified fields" do
      @response[:sub_nodes].should be_a Hash
    end

    it "provides the correct number of sub nodes" do
      @response[:sub_nodes].should have(1).keys
    end

    it "provides the correct number of sub nodes in the second level" do
      @response[:sub_nodes][:foo].should have(1).keys
    end

    it "provides the correct sub nodes values" do
      @response[:sub_nodes][:foo].tap do |foo|
        foo[:bar].tap do |bar|
          bar.should eql(@luke.last_name)
        end
      end
    end

  end

  describe "using a method" do

    before(:each) do
      @response = @luke.as_api_response(:nested_sub_hash)
    end

    it "returns a hash" do
      @response.should be_kind_of(Hash)
    end

    it "returns the correct number of fields" do
      @response.should have(1).keys
    end

    it "returns all specified fields" do
      @response.keys.should include(:sub_hash)
    end

    it "provides the correct number of sub nodes" do
      @response[:sub_hash].should have(2).keys
    end

    it "provides the correct sub nodes" do
      @response[:sub_hash].keys.should include(:foo, :hello)
    end

    it "provides the correct values in its sub nodes" do
      @response[:sub_hash].values.should include("bar", "world")
    end

  end
end