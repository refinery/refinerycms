%w(core images resources pages).each do |extension|
  require ['refinery', extension].join('/')
end
