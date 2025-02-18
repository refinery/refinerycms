module Refinery
  module ActionHelper
    def i18n_scope
      'refinery.index.locale_picker'
    end

    # returns a link to the requested url, with the requested icon as content
    def action_icon(action, url, title, options={})
      action_icon_label(action, url, title, options, false)
    end

    # returns a link to the requested url, with  icon and label as content
    def action_label(action, url, title, options={})
      action_icon_label(action, url, title, options, true)
    end

    # See icons.scss for defined icons/classes
    def action_icon_label(action, url, title, options={}, label = true)
      options[:title] = title
      action_classes = ["#{action}_icon", action]

      case action
      when :preview
        options[:target] = '_blank'
      when :delete
        options[:method] = 'delete'
      when :reorder_done
        action_classes.push 'hidden'
      end

      options[:class] = [options[:class], *action_classes].compact.join(' ')
      link_to(label && title || '', url, **options)
    end


    def edit_in_current_locale(url:, title:, **options)
      action_icon(:edit, url, title, class: :edit,  **options  )
    end

    def edit_in_locale(locale, url:, title:, **options)
      if options.delete(:label)
        title = language(locale)
        action_label(:locale, "#{url}?switch_locale=#{locale}", title, **options,
                    id: locale, class: :edit, **options
        )
      else
        title = ::I18n.t('.edit_in_language', language: locale_language(locale), scope: 'refinery.admin.locale_picker')
        action_icon(:locale, "#{url}?switch_locale=#{locale}", title,
                    id: locale, class: :edit, **options
        )
      end
    end


    def edit_in_locales(edit_url, locales=[])
      return if locales.empty?

      edit_links = locales.map do |locale|
        edit_in_locale(locale, url: edit_url, title: t('.edit_in_locale', locale: locale) )
      end
      tag.span edit_links.compact.join(' ').html_safe, class: :locales
    end
  end
end
