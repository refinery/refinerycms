module Refinery
  class PasswordsController < Devise::PasswordsController
    helper Refinery::Core::Engine.helpers
    layout 'refinery/layouts/login'

    before_action :store_password_reset_return_to, :only => [:update]
    def store_password_reset_return_to
      session[:'refinery_user_return_to'] = Refinery::Core.backend_path
    end
    protected :store_password_reset_return_to

    # Rather than overriding devise, it seems better to just apply the notice here.
    after_action :give_notice, :only => [:update]
    def give_notice
      if %w(notice error alert).exclude?(flash.keys.map(&:to_s)) or @refinery_user.errors.any?
        flash[:notice] = t('successful', :scope => 'refinery.users.reset', :email => @refinery_user.email)
      end
    end
    protected :give_notice

    # POST /registrations/password
    def create
      if params[:refinery_user].present? && (email = params[:refinery_user][:email]).present? &&
         (user = User.where(:email => email).first).present?

        user.send_reset_password_instructions
        redirect_to refinery.login_path,
                    :notice => t('email_reset_sent', :scope => 'refinery.users.forgot')
      else
        flash.now[:error] = if (email = params[:refinery_user][:email]).blank?
          t('blank_email', :scope => 'refinery.users.forgot')
        else
          t('email_not_associated_with_account_html', :email => ERB::Util.html_escape(email), :scope => 'refinery.users.forgot').html_safe
        end

        @refinery_user = Refinery::User.new

        render :new
      end
    end

    def edit

      unless params.has_key?(:reset_password_token)
        return redirect_to '/'
      end

      token = Devise.token_generator.digest(self.resource, :reset_password_token, params[:reset_password_token])
      @resource = resource_class.where(reset_password_token: token).first

      unless @resource.present? && @resource.reset_password_period_valid?
        return redirect_to '/'
      end

      if current_refinery_user.present?
        sign_out(current_refinery_user)
      end

      self.resource = resource_class.new
      resource.reset_password_token = params[:reset_password_token]
    end

    # PUT /resource/password
    def update
      self.resource = resource_class.reset_password_by_token(resource_params)
      yield resource if block_given?
      @resource = self.resource

      if resource.errors.empty?
        resource.unlock_access! if unlockable?(resource)

        # Added in to set an unconfirmed resource to confirmed.
        unless resource.confirmed?
          self.resource.confirmed_on = Time.new.strftime('%Y-%m-%d %H:%M:%S')
          self.resource.save
        end

        flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
        set_flash_message(:notice, flash_message) if is_flashing_format?
        sign_in(resource_name, resource)
        respond_with resource, location: after_resetting_password_path_for(resource)
      else
        respond_with resource
      end
    end
  end
end
