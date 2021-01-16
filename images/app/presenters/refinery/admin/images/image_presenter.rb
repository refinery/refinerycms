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

        attr_accessor :image, :created_at, :context, :urls
        delegate :refinery, :params, :output_buffer, :output_buffer=, :t, to: :context
        delegate_missing_to :image

        def initialize(image, view_format, context)
          @context = context
          @created_at = image.created_at
          @image = image
          @urls = {
            edit: refinery.edit_admin_image_path(image),
            delete: refinery.admin_image_path(image),
            preview: image.url
          }
          @view = view_format
        end

        def to_html(stripe=true )
          stripe_class = stripe ? 'on' : 'on-hover'
          tag.li id: "image_#{image.id}", class: stripe_class do
            entry = tag.span class: :item do
              [yield, *translations, image_settings].join.html_safe
            end
            entry << actions
          end
        end

        def list_entry
          edit_link { image.title}
        end

        def grid_entry
          edit_link { context.image_fu image, '149x149#c', title: image_title, alt: image.alt }
        end

        private

        def edit_link
          link_to urls[:edit], class: [:edit, :title],
                               tooltip: t('edit', scope: 'refinery.admin.images', title: image_title) do
            yield
          end
        end

        def image_settings
          tag.span class: [:preview] do
            image_information
          end
        end

        def actions
          tag.span class: :actions do
            [edit_icon, info_icon, delete_icon, preview_icon].join(' ').html_safe
          end
        end

          # Actions
        def preview_icon
          action_icon :preview, urls[:preview], t('view_live_html', scope: 'refinery.admin.images')
        end

        def edit_icon
          action_icon :edit, urls[:edit], t('edit', scope: 'refinery.admin.images', title: image_title)
        end

        def delete_icon
          delete_options = {
            class: %w[cancel confirm-delete],
            data: { confirm: ::I18n.t('message', scope: 'refinery.admin.delete', title: image_title) }
          }
          action_icon :delete, urls[:delete], t('delete', scope: 'refinery.admin.images'), delete_options
        end

        def info_icon
          action_icon :info, '', image_information
        end

        def image_information
          # give as much info as we have, but without duplication
          # title, alt and filename may all be different, or any two may be the same. Only show what is different
          # Title is already shown in the edit_link
          #
          filename = image.image_name.split('.').first

          settings  = ["Title: #{title}"]
          settings << "File: #{filename}" unless filename == title
          settings << "Alt: #{image_alt}" unless image_alt.nil? || image_alt == filename || image_alt == title
          settings << "Type: #{image.image.mime_type}"
          settings << "Size: #{context.number_to_human_size(image.size)}"
          settings.join(', ').html_safe
        end

        def translations
          if Refinery::I18n.frontend_locales.many?
            tag.span class: :locales do
              switch_locale(image, urls[:edit], :image_title).html_safe
            end
          end
        end

      end
    end
  end
end

