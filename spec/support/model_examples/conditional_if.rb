shared_examples_for 'conditional if statements' do
  describe 'using the :if option' do
    describe 'passing a symbol' do
      describe 'that returns false' do
        before(:each) do
          @response = @luke.as_api_response(:if_over_thirty)
        end

        it 'returns a hash' do
          expect(@response).to be_kind_of(Hash)
        end

        it 'returns the correct number of fields' do
          expect(@response).to have(1).keys
        end

        it 'will not add the conditional field but all others' do
          expect(@response.keys).to include(:first_name)
          expect(@response.keys).not_to include(:full_name)
        end

        it 'the other specified fields have the correct value' do
          expect(@response.values).to include(@luke.first_name)
        end
      end

      describe 'that returns nil' do
        before(:each) do
          @response = @luke.as_api_response(:if_returns_nil)
        end

        it 'returns a hash' do
          expect(@response).to be_kind_of(Hash)
        end

        it 'returns the correct number of fields' do
          expect(@response).to have(1).keys
        end

        it 'will not add the conditional field but all others' do
          expect(@response.keys).to include(:first_name)
          expect(@response.keys).not_to include(:full_name)
        end

        it 'the other specified fields have the correct value' do
          expect(@response.values).to include(@luke.first_name)
        end
      end

      describe 'that returns true' do
        before(:each) do
          @response = @han.as_api_response(:if_over_thirty)
        end

        it 'returns a hash' do
          expect(@response).to be_kind_of(Hash)
        end

        it 'returns the correct number of fields' do
          expect(@response).to have(2).keys
        end

        it 'will not add the conditional field but all others' do
          expect(@response.keys).to include(:first_name)
          expect(@response.keys).to include(:last_name)
        end

        it 'the other specified fields have the correct value' do
          expect(@response.values).to include(@han.first_name, @han.last_name)
        end
      end
    end
  end

  describe 'passing a proc' do
    describe 'that returns false' do
      before(:each) do
        @response = @luke.as_api_response(:if_over_thirty_proc)
      end

      it 'returns a hash' do
        expect(@response).to be_kind_of(Hash)
      end

      it 'returns the correct number of fields' do
        expect(@response).to have(1).keys
      end

      it 'will not add the conditional field but all others' do
        expect(@response.keys).to include(:first_name)
        expect(@response.keys).not_to include(:full_name)
      end

      it 'the other specified fields have the correct value' do
        expect(@response.values).to include(@luke.first_name)
      end
    end

    describe 'that returns nil' do
      before(:each) do
        @response = @luke.as_api_response(:if_returns_nil_proc)
      end

      it 'returns a hash' do
        expect(@response).to be_kind_of(Hash)
      end

      it 'returns the correct number of fields' do
        expect(@response).to have(1).keys
      end

      it 'will not add the conditional field but all others' do
        expect(@response.keys).to include(:first_name)
        expect(@response.keys).not_to include(:full_name)
      end

      it 'the other specified fields have the correct value' do
        expect(@response.values).to include(@luke.first_name)
      end
    end

    describe 'that returns true' do
      before(:each) do
        @response = @han.as_api_response(:if_over_thirty_proc)
      end

      it 'returns a hash' do
        expect(@response).to be_kind_of(Hash)
      end

      it 'returns the correct number of fields' do
        expect(@response).to have(2).keys
      end

      it 'will not add the conditional field but all others' do
        expect(@response.keys).to include(:first_name)
        expect(@response.keys).to include(:last_name)
      end

      it 'the other specified fields have the correct value' do
        expect(@response.values).to include(@han.first_name, @han.last_name)
      end
    end
  end
end
