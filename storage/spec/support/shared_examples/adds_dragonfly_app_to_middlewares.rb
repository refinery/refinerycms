shared_examples_for 'adds the storage app to the middleware stack' do

  let(:middleware_array){ Rails.application.config.middleware.to_a}

  describe 'middleware stack:' do
    it 'includes Storage::Middleware' do
      expect(middleware_array).to include(Storage::Middleware)
    end
  end
end
