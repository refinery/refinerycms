require 'spec_helper'

module Refinery
  module Admin
    describe CoreController do
      login_refinery_user

      it "updates the plugin positions" do
        plugins = refinery_user.plugins.reverse.collect(&:name)

        post 'update_plugin_positions', :menu => plugins

        refinery_user.plugins.reload
        refinery_user.plugins.each_with_index do |plugin, idx|
          plugin.name.should eql(plugins[idx])
        end
      end
    end
  end
end
