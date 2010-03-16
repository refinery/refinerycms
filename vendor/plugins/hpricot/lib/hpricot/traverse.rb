require 'hpricot/elements'
require 'uri'

module Hpricot
  module Traverse
    # Is this object the enclosing HTML or XML document?
    def doc?() Doc::Trav === self end
    # Is this object an HTML or XML element?
    def elem?() Elem::Trav === self end
    # Is this object an HTML text node?
    def text?() Text::Trav === self end
    # Is this object an XML declaration?
    def xmldecl?() XMLDecl::Trav === self end
    # Is this object a doctype tag?
    def doctype?() DocType::Trav === self end
    # Is this object an XML processing instruction?
    def procins?() ProcIns::Trav === self end
    # Is this object a comment?
    def comment?() Comment::Trav === self end
    # Is this object a stranded end tag?
    def bogusetag?() BogusETag::Trav === self end

    # Parses an HTML string, making an HTML fragment based on
    # the options used to create the container document.
    def make(input = nil, &blk)
      if parent and parent.respond_to? :make
        parent.make(input, &blk)
      else
        Hpricot.make(input, &blk).children
      end
    end

    # Builds an HTML string from this node and its contents.
    # If you need to write to a stream, try calling <tt>output(io)</tt>
    # as a method on this object.
    def to_html
      output("")
    end
    alias_method :to_s, :to_html

    # Attempts to preserve the original HTML of the document, only
    # outputing new tags for elements which have changed.
    def to_original_html
      output("", :preserve => true)
    end

    def index(name)
      i = 0
      return i if name == "*"
      children.each do |x|
        return i if (x.respond_to?(:name) and name == x.name) or
          (x.text? and name == "text()")
        i += 1
      end if children
      -1
    end

    # Puts together an array of neighboring nodes based on their proximity
    # to this node.  So, for example, to get the next node, you could use
    # <tt>nodes_at(1).  Or, to get the previous node, use <tt>nodes_at(1)</tt>.
    #
    # This method also accepts ranges and sets of numbers.
    #
    #    ele.nodes_at(-3..-1, 1..3) # gets three nodes before and three after
    #    ele.nodes_at(1, 5, 7) # gets three nodes at offsets below the current node
    #    ele.nodes_at(0, 5..6) # the current node and two others
    def nodes_at(*pos)
      sib = parent.children
      i, si = 0, sib.index(self)
      pos.map! do |r|
        if r.is_a?(Range) and r.begin.is_a?(String)
          r = Range.new(parent.index(r.begin)-si, parent.index(r.end)-si, r.exclude_end?)
        end
        r
      end
      p pos
      Elements[*
        sib.select do |x|
          sel =
            case i - si when *pos
              true
            end
          i += 1
          sel
        end
      ]
    end

    # Returns the node neighboring this node to the south: just below it.
    # This method includes text nodes and comments and such.
    def next
      sib = parent.children
      sib[sib.index(self) + 1] if parent
    end
    alias_method :next_node, :next

    # Returns to node neighboring this node to the north: just above it.
    # This method includes text nodes and comments and such.
    def previous
      sib = parent.children
      x = sib.index(self) - 1
      sib[x] if sib and x >= 0
    end
    alias_method :previous_node, :previous

    # Find all preceding nodes.
    def preceding
      sibs = parent.children
      si = sibs.index(self) 
      return Elements[*sibs[0...si]] 
    end 
 
    # Find all nodes which follow the current one.
    def following
      sibs = parent.children 
      si = sibs.index(self) + 1 
      return Elements[*sibs[si...sibs.length]] 
    end 

    # Adds elements immediately after this element, contained in the +html+ string.
    def after(html = nil, &blk)
      parent.insert_after(make(html, &blk), self)
    end

    # Adds elements immediately before this element, contained in the +html+ string.
    def before(html = nil, &blk)
      parent.insert_before(make(html, &blk), self)
    end


    # Replace this element and its contents with the nodes contained
    # in the +html+ string.
    def swap(html = nil, &blk)
      parent.altered!
      parent.replace_child(self, make(html, &blk))
    end

    def get_subnode(*indexes)
      n = self
      indexes.each {|index|
        n = n.get_subnode_internal(index)
      }
      n
    end

    # Builds a string from the text contained in this node.  All
    # HTML elements are removed.
    def to_plain_text
      if respond_to?(:children) and children
        children.map { |x| x.to_plain_text }.join.strip.gsub(/\n{2,}/, "\n\n")
      else
        ""
      end
    end

    # Builds a string from the text contained in this node.  All
    # HTML elements are removed.
    def inner_text
      if respond_to?(:children) and children
        children.map { |x| x.inner_text }.join
      else
        ""
      end
    end
    alias_method :innerText, :inner_text

    # Builds an HTML string from the contents of this node.
    def html(inner = nil, &blk)
      if inner or blk
        altered!
        case inner
        when Array
          self.children = inner
        else
          self.children = make(inner, &blk)
        end
        reparent self.children
      else
        if respond_to?(:children) and children
          children.map { |x| x.output("") }.join
        else
          ""
        end
      end
    end
    alias_method :inner_html, :html
    alias_method :innerHTML, :inner_html

    # Inserts new contents into the current node, based on
    # the HTML contained in string +inner+.
    def inner_html=(inner)
      html(inner || [])
    end
    alias_method :innerHTML=, :inner_html=

    def reparent(nodes)
      return unless nodes
      altered!
      [*nodes].each { |e| e.parent = self }
    end
    private :reparent

    def clean_path(path)
      path.gsub(/^\s+|\s+$/, '')
    end

    # Builds a unique XPath string for this node, from the
    # root of the document containing it.
    def xpath
      if elem? and has_attribute? 'id'
        "//#{self.name}[@id='#{get_attribute('id')}']"
      else
        sim, id = 0, 0, 0
        parent.children.each do |e|
          id = sim if e == self
          sim += 1 if e.pathname == self.pathname
        end if parent.children
        p = File.join(parent.xpath, self.pathname)
        p += "[#{id+1}]" if sim >= 2
        p
      end
    end

    # Builds a unique CSS string for this node, from the
    # root of the document containing it.
    def css_path
      if elem? and has_attribute? 'id'
        "##{get_attribute('id')}"
      else
        sim, i, id = 0, 0, 0
        parent.children.each do |e|
          id = sim if e == self
          sim += 1 if e.pathname == self.pathname
        end if parent.children
        p = parent.css_path
        p = p ? "#{p} > #{self.pathname}" : self.pathname
        p += ":nth(#{id})" if sim >= 2
        p
      end
    end

    def node_position
      parent.children.index(self)
    end

    def position
      parent.children_of_type(self.pathname).index(self)
    end

    # Searches this node for all elements matching
    # the CSS or XPath +expr+.  Returns an Elements array
    # containing the matching nodes.  If +blk+ is given, it
    # is used to iterate through the matching set.
    def search(expr, &blk)
      if Range === expr
        return Elements.expand(at(expr.begin), at(expr.end), expr.exclude_end?)
      end
      last = nil
      nodes = [self]
      done = []
      expr = expr.to_s
      hist = []
      until expr.empty?
          expr = clean_path(expr)
          expr.gsub!(%r!^//!, '')

          case expr
          when %r!^/?\.\.!
              last = expr = $'
              nodes.map! { |node| node.parent }
          when %r!^[>/]\s*!
              last = expr = $'
              nodes = Elements[*nodes.map { |node| node.children if node.respond_to? :children }.flatten.compact]
          when %r!^\+!
              last = expr = $'
              nodes.map! do |node|
                  siblings = node.parent.children
                  siblings[siblings.index(node)+1]
              end
              nodes.compact!
          when %r!^~!
              last = expr = $'
              nodes.map! do |node|
                  siblings = node.parent.children
                  siblings[(siblings.index(node)+1)..-1]
              end
              nodes.flatten!
          when %r!^[|,]!
              last = expr = " #$'"
              nodes.shift if nodes.first == self
              done += nodes
              nodes = [self]
          else
              m = expr.match(%r!^([#.]?)([a-z0-9\\*_-]*)!i).to_a
              after = $'
              mt = after[%r!:[a-z0-9\\*_-]+!i, 0]
              oop = false
              if mt and not (mt == ":not" or Traverse.method_defined? "filter[#{mt}]")
                after = $' 
                m[2] += mt
                expr = after
              end
              if m[1] == '#'
                  oid = get_element_by_id(m[2])
                  nodes = oid ? [oid] : []
                  expr = after
              else
                  m[2] = "*" if after =~ /^\(\)/ || m[2] == "" || m[1] == "."
                  ret = []
                  nodes.each do |node|
                      case m[2]
                      when '*'
                          node.traverse_element { |n| ret << n }
                      else
                          if node.respond_to? :get_elements_by_tag_name
                            ret += [*node.get_elements_by_tag_name(m[2])] - [*(node unless last)]
                          end
                      end
                  end
                  nodes = ret
              end
              last = nil
          end

          hist << expr
          break if hist[-1] == hist[-2]
          nodes, expr = Elements.filter(nodes, expr)
      end
      nodes = done + nodes.flatten.uniq
      if blk
          nodes.each(&blk)
          self
      else
          Elements[*nodes]
      end
    end
    alias_method :/, :search

    # Find the first matching node for the CSS or XPath
    # +expr+ string.
    def at(expr)
      search(expr).first
    end
    alias_method :%, :at

    # +traverse_element+ traverses elements in the tree.
    # It yields elements in depth first order.
    #
    # If _names_ are empty, it yields all elements.
    # If non-empty _names_ are given, it should be list of universal names.
    # 
    # A nested element is yielded in depth first order as follows.
    #
    #   t = Hpricot('<a id=0><b><a id=1 /></b><c id=2 /></a>') 
    #   t.traverse_element("a", "c") {|e| p e}
    #   # =>
    #   {elem <a id="0"> {elem <b> {emptyelem <a id="1">} </b>} {emptyelem <c id="2">} </a>}
    #   {emptyelem <a id="1">}
    #   {emptyelem <c id="2">}
    #
    # Universal names are specified as follows.
    #
    #   t = Hpricot(<<'End')
    #   <html>
    #   <meta name="robots" content="index,nofollow">
    #   <meta name="author" content="Who am I?">    
    #   </html>
    #   End
    #   t.traverse_element("{http://www.w3.org/1999/xhtml}meta") {|e| p e}
    #   # =>
    #   {emptyelem <{http://www.w3.org/1999/xhtml}meta name="robots" content="index,nofollow">}
    #   {emptyelem <{http://www.w3.org/1999/xhtml}meta name="author" content="Who am I?">}
    #
    def traverse_element(*names, &block) # :yields: element
      if names.empty?
        traverse_all_element(&block)
      else
        name_set = {}
        names.each {|n| name_set[n] = true }
        traverse_some_element(name_set, &block)
      end
      nil
    end

    # Find children of a given +tag_name+.
    #
    #   ele.children_of_type('p')
    #     #=> [...array of paragraphs...]
    #
    def children_of_type(tag_name)
      if respond_to? :children
        children.find_all do |x|
          x.respond_to?(:pathname) && x.pathname == tag_name
        end
      end
    end

  end

  module Container::Trav
    # Return all children of this node which can contain other
    # nodes.  This is a good way to get all HTML elements which
    # aren't text, comment, doctype or processing instruction nodes.
    def containers
      children.grep(Container::Trav)
    end

    # Returns the container node neighboring this node to the south: just below it.
    # By "container" node, I mean: this method does not find text nodes or comments or cdata or any of that.
    # See Hpricot::Traverse#next_node if you need to hunt out all kinds of nodes.
    def next_sibling
      sib = parent.containers
      sib[sib.index(self) + 1] if parent
    end

    # Returns the container node neighboring this node to the north: just above it.
    # By "container" node, I mean: this method does not find text nodes or comments or cdata or any of that.
    # See Hpricot::Traverse#previous_node if you need to hunt out all kinds of nodes.
    def previous_sibling
      sib = parent.containers
      x = sib.index(self) - 1
      sib[x] if sib and x >= 0
    end

    # Find all preceding sibling elements.   Like the other "sibling" methods, this weeds
    # out text and comment nodes.
    def preceding_siblings() 
      sibs = parent.containers 
      si = sibs.index(self) 
      return Elements[*sibs[0...si]] 
    end 
 
    # Find sibling elements which follow the current one.   Like the other "sibling" methods, this weeds
    # out text and comment nodes.
    def following_siblings() 
      sibs = parent.containers 
      si = sibs.index(self) + 1 
      return Elements[*sibs[si...sibs.length]] 
    end 

    # Puts together an array of neighboring sibling elements based on their proximity
    # to this element.
    #
    # This method accepts ranges and sets of numbers.
    #
    #    ele.siblings_at(-3..-1, 1..3) # gets three elements before and three after
    #    ele.siblings_at(1, 5, 7) # gets three elements at offsets below the current element
    #    ele.siblings_at(0, 5..6) # the current element and two others
    #
    # Like the other "sibling" methods, this doesn't find text and comment nodes.
    # Use nodes_at to include those nodes.
    def siblings_at(*pos)
      sib = parent.containers
      i, si = 0, sib.index(self)
      Elements[*
        sib.select do |x|
          sel = case i - si when *pos
                  true
                end
          i += 1
          sel
        end
      ]
    end

    # Replace +old+, a child of the current node, with +new+ node.
    def replace_child(old, new)
      reparent new
      children[children.index(old), 1] = [*new]
    end

    # Insert +nodes+, an array of HTML elements or a single element,
    # before the node +ele+, a child of the current node.
    def insert_before(nodes, ele)
      case nodes
      when Array
        nodes.each { |n| insert_before(n, ele) }
      else
        reparent nodes
        children[children.index(ele) || 0, 0] = nodes
      end
    end

    # Insert +nodes+, an array of HTML elements or a single element,
    # after the node +ele+, a child of the current node.
    def insert_after(nodes, ele)
      case nodes
      when Array
        nodes.reverse_each { |n| insert_after(n, ele) }
      else
        reparent nodes
        idx = children.index(ele)
        children[idx ? idx + 1 : children.length, 0] = nodes
      end
    end

    # +each_child+ iterates over each child.
    def each_child(&block) # :yields: child_node
      children.each(&block) if children
      nil
    end

    # +each_child_with_index+ iterates over each child.
    def each_child_with_index(&block) # :yields: child_node, index
      children.each_with_index(&block) if children
      nil
    end

    # +find_element+ searches an element which universal name is specified by
    # the arguments. 
    # It returns nil if not found.
    def find_element(*names)
      traverse_element(*names) {|e| return e }
      nil
    end

    # Returns a list of CSS classes to which this element belongs.
    def classes
      get_attribute('class').to_s.strip.split(/\s+/)
    end

    def get_element_by_id(id)
      traverse_all_element do |ele|
          if ele.elem? and eid = ele.get_attribute('id')
              return ele if eid.to_s == id
          end
      end
      nil
    end

    def get_elements_by_tag_name(*a)
      list = Elements[]
      a.delete("*")
      traverse_element(*a.map { |tag| [tag, "{http://www.w3.org/1999/xhtml}#{tag}"] }.flatten) do |e|
        list << e if e.elem?
      end
      list
    end

    def each_hyperlink_attribute
      traverse_element(
          '{http://www.w3.org/1999/xhtml}a',
          '{http://www.w3.org/1999/xhtml}area',
          '{http://www.w3.org/1999/xhtml}link',
          '{http://www.w3.org/1999/xhtml}img',
          '{http://www.w3.org/1999/xhtml}object',
          '{http://www.w3.org/1999/xhtml}q',
          '{http://www.w3.org/1999/xhtml}blockquote',
          '{http://www.w3.org/1999/xhtml}ins',
          '{http://www.w3.org/1999/xhtml}del',
          '{http://www.w3.org/1999/xhtml}form',
          '{http://www.w3.org/1999/xhtml}input',
          '{http://www.w3.org/1999/xhtml}head',
          '{http://www.w3.org/1999/xhtml}base',
          '{http://www.w3.org/1999/xhtml}script') {|elem|
        case elem.name
        when %r{\{http://www.w3.org/1999/xhtml\}(?:base|a|area|link)\z}i
          attrs = ['href']
        when %r{\{http://www.w3.org/1999/xhtml\}(?:img)\z}i
          attrs = ['src', 'longdesc', 'usemap']
        when %r{\{http://www.w3.org/1999/xhtml\}(?:object)\z}i
          attrs = ['classid', 'codebase', 'data', 'usemap']
        when %r{\{http://www.w3.org/1999/xhtml\}(?:q|blockquote|ins|del)\z}i
          attrs = ['cite']
        when %r{\{http://www.w3.org/1999/xhtml\}(?:form)\z}i
          attrs = ['action']
        when %r{\{http://www.w3.org/1999/xhtml\}(?:input)\z}i
          attrs = ['src', 'usemap']
        when %r{\{http://www.w3.org/1999/xhtml\}(?:head)\z}i
          attrs = ['profile']
        when %r{\{http://www.w3.org/1999/xhtml\}(?:script)\z}i
          attrs = ['src', 'for']
        end
        attrs.each {|attr|
          if hyperlink = elem.get_attribute(attr)
            yield elem, attr, hyperlink
          end
        }
      }
    end
    private :each_hyperlink_attribute

    # +each_hyperlink_uri+ traverses hyperlinks such as HTML href attribute
    # of A element.
    #
    # It yields Hpricot::Text and URI for each hyperlink.
    #
    # The URI objects are created with a base URI which is given by
    # HTML BASE element or the argument ((|base_uri|)).
    # +each_hyperlink_uri+ doesn't yields href of the BASE element.
    def each_hyperlink_uri(base_uri=nil) # :yields: hyperlink, uri
      base_uri = URI.parse(base_uri) if String === base_uri
      links = []
      each_hyperlink_attribute {|elem, attr, hyperlink|
        if %r{\{http://www.w3.org/1999/xhtml\}(?:base)\z}i =~ elem.name
          base_uri = URI.parse(hyperlink.to_s)
        else
          links << hyperlink
        end
      }
      if base_uri
        links.each {|hyperlink| yield hyperlink, base_uri + hyperlink.to_s }
      else
        links.each {|hyperlink| yield hyperlink, URI.parse(hyperlink.to_s) }
      end
    end

    # +each_hyperlink+ traverses hyperlinks such as HTML href attribute
    # of A element.
    #
    # It yields Hpricot::Text.
    #
    # Note that +each_hyperlink+ yields HTML href attribute of BASE element.
    def each_hyperlink # :yields: text
      links = []
      each_hyperlink_attribute {|elem, attr, hyperlink|
        yield hyperlink
      }
    end

    # +each_uri+ traverses hyperlinks such as HTML href attribute
    # of A element.
    #
    # It yields URI for each hyperlink.
    #
    # The URI objects are created with a base URI which is given by
    # HTML BASE element or the argument ((|base_uri|)).
    def each_uri(base_uri=nil) # :yields: URI
      each_hyperlink_uri(base_uri) {|hyperlink, uri| yield uri }
    end
  end

  # :stopdoc:
  module Doc::Trav
    def traverse_all_element(&block)
      children.each {|c| c.traverse_all_element(&block) } if children
    end
    def xpath
      "/"
    end
    def css_path
      nil
    end
  end

  module Elem::Trav
    def traverse_all_element(&block)
      yield self
      children.each {|c| c.traverse_all_element(&block) } if children
    end
  end

  module Leaf::Trav
    def traverse_all_element
      yield self
    end
  end

  module Doc::Trav
    def traverse_some_element(name_set, &block)
      children.each {|c| c.traverse_some_element(name_set, &block) } if children
    end
  end

  module Elem::Trav
    def traverse_some_element(name_set, &block)
      yield self if name_set.include? self.name
      children.each {|c| c.traverse_some_element(name_set, &block) } if children
    end
  end

  module Leaf::Trav
    def traverse_some_element(name_set)
    end
  end
  # :startdoc:

  module Traverse
    # +traverse_text+ traverses texts in the tree
    def traverse_text(&block) # :yields: text
      traverse_text_internal(&block)
      nil
    end
  end

  # :stopdoc:
  module Container::Trav
    def traverse_text_internal(&block)
      each_child {|c| c.traverse_text_internal(&block) }
    end
  end

  module Leaf::Trav
    def traverse_text_internal
    end
  end

  module Text::Trav
    def traverse_text_internal
      yield self
    end
  end
  # :startdoc:

  module Container::Trav
    # +filter+ rebuilds the tree without some components.
    #
    #   node.filter {|descendant_node| predicate } -> node
    #   loc.filter {|descendant_loc| predicate } -> node
    #
    # +filter+ yields each node except top node.
    # If given block returns false, corresponding node is dropped.
    # If given block returns true, corresponding node is retained and
    # inner nodes are examined.
    #
    # +filter+ returns an node.
    # It doesn't return location object even if self is location object.
    #
    def filter(&block)
      subst = {}
      each_child_with_index {|descendant, i|
        if yield descendant
          if descendant.elem?
            subst[i] = descendant.filter(&block)
          else
            subst[i] = descendant
          end
        else
          subst[i] = nil
        end
      }
      to_node.subst_subnode(subst)
    end
  end

  module Doc::Trav
    # +title+ searches title and return it as a text.
    # It returns nil if not found.
    #
    # +title+ searchs following information.
    #
    # - <title>...</title> in HTML
    # - <title>...</title> in RSS
    def title
      e = find_element('title',
        '{http://www.w3.org/1999/xhtml}title',
        '{http://purl.org/rss/1.0/}title',
        '{http://my.netscape.com/rdf/simple/0.9/}title')
      e && e.extract_text
    end

    # +author+ searches author and return it as a text.
    # It returns nil if not found.
    #
    # +author+ searchs following information.
    #
    # - <meta name="author" content="author-name"> in HTML
    # - <link rev="made" title="author-name"> in HTML
    # - <dc:creator>author-name</dc:creator> in RSS
    # - <dc:publisher>author-name</dc:publisher> in RSS
    def author
      traverse_element('meta',
        '{http://www.w3.org/1999/xhtml}meta') {|e|
        begin
          next unless e.fetch_attr('name').downcase == 'author'
          author = e.fetch_attribute('content').strip
          return author if !author.empty?
        rescue IndexError
        end
      }

      traverse_element('link',
        '{http://www.w3.org/1999/xhtml}link') {|e|
        begin
          next unless e.fetch_attr('rev').downcase == 'made'
          author = e.fetch_attribute('title').strip
          return author if !author.empty?
        rescue IndexError
        end
      } 

      if channel = find_element('{http://purl.org/rss/1.0/}channel')
        channel.traverse_element('{http://purl.org/dc/elements/1.1/}creator') {|e|
          begin
            author = e.extract_text.strip
            return author if !author.empty?
          rescue IndexError
          end
        }
        channel.traverse_element('{http://purl.org/dc/elements/1.1/}publisher') {|e|
          begin
            author = e.extract_text.strip
            return author if !author.empty?
          rescue IndexError
          end
        }
      end

      nil
    end

  end

  module Doc::Trav
    def root
      es = []
      children.each {|c| es << c if c.elem? } if children
      raise Hpricot::Error, "no element" if es.empty?
      raise Hpricot::Error, "multiple top elements" if 1 < es.length
      es[0]
    end
  end

  module Elem::Trav
    def has_attribute?(name)
      self.raw_attributes && self.raw_attributes.has_key?(name.to_s)
    end
    def get_attribute(name)
      a = self.raw_attributes && self.raw_attributes[name.to_s]
      a = Hpricot.uxs(a) if a
      a
    end
    alias_method :[], :get_attribute
    def set_attribute(name, val)
      altered!
      self.raw_attributes ||= {}
      self.raw_attributes[name.to_s] = val.fast_xs
    end
    alias_method :[]=, :set_attribute
    def remove_attribute(name)
      name = name.to_s
      if has_attribute? name
        altered!
        self.raw_attributes.delete(name)
      end
    end
  end

end
