module Refinery
  class Activity
    attr_accessor :conditions

    # Image asset to use to represent newly created instances of the class this activity
    # represents
    attr_accessor :created_image

    # Total number of activies to show for a given class of activity
    attr_accessor :limit

    # Other objects, like parents, to include in the nesting structure
    attr_accessor :nested_with

    # SQL order by string to specify how to order the activities in the activity feed for
    # the given activities class
    attr_accessor :order

    # The title to be displayed for each item of this activity
    attr_accessor :title

    # Image asset to use to represent updated instance of the class thisa activity represents
    attr_accessor :updated_image

    # Boolean; whether or not to use the record itself when constructing the nesting
    # Default true
    attr_accessor :use_record_in_nesting

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
    #  for the nested_with option, pass in the reverse order of ancestry
    #  e.g. [parent.parent_of_parent, parent]
    def initialize(options = {})
      {
        :class_name => nil,
        :conditions => nil,
        :created_image => "add.png",
        :limit => 7,
        :nested_with => [],
        :order => "updated_at DESC",
        :title => "title",
        :updated_image => "edit.png",
        :url => nil,
        :url_prefix => "edit",
        :use_record_in_nesting => true
      }.merge(options).each { |key, value| self.send(:"#{key}=", value) }
    end

    # Returns a string representation of the Class name of the object which this instance is recording
    attr_reader :class_name

    # Sets the class_name instance variable. Takes one parameter which must be a Class Constant, String, or Symbol.
    #
    # Example:
    #   activity.class_name = :'refinery/image'
    #   activity.class_name = "Refinery::Image"
    #   activity.class_name = Refinery::Image
    def class_name=(value)
      @class_name = value.to_s.camelize
    end

    # Returns a string containing the base class name (everything to the right of the last :: in the class definition)
    # of the Class this instance is recording
    #
    # Example:
    #   Given: Activity.new(:class_name => "Refinery::Image")
    #
    #   activity.base_class_name => "Image"
    def base_class_name
      self.klass.name.demodulize
    end

    # Returns the Class Constant for the Class which this instance is recording
    #
    # Example:
    #   activity.klass => Refinery::Image
    def klass
      self.class_name.constantize
    end

    # to use in a URL like edit_refinery_admin_group_individuals_path(record.group, record)
    # which will help you if you're using nested routes.
    def nesting(record_string = "record")
      @nesting ||= begin
        chain = self.nested_with.inject([]) { |nest_chain, nesting|
          nest_chain << "#{record_string}.#{nesting}"
        }
        chain << record_string if self.use_record_in_nesting
        chain.join(',')
      end
    end

    attr_writer :url_prefix

    def url_prefix
      "#{"#{@url_prefix}_".gsub("__", "_") if @url_prefix.present?}"
    end

    attr_writer :url

    def url
      @url ||= "refinery.#{url_prefix}#{Refinery.route_for_model(klass)}"
    end
  end
end
