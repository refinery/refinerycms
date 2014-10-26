require 'spec_helper'

module Refinery
  module Admin
    describe CoreController, :type => :controller do
      refinery_login

      it "updates the plugin positions" do
        plugins = logged_in_user.plugins.reverse.map &:name

        post 'update_plugin_positions', :menu => plugins

        logged_in_user.plugins.reload.each_with_index do |plugin, idx|
          expect(plugin.name).to eql(plugins[idx])
        end
      end
    end
  end
end
