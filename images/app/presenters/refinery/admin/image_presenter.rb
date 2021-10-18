require 'action_view/helpers/tag_helper'
require 'action_view/helpers/url_helper'

module Refinery
  module Admin
    class ImagePresenter < Refinery::BasePresenter
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::UrlHelper
      include Refinery::ImageHelper
      include Refinery::TagHelper
      include Refinery::TranslationHelper

      attr_accessor :image, :created_at, :context, :urls
      delegate :refinery, :params, :output_buffer, :output_buffer=, :t, to: :context
      delegate_missing_to :image

      def initialize(image, context)
        @context = context
        @created_at = image.created_at
        @image = image
        @urls = {
          edit: refinery.edit_admin_image_path(image),
          delete: refinery.admin_image_path(image),
          preview: image.url
        }
      end

      class << self
        attr_accessor :context, :images, :view, :pagination_class
        delegate :tag, :group_by_date, to: :context

        def collection(images, view_format, context)
          @view = "#{view_format}_view"
          @context = context
          @pagination_class = context.pagination_css_class
          @collection_id = "image_#{view_format}"
          @images = images.map { |image| self.new(image, context) }
          self
        end

        def to_html
          tag.ul id: @collection_id, class: ['clearfix', 'pagination_frame', pagination_class] do
            self.send(@view)
          end
        end

        def grid_view
          images.each.reduce(ActiveSupport::SafeBuffer.new) do |buffer, image|
            buffer << image.to_html { image.grid_entry }
          end
        end

        def list_view
          group_by_date(images)
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

        def view_classes
          ['clearfix', 'pagination_frame', 'images_list', pagination_class]
        end
      end

      def to_html(stripe = true)
        stripe_class = stripe ? 'on-hover' : 'on'
        tag.li id: "image_#{image.id}", class: stripe_class do
          entry = tag.span class: :item do
            [yield, *translations, image_settings].join.html_safe
          end
          entry << actions
        end
      end

      def list_entry
        edit_link { image.title }
      end

      def grid_entry
        edit_link { context.image_fu image, '149x149#c', title: image_title, alt: image.alt }
      end

      private

        def edit_link
          link_to urls[:edit], class: [:edit, :title],
                  tooltip: t('edit', scope: 'refinery.admin.images') do
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

          settings = ["Title: #{title}"]
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


