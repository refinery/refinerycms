require 'spec_helper'

module Refinery
  describe Images do
    it_has_behaviour 'Creates a storage App:'
    it_has_behaviour 'adds the storage app to the middleware stack'
  end
end
