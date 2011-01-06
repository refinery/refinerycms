class UserMailer < ActionMailer::Base

  def reset_notification(user, request)
    @user = user
    @url = edit_user_password_url(:host => request.host_with_port,
                                  :reset_password_token => @user.reset_password_token)

    domain = request.domain(RefinerySetting.find_or_set(:tld_length, 1))

    mail(:to => user.email,
         :subject => I18n.translate('user_mailer.link_to_reset_your_password'),
         :from => "\"#{RefinerySetting[:site_name]}\" <no-reply@#{domain}>")
  end

protected

  def url_prefix(request)
    "#{request.protocol}#{request.host_with_port}"
  end
end
