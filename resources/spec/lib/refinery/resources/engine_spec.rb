require 'spec_helper'

module Refinery
  describe Resources do
    it_has_behaviour 'Creates a dragonfly App:'
    it_has_behaviour 'adds the dragonfly app to the middleware stack'

    it 'calls dragonfly#before_serve to set configuration' do
      dummy_proc = -> (_job, _env) {}
      expect_any_instance_of(::Dragonfly::Server).to(
        receive(:before_serve) { |&block| expect(block).to be(dummy_proc) }
      )
      ::Refinery::Resources.configure do |config|
        config.dragonfly_before_serve = dummy_proc
      end

      ::Refinery::Dragonfly.configure!(::Refinery::Resources)
    end
  end
end
