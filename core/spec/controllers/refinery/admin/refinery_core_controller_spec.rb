require 'spec_helper'

module Refinery
  module Admin
    describe CoreController do
      refinery_login_with :refinery_user

      it "updates the plugin positions" do
        plugins = logged_in_user.plugins.reverse.collect(&:name)

        post 'update_plugin_positions', :menu => plugins

        logged_in_user.plugins.reload.each_with_index do |plugin, idx|
          plugin.name.should eql(plugins[idx])
        end
      end
    end
  end
end
