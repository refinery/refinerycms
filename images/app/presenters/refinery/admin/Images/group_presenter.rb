module Refinery
  module Admin
    module Images
      class GroupPresenter < Refinery::BasePresenter
        include ActionView::Helpers::TagHelper

        attr_accessor :context, :collection, :pagination_class, :layout
        delegate :output_buffer, :output_buffer=, :t, to: :context
        delegate :group_by_date, to: :collection


        def initialize(collection, layout, context)
          @collection = collection.map { |image| Refinery::Admin::Images::ImagePresenter.new(image, context) }
          @layout = layout
          @context = context
          @pagination_class = context.pagination_css_class
        end

        def to_html
          tag.ul id: "image_#{layout}", class: ['clearfix', 'pagination_frame', pagination_class] do
            yield
          end
        end

        def list_by_date
          buffer = ActiveSupport::SafeBuffer.new
          context.group_by_date(collection).each do |container|
            date_time = (image_group = container.last).first.created_at
            date_header = tag.h3 ::I18n.l(Date.parse(date_time.to_s), format: :long)
            group = list_view(image_group)
            buffer << [date_header, group].join(' ').html_safe
          end
          buffer
        end

        def list_view(group)
          group.each.reduce(ActiveSupport::SafeBuffer.new) do |buffer, image|
            buffer << image.to_html(:list)
          end
        end

        def grid_view
          collection.each.reduce(ActiveSupport::SafeBuffer.new) do |buffer, image|
            buffer << image.to_html(:grid)
          end
        end

      end
    end
  end
end
