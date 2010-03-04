require 'active_support/string_inquirer'
require 'active_support/deprecation'

# Set up deprecation warnings:
Refinery.s3_backend = USE_S3_BACKEND if defined?(USE_S3_BACKEND) # map it before we deprecate it incase it's already in use
USE_S3_BACKEND = (Class.new(ActiveSupport::Deprecation::DeprecationProxy) do
  cattr_accessor :warned
  self.warned = false

  def target(*args)
    Refinery.s3_backend
  end

  def replace(*args)
    warn(caller, :replace, *args)
  end

  def warn(callstack, called, args)
    unless self.warned
      puts (msg = "USE_S3_BACKEND is deprecated! Use Refinery.s3_backend instead")
      ActiveSupport::Deprecation.warn(msg, callstack)
      self.warned = true
    end
  end
end).new

REFINERY_ROOT = (Class.new(ActiveSupport::Deprecation::DeprecationProxy) do
  cattr_accessor :warned
  self.warned = false

  def target
    Refinery.root
  end

  def replace(*args)
    warn(caller, :replace, *args)
  end

  def warn(callstack, called, args)
    unless warned
      puts (msg = "REFINERY_ROOT is deprecated! Use Refinery.root instead")
      ActiveSupport::Deprecation.warn(msg, callstack)
      self.warned = true
    end
  end
end).new
