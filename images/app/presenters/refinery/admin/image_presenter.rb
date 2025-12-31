module Refinery
  module Admin

    # Refinery::Admin::ImagePresenter
    #
    # This class represents a presenter for managing and displaying image data
    # in the Refinery admin interface. It provides methods to format image-related
    # data for display and to generate necessary HTML components for interacting
    # with images in the admin UI.
    #
    # === Includes
    # - ActionView::RecordIdentifier: Provides methods for DOM ID generation for records.
    # - ActionView::Helpers::UrlHelper: Allows generation of URLs and links.
    # - ActionView::Helpers::TagHelper: Provides methods for generating HTML tags.
    # - ActionView::Context: Allows rendering within the correct context.
    # - Refinery::TranslationHelper: Adds support for translation-related helper methods.
    # - Refinery::Admin::ImagesHelper: Includes specific helper methods for working with images.
    # - Refinery::ActionHelper: Provides additional action-based helper methods.
    #
    # === Attributes
    # - `image` [Reader]: The image object being presented.
    # - `context` [Reader]: Context of the current view, often required for generating paths and URLs.
    # - `index_keys` [Reader]: Used to specify the attributes displayed in the index table for images.
    # - `i18n_scope` [Reader]: Specifies the internationalization scope for localization of text.
    # - `title` [Writer]: Sets the title for the image.
    # - `alt` [Writer]: Sets the alt text for the image.
    # - `filename` [Writer]: Sets the filename for the image.
    # - `translations` [Writer]: Stores translations for the image fields.
    # - `edit_attributes` [Writer]: Stores attributes to be used for editing the image.
    # - `delete_attributes` [Writer]: Stores attributes to be used for deleting the image.
    # - `preview_attributes` [Writer]: Stores attributes for image preview options.
    #
    # === Constants
    # - `IndexEntry`: Defines a structure to hold index entry data, including the image ID,
    #   edit link, text elements, locales, and actionable items.
    #
    # === Instance Methods
    #
    # - `initialize(image, context, scope = nil)`:
    #   Constructor that initializes the ImagePresenter with the given image object, view context,
    #   and optional internationalization scope.
    #
    # - `index_entry(index_keys)`:
    #   Generates an index entry for the image, including its ID, edit link, text elements,
    #   and actions. Accepts an array of keys for specifying index fields.
    #   These keys differ between the grid_view and list_view, and other views could be added
    #
    # - `link_to_edit(edit_key)`:
    #   Creates a link to edit the image, using the given key for determining the "text" of the link.
    #
    # - `text_elements(keys)`:
    #   Generates text  elements for display based on the provided keys, wrapping them in HTML spans.
    #
    # - `thumbnail`:
    #   Returns the thumbnail for the image, including specific attributes such as its
    #   URL, description (alt) and title
    class ImagePresenter < Refinery::BasePresenter
      include ActionView::RecordIdentifier
      include ActionView::Helpers::UrlHelper
      include ActionView::Helpers::TagHelper
      include ActionView::Context

      include Refinery::TranslationHelper
      include Refinery::Admin::ImagesHelper
      include Refinery::ActionHelper

      attr_reader :image, :context, :index_keys, :i18n_scope
      attr_writer :title, :alt, :filename, :translations, :edit_attributes, :delete_attributes, :preview_attributes
      delegate_missing_to :image
      delegate :t, to: :context

      IndexEntry = Struct.new('ImageEntry', :id, :edit_link, :text_elements, :locales, :actions)

      def initialize(image, context, scope = nil)
        super(image)
        @image = image
        @context = context
        @i18n_scope = scope || 'refinery.admin.images'
      end

      def index_entry(index_keys)
        edit_key, *text_keys = index_keys
        IndexEntry.new(
          id: image.id,
          edit_link: link_to_edit(index_keys[0]),
          text_elements: text_elements(index_keys[1..]),
          actions: tag.span( image_actions, class: :actions)
        )
      end

      def link_to_edit(edit_key)
        link_to(self.send(edit_key),
                context.edit_admin_image_path(image),
                { title: ::I18n.t('.edit', title: image.title, scope: i18n_scope), class: :edit_link})
      end

      def text_elements(keys)
        keys.reduce(ActiveSupport::SafeBuffer.new) do |buffer, key|
          buffer << tag.span(self.send(key), title: ::I18n.t(key, scope: i18n_scope), class: key)
        end
      end

      def thumbnail
        tag.img src: image.thumbnail(geometry: Refinery::Images.admin_image_sizes[:grid], strip: true).url(only_path: true),
                alt: image.alt, title: image.title, class: :thumbnail
      end

      def title
        translated_field(image, :title)
      end

      def alt
        alt_text = translated_field(@image, :alt)
        alt_text unless alt_text === translated_field(image, :title)
      end

      def filename
        image.image_name
      end

      def image_actions
        [*edit_actions, delete_action, preview_action].reduce(ActiveSupport::SafeBuffer.new) do |buffer, action|
          buffer << action
        end
      end

      def edit_actions
        translated_locales = locales_with_translated_field(image, :image_title)
        edit_in_locales(context.edit_admin_image_path(image), translated_locales)
      end

      def preview_action(options = {})
        action_icon(:preview, image.url, ::I18n.t('.view_live_html', scope: i18n_scope),
                    options: options)
      end

      def delete_action(options = {})
        action_icon(:delete, context.admin_image_path(image),
                    ::I18n.t('.delete', scope: i18n_scope),
                    data: { confirm: ::I18n.t('message', scope: 'refinery.admin.delete', title: image.title) },
                    **options )
      end
    end
  end
end
