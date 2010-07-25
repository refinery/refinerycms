class UserMailer < ActionMailer::Base

  def reset_notification(user, request)
    setup_email(user)
    subject         I18n.translate('user_mailer.link_to_reset_your_password')
    @body[:url]  =  reset_users_url(:host => request.host_with_port,
                                    :reset_code => user.perishable_token)
  end

protected

  def url_prefix(request)
    "#{request.protocol}#{request.host_with_port}"
  end

  def setup_email(user)
    recipients    user.email
    sent_on       Time.now
    @body[:user] = user
  end

end
