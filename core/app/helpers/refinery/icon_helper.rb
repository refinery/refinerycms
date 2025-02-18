module Refinery
  module IconHelper
    require 'set'

    # finds icons for documents such as resources and images
    # split mime_type,
    # handle special case of 'application',
    # match type or subtype to icons we support
    def mime_type_icon(mime_type)
      default_icon = 'file-o'

      type, sub_type = mime_type.split('/')
      sub_type = application_type(sub_type) if type == 'application'

      icons = available_icons & Set[type, sub_type]  # intersection
      icon = icons.empty? ? default_icon : icons.first

      tag.span class: icon_class(icon)
    end

    # handle mime-types like 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' and
    #                        'application/vnd.ms-excel'
    def application_type(type)
      last_word = type.split('.').last # remove intermediate paths
                      .gsub('-', '_') # convert dashes to underscore
                      .to_sym
      application_icons[last_word]
    end

    def icon_class(icon) = "#{icon}_icon"

    def application_icons = {
      document: "word",
      ms_excel: "excel",
      ms_powerpoint: "powerpoint",
      msword: "word",
      pdf: "pdf",
      presentation: "powerpoint",
      x_rar: "archive",
      sheet: "excel",
      zip: "zip",
    }

    # these are the fontawesome-4 icons matching a document type
    def available_icons = Set[
      'archive', 'audio', 'code', 'excel', 'image',
      'movie', 'pdf', 'photo', 'picture', 'plain',
      'powerpoint', 'sound', 'text', 'video', 'word', 'zip',
    ]
  end
end
