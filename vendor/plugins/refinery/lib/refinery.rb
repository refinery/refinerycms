module Refinery

  class << self
    attr_accessor :root
    def root
      @root ||= Pathname.new(File.dirname(__FILE__).split("vendor").first.to_s)
    end
    attr_accessor :is_a_gem
  end

end
