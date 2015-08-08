require 'spec_helper'

module Refinery

  describe Dragonfly do
    def configure_dragonfly(name, verify)
      app = ::Dragonfly.app(name)

      app.configure do
        verify_urls verify
      end
    end

    context 'when verify_urls is true' do
      before do
        configure_dragonfly(:app1, true)
      end
      it 'it is reflected in the dragonfly configuration' do
        expect(Dragonfly.app(:app1).server.verify_urls).to be(true)
      end
    end

    context 'when verify_urls is false' do
      before do
        configure_dragonfly(:app2, false)
      end
      it 'it is reflected in the dragonfly configuration' do
        expect(Dragonfly.app(:app2).server.verify_urls).to be(false)
      end
    end

  end
end

