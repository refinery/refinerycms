%w(core images resources pages api).each do |extension|
  require "refinerycms-#{extension}"
end
