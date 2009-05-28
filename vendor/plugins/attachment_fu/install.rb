require 'fileutils'

s3_config = File.dirname(__FILE__) + '/../../../config/amazon_s3.yml'
FileUtils.cp File.dirname(__FILE__) + '/amazon_s3.yml.tpl', s3_config unless File.exist?(s3_config)
cloudfiles_config = File.dirname(__FILE__) + '/../../../config/rackspace_cloudfiles.yml'
FileUtils.cp File.dirname(__FILE__) + '/rackspace_cloudfiles.yml.tpl', cloudfiles_config unless File.exist?(cloudfiles_config)
puts IO.read(File.join(File.dirname(__FILE__), 'README'))