shared_examples_for "including an association in the api template" do
  
  describe "which doesn't acts_as_api" do
  
    before(:each) do
      @response = @luke.as_api_response(:include_tasks)
    end
  
    it "returns a hash" do
      @response.should be_kind_of(Hash)
    end
  
    it "returns the correct number of fields" do
      @response.should have(1).keys
    end
  
    it "returns all specified fields" do
      @response.keys.should include(:tasks)
    end
  
    it "returns the correct values for the specified fields" do
      @response[:tasks].should be_an Array
      @response[:tasks].should have(3).tasks
    end
  
    it "should contain the associated sub models" do
      @response[:tasks].should include(@destroy_deathstar, @study_with_yoda, @win_rebellion)
    end
  end
  
  describe "which does acts_as_api" do
  
    context "has_many" do
  
      before(:each) do
        Task.acts_as_api
        Task.api_accessible :include_tasks do |t|
          t.add :heading
          t.add :done
        end
        @response = @luke.as_api_response(:include_tasks)
      end
  
      it "returns a hash" do
        @response.should be_kind_of(Hash)
      end
  
      it "returns the correct number of fields" do
        @response.should have(1).keys
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
          task.keys.should include(:heading, :done)
          task.keys.should have(2).attributes
        end
      end
  
      it "contains the correct data of the child models" do
        task_hash = [  @destroy_deathstar, @study_with_yoda, @win_rebellion  ].collect{|t| { :done => t.done, :heading => t.heading } }
        @response[:tasks].should eql task_hash
      end
    end
  
    context "has_one" do
  
      before(:each) do
        Profile.acts_as_api
        Profile.api_accessible :include_profile do |t|
          t.add :avatar
          t.add :homepage
        end
        @response = @luke.as_api_response(:include_profile)
      end
  
      it "returns a hash" do
        @response.should be_kind_of(Hash)
      end
  
      it "returns the correct number of fields" do
        @response.should have(1).keys
      end
  
      it "returns all specified fields" do
        @response.keys.should include(:profile)
      end
  
      it "returns the correct values for the specified fields" do
        @response[:profile].should be_a Hash
        @response[:profile].should have(2).attributes
      end
  
      it "contains the associated child models with the determined api template" do
        @response[:profile].keys.should include(:avatar, :homepage)
      end
  
      it "contains the correct data of the child models" do
        profile_hash = { :avatar => @luke.profile.avatar, :homepage => @luke.profile.homepage }
        @response[:profile].should eql profile_hash
      end
  
    end
  end
  
  describe "which does acts_as_api, but with using another template name" do
  
    before(:each) do
      Task.acts_as_api
      Task.api_accessible :other_template do |t|
        t.add :description
        t.add :time_spent
      end
      @response = @luke.as_api_response(:other_sub_template)
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
  
  describe "that is scoped" do
  
    before(:each) do
      # extend task model with scope
      #class Task < ActiveRecord::Base
      Task.class_eval do
        scope :completed, where(:done => true)
      end
      Task.acts_as_api
      Task.api_accessible :include_completed_tasks do |t|
        t.add :heading
        t.add :done
      end
  
      @response = @luke.as_api_response(:include_completed_tasks)
    end
  
    it "returns a hash" do
      @response.should be_kind_of(Hash)
    end
  
    it "returns the correct number of fields" do
      @response.should have(1).keys
    end
  
    it "returns all specified fields" do
      @response.keys.should include(:completed_tasks)
    end
  
    it "returns the correct values for the specified fields" do
      @response[:completed_tasks].should be_an Array
      @response[:completed_tasks].should have(2).tasks
    end
  
    it "contains the associated child models with the determined api template" do
      @response[:completed_tasks].each do |task|
        task.keys.should include(:heading, :done)
        task.keys.should have(2).attributes
      end
    end
  
    it "contains the correct data of the child models" do
      task_hash = [  @destroy_deathstar, @study_with_yoda  ].collect{|t| { :done => t.done, :heading => t.heading } }
      @response[:completed_tasks].should eql task_hash
    end
  end
  
  describe "handling nil values" do
  
    context "has_many" do
  
      before(:each) do
        Task.acts_as_api
        Task.api_accessible :include_tasks do |t|
          t.add :heading
          t.add :done
        end
        @response = @han.as_api_response(:include_tasks)
      end
  
      it "returns a hash" do
        @response.should be_kind_of(Hash)
      end
  
      it "returns the correct number of fields" do
        @response.should have(1).keys
      end
  
      it "returns all specified fields" do
        @response.keys.should include(:tasks)
      end
  
      it "returns the correct values for the specified fields" do
        @response[:tasks].should be_kind_of(Array)
      end
  
      it "contains no associated child models" do
        @response[:tasks].should have(0).items
      end
  
    end
  
    context "has one" do
      before(:each) do
        Profile.acts_as_api
        Profile.api_accessible :include_profile do |t|
          t.add :avatar
          t.add :homepage
        end
        @response = @han.as_api_response(:include_profile)
      end
  
      it "returns a hash" do
        @response.should be_kind_of(Hash)
      end
  
      it "returns the correct number of fields" do
        @response.should have(1).keys
      end
  
      it "returns all specified fields" do
        @response.keys.should include(:profile)
      end
  
      it "returns nil for the association" do
        @response[:profile].should be_nil
      end
    end
  end
end
