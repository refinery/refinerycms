%w(core images resources pages).each do |extension|
  require "refinerycms-#{extension}"
end
