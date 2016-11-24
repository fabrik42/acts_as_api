shared_examples_for 'options' do
  describe 'options in the api template' do
    before :each do
      User.api_accessible :with_options do |t|
        t.add ->(_, options) { options }, as: :options
        t.add :profile
        t.add :first_name, if: ->(_, options) { options[:with_name] }
      end

      Profile.acts_as_api
      Profile.api_accessible :with_options do |t|
        t.add ->(_, options) { options }, as: :options
      end

      Task.acts_as_api
      Task.api_accessible :other_template do |t|
        t.add :description
        t.add :time_spent
        t.add ->(_, options) { options }, as: :options
      end
    end

    context 'as_api_response accept options' do
      subject(:response) { @luke.as_api_response(:with_options, loc: [12, 13]) }

      it 'returns the options field as specified' do
        expect(response[:options][:loc]).to eq([12, 13])
      end

      it 'returns the option for the associations ' do
        expect(response[:profile][:options][:loc]).to eq([12, 13])
      end
    end

    context 'allowed_to_render accept options' do
      it 'should not contains first_name when options[:with_name] is false' do
        response = @luke.as_api_response(:with_options, with_name: false)
        expect(response).not_to include(:first_name)
      end

      it 'should contains first_name when options[:with_name] is true' do
        response = @luke.as_api_response(:with_options, with_name: true)
        expect(response[:first_name]).to eq('Luke')
      end
    end
  end
end
