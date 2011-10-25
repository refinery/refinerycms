module Refinery
  class Activity

    # Constant representing the class which this instance of activity is recording
    attr_accessor :class
    
    attr_accessor :conditions
    
    # Image asset to use to represent newly created instances of the class this activity
    # represents
    attr_accessor :created_image
    
    # Total number of activies to show for a given class of activity
    attr_accessor :limit
    
    attr_accessor :nested_with
    
    # SQL order by string to specify how to order the activities in the activity feed for
    # the given activities class
    attr_accessor :order
    
    # The title to be displayed for each item of this activity
    attr_accessor :title
    
    # Image asset to use to represent updated instance of the class thisa activity represents
    attr_accessor :updated_image
    
    attr_accessor :url
    attr_accessor :url_prefix

    # Creates a new instance of Activity for a registered Refinery Plugin. An optional
    # hash of options can be specified to customize the values of each attribute
    # accessor defined on this class. Each key specified in the options hash should be a
    # symbol representation of the accessor name you wish to customize the value for.
    # 
    # Example:
    #   To override the limit and title of the activity:
    #   Activity.new(:limit => 10, :title => "Newest Activity!")
    #
    # Warning:
    #  for the nested_with option, pass in the reverse order of ancestry e.g. [parent.parent_of_parent, parent]
    def initialize(options = {})
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
      }.merge(options).each { |key,value| self.send(:"#{key}=", value) }
    end

    # to use in a URL like edit_refinery_admin_group_individuals_path(record.group, record)
    # which will help you if you're using nested routed.
    def nesting(record_string="record")
      self.nested_with.inject("") { |nest_chain, nesting| nest_chain << "#{record_string}.#{nesting}," }
    end

    def url_prefix
      "#{"#{@url_prefix}_".gsub("__", "_") if @url_prefix.present?}"
    end

    def base_class_name
      self.class.name.demodulize
    end

    def url
      "#{self.url_prefix}#{@url ||= "refinery_admin_#{self.base_class_name.underscore}_path"}"
    end

    def class
      if @class.kind_of?(Class)
        @class
      else
        Object.const_get(@class.to_sym)
      end
    end

  end
end
