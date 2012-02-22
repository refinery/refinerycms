%w(core authentication dashboard images resources pages).each do |engine|
  require "refinerycms-#{engine}"
end
