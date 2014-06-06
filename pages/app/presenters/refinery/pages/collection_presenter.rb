module Refinery
  module Pages
    class CollectionPresenter < Refinery::Pages::SectionPresenter
      include ActiveSupport::Configurable
      # presents a collection of items in a section
      # TODO do a better fallback_html
      # presents a collection of items in a section

      attr_accessor :output_buffer
      config_accessor :id, :content_wrapper_id, :content_wrapper_tag, :collection_class, :collection_tag

      self.content_wrapper_tag = :section
      self.collection_tag = :ul

      def initialize(page_part)
        super(page_part[:options]) unless page_part[:options].nil?
        @collection = page_part[:data]
        self.fallback_html = ""
        self.id = page_part[:id]
        self.collection_class = page_part[:id]
      end

      def has_content?(can_use_fallback = true)
        !@collection.nil?
      end

      private

      def wrap_content_in_tag(content)
        content_tag(content_wrapper_tag.to_sym, content,  id: id)
      end

      def content_html(can_use_fallback)
        if override_html.present?
          override_html
        else
          collection_markup()
        end
      end

      def collection_markup()

        content_tag(collection_tag.to_sym, class: collection_class ) do
          @collection.each.inject(ActiveSupport::SafeBuffer.new) do |buffer, item|
            buffer << item_markup(item)
          end
        end
      end

      def item_markup(item)
        content_tag(:li, item.to_s)
      end

      def html_from_fallback(can_use_fallback)
        fallback_html if fallback_html.present? && can_use_fallback
      end

    end
  end
end
