class UserMailer < ActionMailer::Base

  def signup_notification(user)
    setup_email(user)
    @subject    += t('.please_activate')
    @body[:url]  = "http://YOURSITE/activate/#{user.activation_code}"
  end

  def activation(user)
    setup_email(user)
    @subject    += t('.activated')
    @body[:url]  = "http://YOURSITE/"
  end

protected

  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = "ADMINEMAIL"
    @subject     = "[YOURSITE] "
    @sent_on     = Time.now
    @body[:user] = user
  end

end
