module Refinery
  module Admin

    # Refinery::Admin::GridPresenter is a class intended for presenting
    # grouped records in a grid format within the Refinery CMS admin interface.
    #
    # It inherits from Refinery::Admin::GroupPresenter and overrides specific
    # properties to provide custom behavior suitable for grid presentations.
    #
    # The primary features provided by this class include:
    # - Custom grouping of records based on predefined logic.
    # - Control over headers, identity keys, and displayed content organization.
    #
    # == Inclusions
    # This class includes the following modules to extend functionality:
    # - Refinery::Admin::ImagesHelper: Provides helper methods for working with images.
    # - ActionView::Helpers::TagHelper: Supplies methods for creating HTML tags.
    #
    # == Attributes
    # - @group_headers: Controls whether headers for each record group are displayed. Defaults to `false`.
    # - @identity_keys: Represents the keys used to identify and present record attributes, including thumbnail, title, and alt text attributes.
    # - @header: Stores header configurations, initialized as `nil`.
    # - @groups: A lambda function designed to group records by associating them with the current date.
    #
    # == Initialization
    # When initialized, `GridPresenter` accepts an execution `context` (e.g., a controller, view, etc.)
    # and propagates this context to the superclass.
    class GridPresenter < GroupPresenter
      include Refinery::Admin::ImagesHelper
      include ActionView::Helpers::TagHelper

      def initialize(context)
        super(context)
        @group_headers = false
        @identity_keys = [:thumbnail, :title, :alt]
        @header  = nil
        @groups = ->(records) { [[Date.today, records]] }
      end

    end
  end
end
