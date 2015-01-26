Rails.application.routes.draw do
  mount Refinery::Core::Engine, :at => Refinery::Core.mounted_path
end
