module Refinery
  module Admin
    class ListPresenter < GroupPresenter
      include Refinery::Admin::ImagesHelper
      include ActionView::Helpers::TagHelper

      # Initialize the presenter with a context, a lambda for headers, and a lambda for groups.
      #
      # @param context [Object] An object that provides the necessary methods for grouping and rendering.
      # @param header [Proc] Callable for formatting group headers.
      # @param groups [Proc] Callable for grouping records.
      def initialize(context,
                     header: ->(date) { localized(date) },
                     groups: ->(records) { context.group_by_date(records, :updated_at) })
        super(context)
        @identity_keys = [:title, :filename, :alt]
        @group_headers = true
        @header = header
        @groups = groups
      end
    end
  end
end
