Rails.application.configure do
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              'localhost',
    port:                 587,
    user_name:            'user_name',
    password:             'password',
  }
end
