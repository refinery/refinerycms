Rails.application.routes.draw do
  mount Refinery::Core::Engine, :at => "/"
end
