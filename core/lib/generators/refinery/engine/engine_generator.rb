module Refinery
  class EngineGenerator < Rails::Generators::Base
    Refinery.deprecate('rails generate refinery:engine',
      :when => '2.2',
      :replacement => 'rails generate refinery:extension')
  end
end
