require 'action_controller'

module Refinery
  module Admin
    module BaseController

      def self.included(base)
        base.layout :layout?

        base.before_action :require_refinery_users!, :force_ssl!,
                           :authenticate_refinery_user!, :restrict_plugins,
                           :restrict_controller
        base.after_action :store_location?, :only => [:index] # for redirect_back_or_default

        base.helper_method :searching?, :group_by_date, :refinery_admin_root_path
      end

      def admin?
        true # we're in the admin base controller, so always true.
      end

      def searching?
        params[:search].present?
      end

      def refinery_admin_root_path
        current_refinery_user.plugins.map { |plugin|
          user_plugin = Refinery::Plugins.active.find_by_name(plugin.name)
          user_plugin.url if user_plugin && !user_plugin.hide_from_menu && user_plugin.url.present?
        }.compact.first
      end

      protected

      def force_ssl!
        redirect_to :protocol => 'https' if Refinery::Core.force_ssl && !request.ssl?
      end

      def group_by_date(records)
        new_records = []

        records.each do |record|
          key = record.created_at.strftime("%Y-%m-%d")
          record_group = new_records.map{ |r| r.last if r.first == key }.flatten.compact << record
          (new_records.delete_if { |i| i.first == key}) << [key, record_group]
        end

        new_records
      end

      def require_refinery_users!
        redirect_to refinery.new_signup_path if just_installed? && controller_name != 'users'
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
        unless allow_controller? params[:controller].gsub 'admin/', ''
          logger.warn "'#{current_refinery_user.username}' tried to access '#{params[:controller]}' but was rejected."
          error_404
        end
      end

      private

      def allow_controller?(controller_path)
        ::Refinery::Plugins.active.any? do |plugin|
          Regexp.new(plugin.menu_match) === controller_path
        end
      end

      def layout?
        "refinery/admin#{'_dialog' if from_dialog?}"
      end

      # Check whether it makes sense to return the user to the last page they
      # were at instead of the default e.g. refinery_admin_pages_path
      # right now we just want to snap back to index actions and definitely not to dialogues.
      def store_location?
        store_location unless request.xhr? || from_dialog?
      end

      # Override authorized? so that only users with the Refinery role can admin the website.
      def authorized?
        refinery_user?
      end
    end
  end
end
