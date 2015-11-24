ActionMailer::Base.module_eval do
  # this is so we can make use of all our handy helpers in the email views
  helper Refinery::Core::Engine.helpers
end
