module Refinery
  module TagHelper
    include ActionHelper

    # Returns <img class='help' tooltip='Your Input' src='refinery/icons/information.png' />

    # Remember to wrap your block with <span class='label_with_help'></span> if you're using a label next to the help tag.
    def refinery_help_tag(title='Tip')
      title = title.html_safe? ? title : h(title)
      action_icon(:info, '#', title, {tooltip: title})
    end

    # This is just a quick wrapper to render an image tag that lives inside refinery/icons.
    # They are all 16x16 so this is the default but is able to be overriden with supplied options.
    def refinery_icon_tag(filename, options = {})
      Refinery.deprecate('Refinery::TagHelper.refinery_icon_tag', when: '5.1', replacement: 'Refinery::ActionHelper.action_icon')

      filename = "#{filename}.png" unless filename.split('.').many?
      path = image_path "refinery/icons/#{filename}", skip_pipeline: true
      image_tag path, {width: 16, height: 16}.merge(options)
    end

  end
end
