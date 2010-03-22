require File.dirname(__FILE__) + "/lib/i18n-js"

config.to_prepare do
  SimplesIdeias::I18n.export!
end
