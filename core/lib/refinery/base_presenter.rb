class Refinery::BasePresenter

  DEFAULT_FIELDS = {
    :title              => Proc.new { |p| p.model.present? ? p.model.class.name.titleize : nil },
    :path               => Proc.new { |p| p.title },
    :browser_title      => nil,
    :meta_description   => nil,
    :meta_keywords      => nil
  }

  attr_reader :model

  def initialize(obj)
    @model = obj
  end

  def method_missing(method, *args)
    if @model.respond_to? method
      @model.send method
    elsif DEFAULT_FIELDS.has_key? method
      (value = DEFAULT_FIELDS[method]).is_a?(Proc) ? value.call(self) : value
    else
      raise NoMethodError.new("#{self.class.name} doesn't know #{method}. Define or delegate it.", method)
    end
  end

end
