module Refinery
  class Activity

    attr_accessor :class, :conditions, :created_image, :limit, :nested_with, :order, :title, :updated_image, :url, :url_prefix

    # for nested_with, pass in the reverse order of ancestry e.g. [parent.parent_of_parent, parent]
    def initialize(options={})
      {
        :class => nil,
        :conditions => nil,
        :created_image => "add.png",
        :limit => 7,
        :nested_with => [],
        :order => "updated_at DESC",
        :title => "title",
        :updated_image => "edit.png",
        :url => nil,
        :url_prefix => "edit"
      }.merge(options).each { |key,value| self.instance_variable_set(:"@#{key}", value) }
    end

    # to use in a URL like edit_admin_group_individuals_url(record.group, record)
    # which will help you if you're using nested routed.
    def nesting(record_string="record")
      self.nested_with.inject("") { |nest_chain, nesting| nest_chain << "#{record_string}.#{nesting}," }
    end

    def url_prefix
      "#{"#{@url_prefix}_".gsub("__", "_") if @url_prefix.present?}"
    end

    def url
      "#{self.url_prefix}#{@url ||= "admin_#{self.class.name.underscore.downcase}_url"}"
    end

  end
end
