module Refinery
  module Admin

    # Refinery::Admin::GroupPresenter
    #
    # This class represents a presenter for organizing and displaying
    # groups with associated metadata in a structured format.
    #
    # The presenter utilizes several helper modules for enhanced
    # functionality and template rendering support.
    #
    # == Includes:
    # * `Refinery::Admin::ImagesHelper` - Provides image-related functionality.
    # * `ActionView::Helpers::TagHelper` - Used to create HTML-like tags dynamically.
    #
    # == Attributes:
    # * `context` [Object] - Represents the context within which the presenter operates.
    # * `groups` [Object] - Holds a collection of groups to be managed.
    # * `group_classes` [Array] - Provides a list of CSS class names applied to the group tag.
    # * `group_header` [Proc] - Callable object (e.g., lambda) to determine the header for each group.
    # * `group_headers` [Boolean] - Controls whether group headers are displayed.
    # * `group_tag` [Symbol] - Defines the tag used to wrap groups, e.g., `:ul`.
    # * `group_wrapper` [Proc] - Customizable wrapper for rendering group collections.
    # * `header` [Proc] - Callable object to format the header for individual groups.
    # * `header_tag` [Symbol] - Specifies the tag for rendering headers, e.g., `:h3`.
    # * `identity_keys` [Object] - Additional attribute for handling unique identity keys.
    #
    # == Public Instance Methods:
    # - `initialize(context)`
    #   Initializes a new instance of the presenter within a given context,
    #   setting default values for various attributes like headers and tags.
    #
    # - `group_wrapper(&block)`
    #   Wraps the rendering of groups using a specified tag.
    #   This is customizable via the `group_tag` and `group_classes` attributes.
    #   A block must be passed to render the inner contents.
    #
    # - `group_header(date)`
    #   Constructs a header for individual groups based on a provided date.
    #   The format of the header is defined by the `header` callable and
    #   displayed using the specified `header_tag`.
    class GroupPresenter
      include Refinery::Admin::ImagesHelper
      include ActionView::Helpers::TagHelper

      attr_accessor  :context, :groups, :group_classes, :group_header, :group_headers, :group_tag, :group_wrapper,
                     :header, :header_tag, :identity_keys

      def initialize(context)
        @context = context
        @group_headers = true
        @group_tag = :ul
        @group_classes = [:image_group]
        @header_tag = :h3
      end

      def group_wrapper(&block)
        context.tag group_tag, class: group_classes do
          yield block
        end
      end

      def group_header(date)
        tag.send(header_tag, header.call(date), class: :group_header)
      end
    end
  end
end
