module Refinery
  module Admin
    module Images
      class CollectionPresenter < Refinery::BasePresenter
        include ActionView::Helpers::TagHelper
        include Refinery::PaginationHelper

        attr_accessor :context, :collection, :layout, :pagination_class
        delegate :group_by_date, :output_buffer, :output_buffer=, :params, :request, :t, to: :context

        def initialize(collection, view_format, context)
          @collection = collection.map { |image| Refinery::Admin::Images::ImagePresenter.new(image, view_format, context) }
          @context = context
          @collection_id = "image_#{view_format}"
          @view_format = "#{view_format}_view"
          @pagination_class = context.pagination_css_class
        end

        def to_html
          tag.ul id: @collection_id, class: ['clearfix', 'pagination_frame', pagination_class] do
            self.send(@view_format)
          end
        end

        def grid_view
          collection.each.reduce(ActiveSupport::SafeBuffer.new) do |buffer, image|
            buffer << image.to_html { image.grid_entry }
          end
        end

        def list_view
          group_by_date(collection)
            .each
            .reduce(ActiveSupport::SafeBuffer.new) do |groups_buffer, (_container, image_group)|
              date_time = image_group.first.created_at
              date_header = tag.h3 context.l(Date.parse(date_time.to_s), format: :long)
              # darn zebra striping
              images = image_group.each_with_index.reduce(ActiveSupport::SafeBuffer.new) do |items_buffer, (image, index)|
                items_buffer << image.to_html(index.odd?) { image.list_entry }
              end
              groups_buffer << [date_header, images].join(' ').html_safe
            end
        end

        private

        def view_classes
          ['clearfix', 'pagination_frame', 'images_list', pagination_css_class]
        end
      end
    end
  end
end
