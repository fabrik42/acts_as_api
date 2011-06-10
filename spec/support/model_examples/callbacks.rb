shared_examples_for "defining a model callback" do

  describe "for a" do
    
    describe "around_api_response" do
      
      it "skips rendering if not yielded" do
        @luke.skip_api_response = true
        @luke.as_api_response(:name_only).keys.should include(:skipped)
      end
      
      it "renders if yielded" do
        @luke.as_api_response(:name_only).keys.should_not include(:skipped)
      end
    
    end
    
    describe "before_api_response" do 
      
      it "is called properly" do
        @luke.as_api_response(:name_only)
        @luke.before_api_response_called?.should eql(true)
      end
      
    end
    
    describe "after_api_response" do 
      
      it "is called properly" do
        @luke.as_api_response(:name_only)
        @luke.after_api_response_called?.should eql(true)
      end
      
    end
    
  end

end