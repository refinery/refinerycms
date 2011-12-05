module ::Refinery
  class UserMailer < ActionMailer::Base

    def reset_notification(user, request)
      @user = user
      @url = main_app.edit_refinery_user_password_url({
        :host => request.host_with_port,
        :reset_password_token => @user.reset_password_token
      })

      domain = request.domain(::Refinery::Setting.find_or_set(:tld_length, 1))

      mail(:to => user.email,
           :subject => t('subject', :scope => 'refinery.user_mailer.reset_notification'),
           :from => "\"#{Refinery::Core.config.site_name}\" <no-reply@#{domain}>")
    end

  protected

    def url_prefix(request)
      "#{request.protocol}#{request.host_with_port}"
    end
  end
end
