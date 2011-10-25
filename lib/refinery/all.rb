%w(core authentication dashboard images pages resources).each do |engine|
  require "refinerycms-#{engine}"
end
