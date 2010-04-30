=begin
By Henrik Nyh <http://henrik.nyh.se> 2008-01-30.
Free to modify and redistribute with credit.

modified by Dave Nolan <http://textgoeshere.org.uk> 2008-02-06
Ellipsis appended to text of last HTML node
Ellipsis inserted after final word break

modified by Mark Dickson <mark@sitesteaders.com> 2008-12-18
Option to truncate to last full word
Option to include a 'more' link
Check for nil last child

modified by Ken-ichi Ueda <http://kueda.net> 2009-09-02
Rails 2.3 compatability (chars -> mb_chars), via Henrik
Hpricot 0.8 compatability (avoid dup on Hpricot::Elem)

modified by Philip Arndt <http://www.resolvedigital.co.nz> 2009-11-18
renamed function to truncate and activated html truncation when :preserve_html_tags is supplied and true.
modified namespace to Refinery namespace and renamed module.
removed rubygems requirement
=end

require "hpricot"

module Refinery::HtmlTruncationHelper

  # Like the Rails _truncate_ helper but doesn't break HTML tags, entities, and optionally. words.
  def truncate(text, *args)
    return super unless ((arguments = args.dup).extract_options![:preserve_html_tags] == true) # don't ruin the current args object
    return unless text.present?

    options = args.extract_options!
    max_length = options[:length] || 30
    omission = options[:omission] || "..."
    # use :link => link_to('more', post_path), or something to that effect

    doc = Hpricot(text.to_s)
    omission_length = Hpricot(omission).inner_text.mb_chars.length
    content_length = doc.inner_text.mb_chars.length
    actual_length = max_length - omission_length

    if content_length > max_length
      truncated_doc = doc.truncate(actual_length)

      if (options[:preserve_full_words] || false)
        word_length = actual_length - (truncated_doc.inner_html.mb_chars.length - truncated_doc.inner_html.rindex(' '))
        truncated_doc = doc.truncate(word_length)
      end
      if (last_child = truncated_doc.children.last).inner_html.nil?
        "#{truncated_doc.inner_html}#{omission}#{options[:link]}" if options[:link]
      else
        last_child.inner_html = "#{last_child.inner_html.gsub(/\W.[^\s]+$/, "")}#{omission}"
        last_child.inner_html += options[:link] if options[:link]
        truncated_doc
      end
    else
      if options[:link]
        last_child = doc.children.last
        if last_child.inner_html.nil?
          doc.inner_html + options[:link]
        else
          last_child.inner_html = last_child.inner_html.gsub(/\W.[^\s]+$/, "") + options[:link]
          doc
        end
      else
        text.to_s
      end
    end
  end

end

module HpricotTruncator
  module NodeWithChildren
    def truncate(max_length)
      return self if inner_text.mb_chars.length <= max_length
      truncated_node = if self.is_a?(Hpricot::Doc)
        self.dup
      else
        # only pass self.attributes if it's able to use map, otherwise nil works. (Fix for Hpricot 0.8.2)
        self.class.send(:new, self.name, self.attributes.respond_to?("map") ? self.attributes : nil)
      end
      truncated_node.children = []
      each_child do |node|
        remaining_length = max_length - truncated_node.inner_text.mb_chars.length
        break if remaining_length <= 0
        truncated_node.children << node.truncate(remaining_length)
      end
      truncated_node
    end
  end

  module TextNode
    def truncate(max_length)
      # We're using String#scan because Hpricot doesn't distinguish entities.
      Hpricot::Text.new(content.scan(/&#?[^\W_]+;|./).first(max_length).join)
    end
  end

  module IgnoredTag
    def truncate(max_length)
      self
    end
  end
end

Hpricot::Doc.send(:include,       HpricotTruncator::NodeWithChildren)
Hpricot::Elem.send(:include,      HpricotTruncator::NodeWithChildren)
Hpricot::Text.send(:include,      HpricotTruncator::TextNode)
Hpricot::BogusETag.send(:include, HpricotTruncator::IgnoredTag)
Hpricot::Comment.send(:include,   HpricotTruncator::IgnoredTag)
