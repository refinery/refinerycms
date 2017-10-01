module Refinery
  module TagHelper

    # Returns <img class='help' tooltip='Your Input' src='refinery/icons/information.png' />

    # Remember to wrap your block with <span class='label_with_help'></span> if you're using a label next to the help tag.
    def refinery_help_tag(title='Tip')
      title = title.html_safe? ? title : h(title)
      action_icon(:info, '#', title, {tooltip: title})
    end

    # This is just a quick wrapper to render an image tag that lives inside refinery/icons.
    # They are all 16x16 so this is the default but is able to be overriden with supplied options.
    def refinery_icon_tag(filename, options = {})
      filename = "#{filename}.png" unless filename.split('.').many?
      path = image_path "refinery/icons/#{filename}", skip_pipeline: true
      image_tag path, {:width => 16, :height => 16}.merge(options)
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
      options[:class].presence ? options[:class] << " #{action}_icon " : options[:class] = "#{action}_icon"
      options[:class] << ' icon_label' if label

      case action
      when :preview
        options[:target] = '_blank'
      when :delete
        options[:method] = :delete
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