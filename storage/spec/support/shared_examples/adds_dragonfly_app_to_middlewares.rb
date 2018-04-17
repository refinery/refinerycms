shared_examples_for 'adds the dragonfly app to the middleware stack' do

  let(:middleware_array){ Rails.application.config.middleware.to_a}

  describe 'middleware stack:' do
    it 'includes Dragonfly::Middleware' do
      expect(middleware_array).to include(Dragonfly::Middleware)
    end
  end
end
