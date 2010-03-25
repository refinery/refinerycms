# Author: Stephen Sykes
begin
  unless File.exists?(File.join(File.dirname(__FILE__), "../", "ext", "Makefile"))
    Dir.chdir(File.join(File.dirname(__FILE__), "../", "ext"))
    `rake`
  end
rescue Exception
end

begin; require 'callsite_hash'; rescue LoadError; end
require 'slim_scrooge/simple_set'
require 'slim_scrooge/callsites'
require 'slim_scrooge/callsite'
require 'slim_scrooge/result_set'
require 'slim_scrooge/monitored_hash'
require 'slim_scrooge/slim_scrooge'
