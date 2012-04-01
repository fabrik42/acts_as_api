shared_examples_for "options" do

  describe "options in the api template" do

    before(:each) do
      @user_model.api_accessible :with_options do |t|
        t.add ->(model,options) { options } , as: :options
        t.add :profile
      end
      @profile_model.acts_as_api
      @profile_model.api_accessible :with_options do |t|
        t.add ->(model,options) { options } , as: :options
      end
      
      @task_model.acts_as_api
      @task_model.api_accessible :other_template do |t|
        t.add :description
        t.add :time_spent
        t.add ->(model,options) { options } , as: :options
      end
      
      @response = @luke.as_api_response(:with_options, loc: [12, 13])
      
    end

    it "returns the options field as specified" do
      @response[:options][:loc].should      == [12, 13]
    end
    
    it "returns the option for the associations " do
      @response[:profile][:options][:loc].should      == [12, 13]
    end

  end
end
