require 'spec_helper'

module Refinery
  module Admin
    describe RefineryCoreController do
      refinery_login_with :refinery_user

      it "should update the plugin positions" do
        plugins = logged_in_user.plugins.reverse.map(&:name)

        post 'update_plugin_positions', :menu => plugins

        logged_in_user.plugins.reload.each_with_index do |plugin, idx|
          plugin.name.should eql(plugins[idx])
        end
      end
    end
  end
end
