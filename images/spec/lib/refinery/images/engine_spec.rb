require 'spec_helper'

module Refinery
  describe Images do
    it_has_behaviour 'Creates a dragonfly App:'
    it_has_behaviour 'adds the dragonfly app to the middleware stack'
  end
end
