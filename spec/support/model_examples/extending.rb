shared_examples_for "extending a given api template" do

  describe "multiple times" do

    before(:each) do
      User.api_accessible :public do |t|
        t.add :first_name
      end

      User.api_accessible :for_buddies, :extend => :public do |t|
        t.add :age
      end

      User.api_accessible :private, :extend => :for_buddies do |t|
        t.add :last_name
      end
      @response = @luke.as_api_response(:private)
    end

    it "returns a hash" do
      @response.should be_kind_of(Hash)
    end

    it "returns the correct number of fields" do
      @response.should have(3).keys
    end

    it "returns all specified fields" do
      @response.keys.sort_by(&:to_s).should eql([:age, :first_name, :last_name])
    end

    it "returns the correct values for the specified fields" do
      @response.values.sort_by(&:to_s).should eql([@luke.age, @luke.first_name, @luke.last_name].sort_by(&:to_s))
    end

  end

  describe "and removing a former added value" do

    before(:each) do
      @response = @luke.as_api_response(:age_and_first_name)
    end

    it "returns a hash" do
      @response.should be_kind_of(Hash)
    end

    it "returns the correct number of fields" do
      @response.should have(2).keys
    end

    it "returns all specified fields" do
      @response.keys.sort_by(&:to_s).should eql([:first_name, :age].sort_by(&:to_s))
    end

    it "returns the correct values for the specified fields" do
      @response.values.sort_by(&:to_s).should eql([@luke.first_name, @luke.age].sort_by(&:to_s))
    end

  end

  describe "and inherit a field using another template name", :meow => true do

    before(:each) do
      Task.acts_as_api
      Task.api_accessible :other_template do |t|
        t.add :description
        t.add :time_spent
      end
      User.api_accessible :extending_other_template, :extend => :other_sub_template
      @response = @luke.as_api_response(:extending_other_template)
    end

    it "returns a hash" do
      @response.should be_kind_of(Hash)
    end

    it "returns the correct number of fields" do
      @response.should have(2).keys
    end

    it "returns all specified fields" do
      @response.keys.should include(:first_name)
    end

    it "returns the correct values for the specified fields" do
      @response.values.should include(@luke.first_name)
    end

    it "returns all specified fields" do
      @response.keys.should include(:tasks)
    end

    it "returns the correct values for the specified fields" do
      @response[:tasks].should be_an Array
      @response[:tasks].should have(3).tasks
    end

    it "contains the associated child models with the determined api template" do
      @response[:tasks].each do |task|
        task.keys.should include(:description, :time_spent)
        task.keys.should have(2).attributes
      end
    end

    it "contains the correct data of the child models" do
      task_hash = [  @destroy_deathstar, @study_with_yoda, @win_rebellion  ].collect{|t| { :description => t.description, :time_spent => t.time_spent } }
      @response[:tasks].should eql task_hash
    end
  end

end