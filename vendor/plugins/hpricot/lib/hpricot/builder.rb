require 'hpricot/tags'
require 'fast_xs'
require 'hpricot/blankslate'
require 'hpricot/htmlinfo'

module Hpricot
  # XML unescape
  def self.uxs(str)
    str.to_s.
        gsub(/\&(\w+);/) { [NamedCharacters[$1] || ??].pack("U*") }.
        gsub(/\&\#(\d+);/) { [$1.to_i].pack("U*") }
  end

  def self.build(ele = Doc.new, assigns = {}, &blk)
    ele.extend Builder
    assigns.each do |k, v|
      ele.instance_variable_set("@#{k}", v)
    end
    ele.instance_eval(&blk)
    ele
  end

  module Builder

    @@default = {
      :indent => 0,
      :output_helpers => true,
      :output_xml_instruction => true,
      :output_meta_tag => true,
      :auto_validation => true,
      :tagset => Hpricot::XHTMLTransitional,
      :root_attributes => {
        :xmlns => 'http://www.w3.org/1999/xhtml', :'xml:lang' => 'en', :lang => 'en'
      }
    }

    def self.set(option, value)
      @@default[option] = value
    end

    def add_child ele
      ele.parent = self
      self.children ||= []
      self.children << ele
      ele
    end

    # Write a +string+ to the HTML stream, making sure to escape it.
    def text!(string)
      add_child Text.new(string.fast_xs)
    end

    # Write a +string+ to the HTML stream without escaping it.
    def text(string)
      add_child Text.new(string)
      nil
    end
    alias_method :<<, :text
    alias_method :concat, :text

    # Create a tag named +tag+. Other than the first argument which is the tag name,
    # the arguments are the same as the tags implemented via method_missing.
    def tag!(tag, *args, &block)
      ele_id = nil
      if @auto_validation and @tagset
          if !@tagset.tagset.has_key?(tag)
              raise InvalidXhtmlError, "no element `#{tag}' for #{tagset.doctype}"
          elsif args.last.respond_to?(:to_hash)
              attrs = args.last.to_hash

              if @tagset.forms.include?(tag) and attrs[:id]
                attrs[:name] ||= attrs[:id]
              end

              attrs.each do |k, v|
                  atname = k.to_s.downcase.intern
                  unless k =~ /:/ or @tagset.tagset[tag].include? atname
                      raise InvalidXhtmlError, "no attribute `#{k}' on #{tag} elements"
                  end
                  if atname == :id
                      ele_id = v.to_s
                      if @elements.has_key? ele_id
                          raise InvalidXhtmlError, "id `#{ele_id}' already used (id's must be unique)."
                      end
                  end
              end
          end
      end

      # turn arguments into children or attributes
      childs = []
      attrs = args.grep(Hash)
      childs.concat((args - attrs).flatten.map do |x|
        if x.respond_to? :to_html
          Hpricot.make(x.to_html)
        elsif x
          Text.new(x.fast_xs)
        end
      end.flatten)
      attrs = attrs.inject({}) do |hsh, ath|
        ath.each do |k, v|
          hsh[k] = v.to_s.fast_xs if v
        end
        hsh
      end

      # create the element itself
      tag = tag.to_s
      f = Elem.new(tag, attrs, childs, ETag.new(tag))

      # build children from the block
      if block
        build(f, &block)
      end

      add_child f
      f
    end

    def build(*a, &b)
      Hpricot.build(*a, &b)
    end

    # Every HTML tag method goes through an html_tag call.  So, calling <tt>div</tt> is equivalent
    # to calling <tt>html_tag(:div)</tt>.  All HTML tags in Hpricot's list are given generated wrappers
    # for this method.
    #
    # If the @auto_validation setting is on, this method will check for many common mistakes which
    # could lead to invalid XHTML.
    def html_tag(sym, *args, &block)
      if @auto_validation and @tagset.self_closing.include?(sym) and block
        raise InvalidXhtmlError, "the `#{sym}' element is self-closing, please remove the block"
      elsif args.empty? and block.nil?
        CssProxy.new(self, sym)
      else
        tag!(sym, *args, &block)
      end
    end

    XHTMLTransitional.tags.each do |k|
      class_eval %{
        def #{k}(*args, &block)
          html_tag(#{k.inspect}, *args, &block)
        end
      }
    end

    def doctype(target, pub, sys)
      add_child DocType.new(target, pub, sys)
    end

    remove_method :head

    # Builds a head tag.  Adds a <tt>meta</tt> tag inside with Content-Type
    # set to <tt>text/html; charset=utf-8</tt>.
    def head(*args, &block)
      tag!(:head, *args) do
        tag!(:meta, "http-equiv" => "Content-Type", "content" => "text/html; charset=utf-8") if @output_meta_tag
        instance_eval(&block)
      end
    end

    # Builds an html tag.  An XML 1.0 instruction and an XHTML 1.0 Transitional doctype
    # are prepended.  Also assumes <tt>:xmlns => "http://www.w3.org/1999/xhtml",
    # :lang => "en"</tt>.
    def xhtml_transitional(attrs = {}, &block)
      # self.tagset = Hpricot::XHTMLTransitional
      xhtml_html(attrs, &block)
    end

    # Builds an html tag with XHTML 1.0 Strict doctype instead.
    def xhtml_strict(attrs = {}, &block)
      # self.tagset = Hpricot::XHTMLStrict
      xhtml_html(attrs, &block)
    end

    private

    def xhtml_html(attrs = {}, &block)
      instruct! if @output_xml_instruction
      doctype(:html, *@@default[:tagset].doctype)
      tag!(:html, @@default[:root_attributes].merge(attrs), &block)
    end

  end

  # Class used by Markaby::Builder to store element options.  Methods called
  # against the CssProxy object are added as element classes or IDs.
  #
  # See the README for examples.
  class CssProxy < BlankSlate

    # Creates a CssProxy object.
    def initialize(builder, sym)
      @builder, @sym, @attrs = builder, sym, {}
    end

    # Adds attributes to an element.  Bang methods set the :id attribute.
    # Other methods add to the :class attribute.
    def method_missing(id_or_class, *args, &block)
      if (idc = id_or_class.to_s) =~ /!$/
        @attrs[:id] = $`
      else
        @attrs[:class] = @attrs[:class].nil? ? idc : "#{@attrs[:class]} #{idc}".strip
      end

      if block or args.any?
        args.push(@attrs)
        return @builder.tag!(@sym, *args, &block)
      end

      return self
    end

  end
end
