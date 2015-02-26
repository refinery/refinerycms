module Refinery
  module TagHelper

    # Remember to wrap your block with <span class='label_with_help'></span> if you're using a label next to the help tag.
    def refinery_help_tag(title='Tip')
      action_icon(:info, '#', title.html_safe? ? title : h(title), {tooltip: title})
    end

    # This is just a quick wrapper to render an image tag that lives inside refinery/icons.
    # They are all 16x16 so this is the default but is able to be overriden with supplied options.
    def refinery_icon_tag(filename, options = {})
      filename = "#{filename}.png" unless filename.split('.').many?
      image_tag "refinery/icons/#{filename}", {:width => 16, :height => 16}.merge(options)
    end

    def action_icon(action, url, title, options={})
      action_icon_label(action, url, title, options, false)
    end

    def action_label(action, url, title, options={})
      action_icon_label(action, url, title, options, true)
    end

    def action_icon_label(action, url, title, options={}, label = true)
#   See icons.scss for defined icons/classes
      options[:title] = title
      options[:class].presence ? options[:class] << " #{action}_icon" : options[:class] = " #{action}_icon"

      case action
      when :preview
        options[:target] = '_blank'
      when :delete
        options[:method] = :delete
        options[:class] << ' cancel confirm-delete'
      when :reorder_done
        options[:class] << ' hidden'
      end
      link_to(label && title || '', url, options)
    end

    # this stacks the text onto the locale icon (actually a comment balloon)
    def locale_text_icon(text)
      content_tag(:span, class: 'fa-stack') do
        content_tag(:i, '', class: 'fa fa-comment') << content_tag(:strong, text)
      end
    end

  end
end
