require 'action_controller'
require 'application_helper'

module Refinery
  module Admin
    module BaseController

      extend ActiveSupport::Concern

      included do
        layout :layout?

        before_filter :authenticate_refinery_user!, :restrict_plugins, :restrict_controller
        after_filter :store_location?, :except => [:new, :create, :edit, :update, :destroy, :update_positions] # for redirect_back_or_default

        helper_method :searching?, :group_by_date
      end

      def admin?
        true # we're in the admin base controller, so always true.
      end

      def searching?
        params[:search].present?
      end

    protected

      def group_by_date(records)
        new_records = []

        records.each do |record|
          key = record.created_at.strftime("%Y-%m-%d")
          record_group = new_records.collect{|records| records.last if records.first == key }.flatten.compact << record
          (new_records.delete_if {|i| i.first == key}) << [key, record_group]
        end

        new_records
      end

      def restrict_plugins
        current_length = (plugins = current_refinery_user.authorized_plugins).length

        # Superusers get granted access if they don't already have access.
        if current_refinery_user.has_role?(:superuser)
          if (plugins = plugins | ::Refinery::Plugins.registered.names).length > current_length
            current_refinery_user.plugins = plugins
          end
        end

        ::Refinery::Plugins.set_active(plugins)
      end

      def restrict_controller
        # if ::Refinery::Plugins.active.reject { |plugin| params[:controller] !~ Regexp.new(plugin.menu_match)}.empty?
        #   warn "'#{current_refinery_user.username}' tried to access '#{params[:controller]}' but was rejected."
        #   error_404
        # end
      end

      # Override method from application_controller. Not needed in this controller.
      def find_pages_for_menu; end

      private

      def layout?
        "refinery/admin#{"_dialog" if from_dialog?}"
      end

      # Check whether it makes sense to return the user to the last page they
      # were at instead of the default e.g. refinery_admin_pages_path
      # right now we just want to snap back to index actions and definitely not to dialogues.
      def store_location?
        store_location unless action_name !~ /index/ or request.xhr? or from_dialog?
      end

      # Override authorized? so that only users with the Refinery role can admin the website.
      def authorized?
        refinery_user?
      end
    end
  end
end
