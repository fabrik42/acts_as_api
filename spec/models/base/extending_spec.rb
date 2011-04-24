require File.dirname(__FILE__) + '/../../spec_helper.rb'

describe ActsAsApi::Base do

  describe "extending a given api template", :orm => :active_record do

    before(:each) do
      setup_models
    end

    after(:each) do
      clean_up
    end

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
  end
end
