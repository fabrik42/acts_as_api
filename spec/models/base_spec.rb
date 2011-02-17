require File.dirname(__FILE__) + '/../spec_helper.rb'

describe "acts_as_api" do

  before(:each) do
    @luke = User.create({ :first_name => 'Luke',      :last_name => 'Skywalker', :age => 25, :active => true  })
    @han  = User.create({ :first_name => 'Han',       :last_name => 'Solo',      :age => 35, :active => true  })
    @leia = User.create({ :first_name => 'Princess',  :last_name => 'Leia',      :age => 25, :active => false })

    @destroy_deathstar = @luke.tasks.create({ :heading => "Destroy Deathstar", :description => "XWing, Shoot, BlowUp",  :time_spent => 30,  :done => true })
    @study_with_yoda   = @luke.tasks.create({ :heading => "Study with Yoda",   :description => "Jedi Stuff, ya know",   :time_spent => 60,  :done => true })
    @win_rebellion     = @luke.tasks.create({ :heading => "Win Rebellion",     :description => "no idea yet...",        :time_spent => 180, :done => false })
  end

  after(:each) do
    User.delete_all
    Task.delete_all
  end

  describe "is disabled by default" do
    it "should indicate that acts_as_api is disabled" do
      Untouched.acts_as_api?.should be_false
    end

    it "should not respond to api_accessible" do
      Untouched.should_not respond_to :api_accessible
    end
  end

  describe "is enabled" do

    before(:each) do
      User.acts_as_api
    end

    it "should indicate that acts_as_api is enabled" do      
      User.acts_as_api?.should be_true
    end

    it "should not respond to api_accessible" do
      User.should respond_to :api_accessible
    end

    describe "listing attributes in the api template" do
    
      before(:each) do
        @response = @luke.as_api_response(:name_only)
      end
    
      it "should return a hash" do
        @response.should be_kind_of(Hash)
      end
    
      it "should return the correct number of keys" do
        @response.should have(2).keys
      end
    
      it "should return all specified fields" do
        @response.keys.should include(:first_name, :last_name)
      end
    
      it "should return the correct values for the specified fields" do
        @response.values.should include(@luke.first_name, @luke.last_name)
      end
    
    end
    
    describe "calling a method in the api template" do
    
      before(:each) do
        @response = @luke.as_api_response(:only_full_name)
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
    
      before(:each) do
        @response = @luke.as_api_response(:rename_last_name)
      end
    
      it "should return a hash" do
        @response.should be_kind_of(Hash)
      end
    
      it "should return the correct number of keys" do
        @response.should have(1).key
      end
    
      it "should return all specified fields" do
        @response.keys.should include(:family_name)
      end
    
      it "should return the correct values for the specified fields" do
        @response.values.should include(@luke.last_name)
      end
    
    end
    
    describe "renaming the node/key of a method in the api template" do
    
      before(:each) do
        @response = @luke.as_api_response(:rename_full_name)
      end
    
      it "should return a hash" do
        @response.should be_kind_of(Hash)
      end
    
      it "should return the correct number of keys" do
        @response.should have(1).key
      end
    
      it "should return all specified fields" do
        @response.keys.should include(:other_full_name)
      end
    
      it "should return the correct values for the specified fields" do
        @response.values.should include(@luke.full_name)
      end
    
    end
    
    describe "extending a given api template (multiple times)" do
    
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
    
      it "should return a hash" do
        @response.should be_kind_of(Hash)
      end
    
      it "should return the correct number of keys" do
        @response.should have(3).keys
      end
    
      it "should return all specified fields" do
        @response.keys.sort_by(&:to_s).should eql([:age, :first_name, :last_name])
      end
    
      it "should return the correct values for the specified fields" do
        @response.values.sort_by(&:to_s).should eql([@luke.age, @luke.first_name, @luke.last_name].sort_by(&:to_s))
      end
    
    end    
    
    describe "extending a given api template and removing a former added value" do
    
      before(:each) do        
        @response = @luke.as_api_response(:age_and_first_name)
      end
    
      it "should return a hash" do
        @response.should be_kind_of(Hash)
      end
    
      it "should return the correct number of keys" do
        @response.should have(2).keys
      end
    
      it "should return all specified fields" do
        @response.keys.sort_by(&:to_s).should eql([:first_name, :age].sort_by(&:to_s))
      end
    
      it "should return the correct values for the specified fields" do
        @response.values.sort_by(&:to_s).should eql([@luke.first_name, @luke.age].sort_by(&:to_s))
      end
    
    end    
    
    describe "calling a proc in the api (the record is passed as only parameter)" do
    
      before(:each) do                
        @response = @luke.as_api_response(:calling_a_proc)
      end
    
      it "should return a hash" do
        @response.should be_kind_of(Hash)
      end
    
      it "should return the correct number of keys" do
        @response.should have(2).keys
      end
    
      it "should return all specified fields" do
        @response.keys.sort_by(&:to_s).should eql([:all_caps_name, :without_param])
      end
    
      it "should return the correct values for the specified fields" do
        @response.values.sort.should eql(["LUKE SKYWALKER", "Time"])
      end    
    end    
    
    describe "calling a lambda in the api (the record is passed as only parameter)" do
    
      before(:each) do                
        @response = @luke.as_api_response(:calling_a_lambda)
      end
    
      it "should return a hash" do
        @response.should be_kind_of(Hash)
      end
    
      it "should return the correct number of keys" do
        @response.should have(2).keys
      end
    
      it "should return all specified fields" do
        @response.keys.sort_by(&:to_s).should eql([:all_caps_name, :without_param])
      end
    
      it "should return the correct values for the specified fields" do
        @response.values.sort.should eql(["LUKE SKYWALKER", "Time"])
      end
    
    end    
    
    describe "including an association (which doesn't acts_as_api) in the api template" do
    
      before(:each) do
        @response = @luke.as_api_response(:include_tasks)
      end
    
      it "should return a hash" do
        @response.should be_kind_of(Hash)
      end
    
      it "should return the correct number of keys" do
        @response.should have(1).key
      end
    
      it "should return all specified fields" do
        @response.keys.should include(:tasks)
      end
    
      it "should return the correct values for the specified fields" do
        @response[:tasks].should be_an Array
        @response[:tasks].should have(3).tasks
      end
    
      it "should contain the associated sub models" do
        @response[:tasks].should include(@destroy_deathstar, @study_with_yoda, @win_rebellion)
      end
    
    end
    
    describe "including an association (which does acts_as_api) in the api template" do
    
      before(:each) do
        Task.acts_as_api
        Task.api_accessible :include_tasks do |t|
          t.add :heading
          t.add :done
        end
        @response = @luke.as_api_response(:include_tasks)
      end
    
      it "should return a hash" do
        @response.should be_kind_of(Hash)
      end
    
      it "should return the correct number of keys" do
        @response.should have(1).key
      end
    
      it "should return all specified fields" do
        @response.keys.should include(:tasks)
      end
    
      it "should return the correct values for the specified fields" do
        @response[:tasks].should be_an Array
        @response[:tasks].should have(3).tasks
      end
    
      it "should contain the associated child models with the determined api template" do
        @response[:tasks].each do |task|
          task.keys.should include(:heading, :done)
          task.keys.should have(2).attributes
        end
      end
    
      it "should contain the correct data of the child models" do
        task_hash = [  @destroy_deathstar, @study_with_yoda, @win_rebellion  ].collect{|t| { :done => t.done, :heading => t.heading } }
        @response[:tasks].should eql task_hash
      end
    
    end
    
    describe "including a scoped association in the api template" do
    
      before(:each) do    
        # extend task model with scope
        class Task < ActiveRecord::Base
          scope :completed, where(:done => true)
        end
        Task.acts_as_api
        Task.api_accessible :include_completed_tasks do |t| 
          t.add :heading
          t.add :done
        end
    
        @response = @luke.as_api_response(:include_completed_tasks)
      end
    
      it "should return a hash" do
        @response.should be_kind_of(Hash)
      end
    
      it "should return the correct number of keys" do
        @response.should have(1).key
      end
    
      it "should return all specified fields" do
        @response.keys.should include(:completed_tasks)
      end
    
      it "should return the correct values for the specified fields" do
        @response[:completed_tasks].should be_an Array
        @response[:completed_tasks].should have(2).tasks
      end
    
      it "should contain the associated child models with the determined api template" do
        @response[:completed_tasks].each do |task|
          task.keys.should include(:heading, :done)
          task.keys.should have(2).attributes
        end
      end
    
      it "should contain the correct data of the child models" do
        task_hash = [  @destroy_deathstar, @study_with_yoda  ].collect{|t| { :done => t.done, :heading => t.heading } }
        @response[:completed_tasks].should eql task_hash
      end
    
    end
    
    describe "creating a sub node in the api template and putting an attribute in it" do
    
      before(:each) do
        @response = @luke.as_api_response(:sub_node)
      end
    
      it "should return a hash" do
        @response.should be_kind_of(Hash)
      end
    
      it "should return the correct number of keys" do
        @response.should have(1).key
      end
    
      it "should return all specified fields" do
        @response.keys.should include(:sub_nodes)
      end
    
      it "should return the correct values for the specified fields" do
        @response[:sub_nodes].should be_a Hash        
      end
    
      it "should provide the correct number of sub nodes" do
        @response[:sub_nodes].should have(1).keys
      end
    
      it "should provide the correct sub nodes values" do
        @response[:sub_nodes][:foo].should eql("something")
      end
    end

    describe "creating multiple sub nodes in the api template and putting an attribute in it" do

      before(:each) do
        @response = @luke.as_api_response(:nested_sub_node)
      end

      it "should return a hash" do
        @response.should be_kind_of(Hash)
      end

      it "should return the correct number of keys" do
        @response.should have(1).key
      end

      it "should return all specified fields" do
        @response.keys.should include(:sub_nodes)
      end

      it "should return the correct values for the specified fields" do
        @response[:sub_nodes].should be_a Hash
      end

      it "should provide the correct number of sub nodes" do
        @response[:sub_nodes].should have(1).keys
      end

      it "should provide the correct number of sub nodes in the second level" do
        @response[:sub_nodes][:foo].should have(1).keys
      end

      it "should provide the correct sub nodes values" do
        @response[:sub_nodes][:foo].tap do |foo|
          foo[:bar].tap do |bar|
            bar.should eql(@luke.last_name)
          end
        end
      end

    end

  end

end
