class UserMailer < ActionMailer::Base

  def reset_notification(user, request)
    setup_email(user)
    #TODO: ADJUST TRANSALTION
    #@subject    += 'Link to reset your password'
    @subject    += I18n.translate('please_activate')
    @body[:url]  = "#{request.protocol}#{request.host_with_port}/reset/#{user.reset_code}"
  end


protected

  def setup_email(user)
    @recipients  = user.email
    @subject     = ""
    @sent_on     = Time.now
    @body[:user] = user
  end

end
