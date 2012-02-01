module Refinery
  class UserMailer < ActionMailer::Base

    def reset_notification(user, request)
      @user = user
      @url = refinery.edit_refinery_user_password_url({
        :host => request.host_with_port,
        :reset_password_token => @user.reset_password_token
      })

      mail(:to => user.email,
           :subject => t('subject', :scope => 'refinery.user_mailer.reset_notification'),
           :from => "\"#{Refinery::Core.site_name}\" <no-reply@#{request.domain}>")
    end

  protected

    def url_prefix(request)
      "#{request.protocol}#{request.host_with_port}"
    end
  end
end
