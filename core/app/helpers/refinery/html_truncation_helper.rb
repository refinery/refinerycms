require 'truncate_html'

module Refinery
  module HtmlTruncationHelper

    # Like the Rails _truncate_ helper but doesn't break HTML tags, entities, and words.
    # <script> tags pass through and are not counted in the total.
    # the omission specified _does_ count toward the total length count.
    # use :link => link_to('more', post_path), or something to that effect
    def truncate(text, options = {})
      return unless text.present?
      return super unless options.delete(:preserve_html_tags) == true # ensure preserve_html_tags doesn't pass through

      max_length = options[:length] || 30
      omission = options[:omission] || "..."

      return truncate_html(text,
                           :length => max_length,
                           :word_boundary => true,
                           :omission => omission)
    end
  end
end
