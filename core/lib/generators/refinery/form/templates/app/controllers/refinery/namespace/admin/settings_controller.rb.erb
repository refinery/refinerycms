module Refinery
  module <%= class_name.pluralize %>
    module Admin
      class SettingsController < Refinery::AdminController

        crudify :'refinery/setting',
                :title_attribute => 'name',
                :order => 'name ASC',
                :redirect_to_url => 'refinery.<%= namespacing.underscore %>_admin_<%= plural_name %>_path'

        before_filter :redirect_back_to_<%= plural_name %>?, :only => [:index]
        before_filter :set_url_override?, :only => [:edit, :update]
        after_filter :save_subject_for_confirmation?, :only => [:create, :update]
        around_filter :rewrite_flash?, :only => [:create, :update]

      protected
        def rewrite_flash?
          yield

          flash[:notice] = flash[:notice].to_s.gsub(/(\'.*\')/) {|m| m.titleize}.gsub('<%= class_name %> ', '')
        end

        def save_subject_for_confirmation?
          Refinery::<%= namespacing %>::Setting.confirmation_subject = params[:subject] if params.keys.include?('subject')
        end

        def redirect_back_to_<%= plural_name %>?
          redirect_to refinery.<%= namespacing.underscore %>_admin_<%= plural_name %>_path
        end

        def set_url_override?
          @url_override = refinery.<%= namespacing.underscore %>_admin_setting_url(@setting, :dialog => from_dialog?)
        end

        def find_setting
          # ensure that we're dealing with the name of the setting, not the id.
          if params[:id].to_s.to_i.to_s == params[:id]
            params[:id] = Refinery::Setting.find(params[:id]).name.to_s
          end

          # prime the setting first, if it's valid.
          if Refinery::<%= namespacing %>::Setting.methods.map(&:to_sym).include?(params[:id].to_s.gsub('<%= singular_name %>_', '').to_sym)
            Refinery::<%= namespacing %>::Setting.send(params[:id].to_s.gsub('<%= singular_name %>_', '').to_sym)
          end
          @setting = Refinery::Setting.find_by_name(params[:id])
        end

      end
    end
  end
end
