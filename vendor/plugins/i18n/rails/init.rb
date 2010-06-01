lib_dir = Pathname.new(__FILE__).parent.parent.join("lib")

['i18n', 'routing_filter/routing_filter', 'routing_filter/routing_filter/base', 'i18n_filter'].each do |file|
  require lib_dir.join(file).to_s
end
