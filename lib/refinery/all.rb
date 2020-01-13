%w(core images resources pages).each do |extension|
  require "refinery_#{extension}"
end
