module Translate
  def self.locales_dir=(dir)
    @locales_dir = dir.to_s
  end

  def self.locales_dir
    @locales_dir || Rails.root.join("config", "locales").to_s
  end
end

Dir[File.join(File.dirname(__FILE__), "translate", "*.rb")].each do |file|
  require file
end
