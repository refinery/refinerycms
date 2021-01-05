require 'action_view/helpers/tag_helper'
require 'action_view/helpers/url_helper'

module Refinery
  module Admin
    module Images
      class ImagePresenter < Refinery::BasePresenter
        include ActionView::Helpers::TagHelper
        include ActionView::Helpers::UrlHelper
        include Refinery::ImageHelper
        include Refinery::TagHelper
        include Refinery::TranslationHelper

        attr_accessor :image, :created_at, :context, :collection
        delegate :refinery, :params, :output_buffer, :output_buffer=, :t, to: :context
        delegate_missing_to :image

        def initialize(image, context)
          @context = context
          @image = image
          @created_at = image.created_at
        end

        def to_html(view)
          link = case view
            when :grid
              image_for_grid.html_safe
            when :list
              image_for_list.html_safe
            else
              image_for_list.html_safe
          end

          translations = image_translation_links
          actions = tag.div class: :actions do
            [preview_icon, edit_icon, delete_icon, info_icon  ].join(' ').html_safe
          end

          tag.li id: "image_#{image.id}" do
            [link, *translations, *actions].join(' ').html_safe
          end
        end

        def edit_link(&block)
          link_to refinery.edit_admin_image_path(image), class: [:title, :edit], title: 'Click to edit' do
            block.call
          end
        end

        def image_for_list
          [edit_link { image.title }, tag.span( image.image_name, class: :preview)].join(' ').html_safe
        end

        def image_for_grid
          edit_link { image_fu image, '149x149#c', title: image.title }
        end

        # Actions
        def preview_icon
          action_icon :preview, image.url, t('view_live_html', scope: 'refinery.admin.images')
        end

        def edit_icon
          action_icon :edit, refinery.edit_admin_image_path(image), t('edit', scope: 'refinery.admin.images')
        end

        def delete_icon
          action_icon :delete, refinery.admin_image_path(image, params.to_unsafe_h.slice(:page)), t('delete', scope: 'refinery.admin.images'), class: 'confirm-delete',
                      data: { confirm: t('message', scope: 'refinery.admin.delete', title: image.title) }
        end

        def info_icon
          action_icon :info, "#", "Title: #{image.title} Alt text: #{image.alt}"
        end

        def image_translation_links
          return unless Refinery::I18n.frontend_locales.many?
          tag.span class: :locales do
            image_translations.each do |translation|
              link_to translation[:link], class: 'locale', title: translation[:locale] do
                tag.span locale_text_icon(translation[:locale]), class: [translation[:locale], :locale_marker]
              end
            end
          end
        end

        def image_translations
          image.translations
               .sort_by { |t| Refinery::I18n.frontend_locales.index(t.locale) }
               .filter { |loc| loc.image_title.present? }
               .map { |tx| image_translation(tx) }
        end

        def image_translation(locale)
          {
            link: refinery.edit_admin_image_path(image, switch_locale: locale),
            locale: locale.upcase
          }
        end

        def image_fu(image, geometry = nil, options = {})
          return nil if image.blank?

          thumbnail_args = options.slice(:strip)
          thumbnail_args[:geometry] = geometry if geometry

          image_geometry = (image.thumbnail_dimensions(geometry) rescue {})
          image_alt = image.respond_to?(:title) ? image.title : image.image_name

          tag.img src: image.thumbnail(thumbnail_args).url,
                  width: image_geometry[:width],
                  height: image_geometry[:height],
                  alt: image_alt,
                  title: "Click to edit"
        end
      end

    end
  end
end


