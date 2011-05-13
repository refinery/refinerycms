%w(authentication dashboard images pages resources layouts).each do |engine|
  require "refinerycms-#{engine}"
end
