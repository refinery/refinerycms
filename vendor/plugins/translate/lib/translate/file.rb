require 'fileutils'

class Translate::File
  attr_accessor :path
  
  def initialize(path)
    self.path = path
  end
  
  def write(keys)
    FileUtils.mkdir_p File.dirname(path)
    File.open(path, "w") do |file|
      file.puts keys_to_yaml(Translate::File.deep_stringify_keys(keys))
    end    
  end
  
  def read
    File.exists?(path) ? YAML::load(IO.read(path)) : {}
  end

  # Stringifying keys for prettier YAML
  def self.deep_stringify_keys(hash)
    hash.inject({}) { |result, (key, value)|
      value = deep_stringify_keys(value) if value.is_a? Hash
      result[(key.to_s rescue key) || key] = value
      result
    }
  end
  
  private
  def keys_to_yaml(keys)
    # Using ya2yaml, if available, for UTF8 support
    keys.respond_to?(:ya2yaml) ? keys.ya2yaml(:escape_as_utf8 => true) : keys.to_yaml
  end    
end
