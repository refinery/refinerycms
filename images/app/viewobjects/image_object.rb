class ImageObject
  include Refinery::TranslationHelper
  include Refinery::ImageHelper

  attr_reader :image, :context, :i18n_scope
  attr_writer :title, :alt, :filename, :translations, :edit_attributes, :delete_attributes, :preview_attributes
  delegate_missing_to :image

  Action = Struct.new('Action', :href, :title, :text, :data, :options, keyword_init: true)

  def initialize(image, context, scope=nil)
    @image = image
    @context = context
    @i18n_scope = scope || 'refinery.admin.images'
  end

  def title
    translated_field(image, :title)
  end

  def alt
    translated_field(image, :alt)
  end

  def img_element
    image_fu image, '149x149#c', title: ::I18n.t('edit_title', scope: i18n_scope, title: image.image_title || image.image_alt)
  end

  def filename
    image.image_name
  end
  def locales_with_titles
    image.translations
         .reject { |i| i.image_title.blank? }
         .map(&:locale).sort_by { |t| Refinery::I18n.frontend_locales.index(t.to_sym) }
  end

  def edit_action(options = {})
    Action.new(href: context.edit_admin_image_path(image, switch_locale: options.delete(:switch_locale)),
               title:  I18n.t('.edit', scope: i18n_scope),
               text: I18n.t('.edit_title', title: image.title, scope: i18n_scope),
               options: options)
  end

  def preview_action(options = {})
    Action.new(href: image.url, title: I18n.t('.view_live_html', scope: i18n_scope), options: options)
  end

  def delete_action(options = {})
    Action.new(href: context.admin_image_path(image),
               title: I18n.t('.delete', scope: i18n_scope),
               data:{ confirm: I18n.t('message', scope: 'refinery.admin.delete', title: image.title) },
               options: { class: [:delete, 'confirm-delete'], **options })
  end

end
