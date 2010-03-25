class UserMailer < ActionMailer::Base

    #TODO: ADJUST TRANSALTION
  def reset_notification(user, request)
    setup_email(user)
    #@subject    += 'Link to reset your password'
    subject    I18n.translate('controller.user.link_to_reset_your_password')
    @body[:url]  =  url_prefix(request) + "/reset/#{user.perishable_token}"
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
