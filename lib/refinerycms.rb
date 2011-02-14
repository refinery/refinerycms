%w(base core settings authentication dashboard images pages resources testing).each do |engine|
  require "refinerycms-#{engine}"
end
