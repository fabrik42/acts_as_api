shared_examples_for "calling a closure in the api template" do

  describe "i.e. a proc (the record is passed as only parameter)" do

    before(:each) do
      @response = @luke.as_api_response(:calling_a_proc)
    end

    it "returns a hash" do
      @response.should be_kind_of(Hash)
    end

    it "returns the correct number of fields" do
      @response.should have(2).keys
    end

    it "returns all specified fields" do
      @response.keys.sort_by(&:to_s).should eql([:all_caps_name, :without_param])
    end

    it "returns the correct values for the specified fields" do
      @response.values.sort.should eql(["LUKE SKYWALKER", "Time"])
    end
  end

  describe "i.e. a lambda (the record is passed as only parameter)" do

    before(:each) do
      @response = @luke.as_api_response(:calling_a_lambda)
    end

    it "returns a hash" do
      @response.should be_kind_of(Hash)
    end

    it "returns the correct number of fields" do
      @response.should have(2).keys
    end

    it "returns all specified fields" do
      @response.keys.sort_by(&:to_s).should eql([:all_caps_name, :without_param])
    end

    it "returns the correct values for the specified fields" do
      @response.values.sort.should eql(["LUKE SKYWALKER", "Time"])
    end

  end
end
