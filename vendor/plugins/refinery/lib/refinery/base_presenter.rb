class BasePresenter
  DEFAULT_FIELDS = {
    :custom_title_type => 'none',
    :title             => Proc.new { |p| p.model.class.name.titleize },
    :path              => Proc.new { |p| p.title },
    :browser_title     => nil,
    :meta_description  => nil,
    :meta_keywords     => nil
  }

  attr_reader :model

  def initialize(obj)
    @model = obj
  end

  def method_missing(method, *args)
    if DEFAULT_FIELDS.has_key? method
      value = DEFAULT_FIELDS[method]
      return value.is_a?(Proc) ? value.call(self) : value
    else
      msg = "#{self.class.name} doesn't know #{method}. Define or delegate it."
      raise NoMethodError.new(msg, method)
    end
  end
end
