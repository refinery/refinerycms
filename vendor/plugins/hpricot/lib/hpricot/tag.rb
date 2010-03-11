module Hpricot
  # :stopdoc:

  class Doc
    def output(out, opts = {})
      children.each do |n|
        n.output(out, opts)
      end if children
      out
    end
    def make(input = nil, &blk)
      Hpricot.make(input, @options, &blk).children
    end
    def altered!; end
    def inspect_tree
      children.map { |x| x.inspect_tree }.join if children
    end
  end

  module Node
    def html_quote(str)
      "\"" + str.gsub('"', '\\"') + "\""
    end
    def clear_raw; end
    def if_output(opts)
      if opts[:preserve] and not raw_string.nil?
        raw_string
      else
        yield opts
      end
    end
    def pathname; self.name end
    def altered!
      clear_raw
    end
    def inspect_tree(depth = 0)
      %{#{" " * depth}} + self.class.name.split(/::/).last.downcase + "\n"
    end
  end

  class Attributes
    attr_accessor :element
    def initialize e
      @element = e
    end
    def [] k 
      Hpricot.uxs((@element.raw_attributes || {})[k])
    end
    def []= k, v
      (@element.raw_attributes ||= {})[k] = v.fast_xs
    end
    def to_hash
      if @element.raw_attributes
        @element.raw_attributes.inject({}) do |hsh, (k, v)|
          hsh[k] = Hpricot.uxs(v)
          hsh
        end
      else
        {}
      end
    end
    def to_s
      to_hash.to_s
    end
    def inspect
      to_hash.inspect
    end
  end

  class Elem
    def initialize tag, attrs = nil, children = nil, etag = nil
      self.name, self.raw_attributes, self.children, self.etag =
        tag, attrs, children, etag
    end
    def empty?; children.nil? or children.empty? end
    def attributes
      Attributes.new self
    end
    def to_plain_text
      if self.name == 'br'
        "\n"
      elsif self.name == 'p'
        "\n\n" + super + "\n\n"
      elsif self.name == 'a' and self.has_attribute?('href')
        "#{super} [#{self['href']}]"
      elsif self.name == 'img' and self.has_attribute?('src')
        "[img:#{self['src']}]"
      else
        super
      end
    end
    def pathname; self.name end
    def output(out, opts = {})
      out <<
        if_output(opts) do
          "<#{name}#{attributes_as_html}" +
            ((empty? and not etag) ? " /" : "") +
            ">"
        end
      if children
        children.each { |n| n.output(out, opts) }
      end
      if opts[:preserve]
        out << etag if etag
      elsif etag or !empty?
        out << "</#{name}>"
      end
      out
    end
    def attributes_as_html
      if raw_attributes
        raw_attributes.map do |aname, aval|
          " #{aname}" +
            (aval ? "=#{html_quote aval}" : "")
        end.join
      end
    end
    def inspect_tree(depth = 0)
      %{#{" " * depth}} + name + "\n" +
        (children ? children.map { |x| x.inspect_tree(depth + 1) }.join : "")
    end
  end

  class BogusETag
    def initialize name; self.name = name end
    def output(out, opts = {})
      out << if_output(opts) { "" }
    end
  end

  class ETag < BogusETag
    def output(out, opts = {}); out << if_output(opts) { '' }; end
  end

  class Text
    def initialize content; self.content = content end
    def pathname; "text()" end
    def to_s
      Hpricot.uxs(content)
    end
    alias_method :inner_text, :to_s
    alias_method :to_plain_text, :to_s
    def << str; self.content << str end
    def output(out, opts = {})
      out <<
        if_output(opts) do
          content.to_s
        end
    end
  end

  class CData
    def initialize content; self.content = content end
    alias_method :to_s, :content
    alias_method :to_plain_text, :content
    alias_method :inner_text, :content
    def raw_string; "<![CDATA[#{content}]]>" end
    def output(out, opts = {})
      out <<
        if_output(opts) do
          "<![CDATA[#{content}]]>"
        end
    end
  end

  class XMLDecl
    def pathname; "xmldecl()" end
    def output(out, opts = {})
      out <<
        if_output(opts) do
          "<?xml version=\"#{version}\"" +
            (encoding ? " encoding=\"#{encoding}\"" : "") +
            (standalone != nil ? " standalone=\"#{standalone ? 'yes' : 'no'}\"" : "") +
            "?>"
        end
    end
  end

  class DocType
    def initialize target, pub, sys
      self.target, self.public_id, self.system_id = target, pub, sys
    end
    def pathname; "doctype()" end
    def output(out, opts = {})
      out <<
        if_output(opts) do
          "<!DOCTYPE #{target} " +
            (public_id ? "PUBLIC \"#{public_id}\"" : "SYSTEM") +
            (system_id ? " #{html_quote(system_id)}" : "") + ">"
        end
    end
  end

  class ProcIns
    def pathname; "procins()" end
    def raw_string; output("") end
    def output(out, opts = {})
      out << 
        if_output(opts) do
          "<?#{target}" +
           (content ? " #{content}" : "") +
           "?>"
        end
    end
  end

  class Comment
    def pathname; "comment()" end
    def raw_string; "<!--#{content}-->" end
    def output(out, opts = {})
      out <<
        if_output(opts) do
          "<!--#{content}-->"
        end
    end
  end

  # :startdoc:
end
