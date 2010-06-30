lib_dir = Pathname.new(__FILE__).parent.parent.join("lib")
%w(i18n.rb routing_filter/routing_filter.rb routing_filter/routing_filter/base.rb i18n_filter.rb).each do |file|
  require lib_dir.join(file).to_s if lib_dir.join(file).exist?
end
