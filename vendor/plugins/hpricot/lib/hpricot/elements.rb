module Hpricot
# Once you've matched a list of elements, you will often need to handle them as
# a group.  Or you may want to perform the same action on each of them.
# Hpricot::Elements is an extension of Ruby's array class, with some methods
# added for altering elements contained in the array.
#
# If you need to create an element array from regular elements:
#
#   Hpricot::Elements[ele1, ele2, ele3]
#
# Assuming that ele1, ele2 and ele3 contain element objects (Hpricot::Elem,
# Hpricot::Doc, etc.)  
#
# == Continuing Searches
#
# Usually the Hpricot::Elements you're working on comes from a search you've
# done.  Well, you can continue searching the list by using the same <tt>at</tt>
# and <tt>search</tt> methods you can use on plain elements.
#
#   elements = doc.search("/div/p")
#   elements = elements.search("/a[@href='http://hoodwink.d/']")
#   elements = elements.at("img")
#
# == Altering Elements
#
# When you're altering elements in the list, your changes will be reflected in
# the document you started searching from.
#
#   doc = Hpricot("That's my <b>spoon</b>, Tyler.")
#   doc.at("b").swap("<i>fork</i>")
#   doc.to_html
#     #=> "That's my <i>fork</i>, Tyler." 
#
# == Getting More Detailed
#
# If you can't find a method here that does what you need, you may need to
# loop through the elements and find a method in Hpricot::Container::Trav
# which can do what you need.
#
# For example, you may want to search for all the H3 header tags in a document
# and grab all the tags underneath the header, but not inside the header.
# A good method for this is <tt>next_sibling</tt>:
#
#   doc.search("h3").each do |h3|
#     while ele = h3.next_sibling
#       ary << ele   # stuff away all the elements under the h3
#     end
#   end
#
# Most of the useful element methods are in the mixins Hpricot::Traverse
# and Hpricot::Container::Trav.
  class Elements < Array
  
    # Searches this list for any elements (or children of these elements) matching
    # the CSS or XPath expression +expr+.  Root is assumed to be the element scanned.
    #
    # See Hpricot::Container::Trav.search for more.
    def search(*expr,&blk)
      Elements[*map { |x| x.search(*expr,&blk) }.flatten.uniq]
    end
    alias_method :/, :search

    # Searches this list for the first element (or child of these elements) matching
    # the CSS or XPath expression +expr+.  Root is assumed to be the element scanned.
    #
    # See Hpricot::Container::Trav.at for more.
    def at(expr, &blk)
      search(expr, &blk).first
    end
    alias_method :%, :at

    # Convert this group of elements into a complete HTML fragment, returned as a
    # string.
    def to_html
      map { |x| x.output("") }.join
    end
    alias_method :to_s, :to_html

    # Returns an HTML fragment built of the contents of each element in this list.
    #
    # If a HTML +string+ is supplied, this method acts like inner_html=.
    def inner_html(*string)
      if string.empty?
        map { |x| x.inner_html }.join
      else
        x = self.inner_html = string.pop || x
      end
    end
    alias_method :html, :inner_html
    alias_method :innerHTML, :inner_html

    # Replaces the contents of each element in this list.  Supply an HTML +string+,
    # which is loaded into Hpricot objects and inserted into every element in this
    # list.
    def inner_html=(string)
      each { |x| x.inner_html = string }
    end
    alias_method :html=, :inner_html=
    alias_method :innerHTML=, :inner_html=

    # Returns an string containing the text contents of each element in this list.
    # All HTML tags are removed.
    def inner_text
      map { |x| x.inner_text }.join
    end
    alias_method :text, :inner_text

    # Remove all elements in this list from the document which contains them.
    #
    #   doc = Hpricot("<html>Remove this: <b>here</b></html>")
    #   doc.search("b").remove
    #   doc.to_html
    #     => "<html>Remove this: </html>"
    #
    def remove
      each { |x| x.parent.children.delete(x) }
    end

    # Empty the elements in this list, by removing their insides.
    #
    #   doc = Hpricot("<p> We have <i>so much</i> to say.</p>")
    #   doc.search("i").empty
    #   doc.to_html
    #     => "<p> We have <i></i> to say.</p>"
    #
    def empty
      each { |x| x.inner_html = nil }
    end

    # Add to the end of the contents inside each element in this list.
    # Pass in an HTML +str+, which is turned into Hpricot elements.
    def append(str = nil, &blk)
      each { |x| x.html(x.children + x.make(str, &blk)) }
    end

    # Add to the start of the contents inside each element in this list.
    # Pass in an HTML +str+, which is turned into Hpricot elements.
    def prepend(str = nil, &blk)
      each { |x| x.html(x.make(str, &blk) + x.children) }
    end
 
    # Add some HTML just previous to each element in this list.
    # Pass in an HTML +str+, which is turned into Hpricot elements.
    def before(str = nil, &blk)
      each { |x| x.parent.insert_before x.make(str, &blk), x }
    end

    # Just after each element in this list, add some HTML.
    # Pass in an HTML +str+, which is turned into Hpricot elements.
    def after(str = nil, &blk)
      each { |x| x.parent.insert_after x.make(str, &blk), x }
    end

    # Wraps each element in the list inside the element created by HTML +str+. 
    # If more than one element is found in the string, Hpricot locates the
    # deepest spot inside the first element.
    #
    #  doc.search("a[@href]").
    #      wrap(%{<div class="link"><div class="link_inner"></div></div>})
    #
    # This code wraps every link on the page inside a +div.link+ and a +div.link_inner+ nest.
    def wrap(str = nil, &blk)
      each do |x|
        wrap = x.make(str, &blk)
        nest = wrap.detect { |w| w.respond_to? :children }
        unless nest
          raise "No wrapping element found."
        end
        x.parent.replace_child(x, wrap)
        nest = nest.children.first until nest.empty?
        nest.html([x])
      end
    end

    # Gets and sets attributes on all matched elements.
    #
    # Pass in a +key+ on its own and this method will return the string value
    # assigned to that attribute for the first elements.  Or +nil+ if the 
    # attribute isn't found.
    #
    #   doc.search("a").attr("href")
    #     #=> "http://hacketyhack.net/"
    #
    # Or, pass in a +key+ and +value+.  This will set an attribute for all
    # matched elements.
    #
    #   doc.search("p").attr("class", "basic")
    # 
    # You may also use a Hash to set a series of attributes:
    #
    #   (doc/"a").attr(:class => "basic", :href => "http://hackety.org/")
    # 
    # Lastly, a block can be used to rewrite an attribute based on the element
    # it belongs to.  The block will pass in an element.  Return from the block
    # the new value of the attribute.
    #
    #   records.attr("href") { |e| e['href'] + "#top" }
    #
    # This example adds a <tt>#top</tt> anchor to each link.
    #
    def attr key, value = nil, &blk
      if value or blk
        each do |el|
          el.set_attribute(key, value || blk[el])
        end
        return self      
      end    
      if key.is_a? Hash
        key.each { |k,v| self.attr(k,v) }
        return self
      else
        return self[0].get_attribute(key)
      end
    end
    alias_method :set, :attr
  
    # Adds the class to all matched elements.
    #
    #   (doc/"p").add_class("bacon")
    #
    # Now all paragraphs will have class="bacon".
    def add_class class_name
      each do |el|
        next unless el.respond_to? :get_attribute
        classes = el.get_attribute('class').to_s.split(" ")
        el.set_attribute('class', classes.push(class_name).uniq.join(" "))
      end
      self
    end

    # Remove an attribute from each of the matched elements.
    #
    #   (doc/"input").remove_attr("disabled")
    #
    def remove_attr name
      each do |el|
        next unless el.respond_to? :remove_attribute
        el.remove_attribute(name)
      end
      self      
    end

    # Removes a class from all matched elements.
    #
    #   (doc/"span").remove_class("lightgrey")
    #
    # Or, to remove all classes:
    #
    #   (doc/"span").remove_class
    # 
    def remove_class name = nil
      each do |el|
        next unless el.respond_to? :get_attribute
        if name
          classes = el.get_attribute('class').to_s.split(" ")
          el.set_attribute('class', (classes - [name]).uniq.join(" "))
        else
          el.remove_attribute("class")
        end
      end
      self      
    end

    ATTR_RE = %r!\[ *(?:(@)([\w\(\)-]+)|([\w\(\)-]+\(\))) *([~\!\|\*$\^=]*) *'?"?([^'"]*)'?"? *\]!i
    BRACK_RE = %r!(\[) *([^\]]*) *\]+!i
    FUNC_RE = %r!(:)?([a-zA-Z0-9\*_-]*)\( *[\"']?([^ \)]*?)['\"]? *\)!
    CUST_RE = %r!(:)([a-zA-Z0-9\*_-]*)()!
    CATCH_RE = %r!([:\.#]*)([a-zA-Z0-9\*_-]+)!

    def self.filter(nodes, expr, truth = true)
        until expr.empty?
            _, *m = *expr.match(/^(?:#{ATTR_RE}|#{BRACK_RE}|#{FUNC_RE}|#{CUST_RE}|#{CATCH_RE})/)
            break unless _

            expr = $'
            m.compact!
            if m[0] == '@'
                m[0] = "@#{m.slice!(2,1).join}"
            end

            if m[0] == '[' && m[1] =~ /^\d+$/
                m = [":", "nth", m[1].to_i-1]
            end

            if m[0] == ":" && m[1] == "not"
                nodes, = Elements.filter(nodes, m[2], false)
            elsif "#{m[0]}#{m[1]}" =~ /^(:even|:odd)$/
                new_nodes = []
                nodes.each_with_index {|n,i| new_nodes.push(n) if (i % 2 == (m[1] == "even" ? 0 : 1)) }
                nodes = new_nodes
            elsif "#{m[0]}#{m[1]}" =~ /^(:first|:last)$/
                nodes = [nodes.send(m[1])]
            else
                meth = "filter[#{m[0]}#{m[1]}]" unless m[0].empty?
                if meth and Traverse.method_defined? meth
                    args = m[2..-1]
                else
                    meth = "filter[#{m[0]}]"
                    if Traverse.method_defined? meth
                        args = m[1..-1]
                    end
                end
                args << -1
                nodes = Elements[*nodes.find_all do |x| 
                                      args[-1] += 1
                                      x.send(meth, *args) ? truth : !truth
                                  end]
            end
        end
        [nodes, expr]
    end

    # Given two elements, attempt to gather an Elements array of everything between
    # (and including) those two elements.
    def self.expand(ele1, ele2, excl=false)
      ary = []
      offset = excl ? -1 : 0

      if ele1 and ele2
        # let's quickly take care of siblings
        if ele1.parent == ele2.parent
          ary = ele1.parent.children[ele1.node_position..(ele2.node_position+offset)]
        else
          # find common parent
          p, ele1_p = ele1, [ele1]
          ele1_p.unshift p while p.respond_to?(:parent) and p = p.parent
          p, ele2_p = ele2, [ele2]
          ele2_p.unshift p while p.respond_to?(:parent) and p = p.parent
          common_parent = ele1_p.zip(ele2_p).select { |p1, p2| p1 == p2 }.flatten.last

          child = nil
          if ele1 == common_parent
            child = ele2
          elsif ele2 == common_parent
            child = ele1
          end

          if child
            ary = common_parent.children[0..(child.node_position+offset)]
          end
        end
      end

      return Elements[*ary]
    end

    def filter(expr)
        nodes, = Elements.filter(self, expr)
        nodes
    end

    def not(expr)
        if expr.is_a? Traverse
            nodes = self - [expr]
        else
            nodes, = Elements.filter(self, expr, false)
        end
        nodes
    end

    private
    def copy_node(node, l)
        l.instance_variables.each do |iv|
            node.instance_variable_set(iv, l.instance_variable_get(iv))
        end
    end

  end

  module Traverse
    def self.filter(tok, &blk)
      define_method("filter[#{tok.is_a?(String) ? tok : tok.inspect}]", &blk)
    end

    filter '' do |name,i|
      name == '*' || (self.respond_to?(:name) && self.name.downcase == name.downcase)
    end

    filter '#' do |id,i|
      self.elem? and get_attribute('id').to_s == id
    end

    filter '.' do |name,i|
      self.elem? and classes.include? name
    end

    filter :lt do |num,i|
      self.position < num.to_i
    end

    filter :gt do |num,i|
      self.position > num.to_i
    end

    nth = proc { |num,i| self.position == num.to_i }
    nth_first = proc { |*a| self.position == 0 }
    nth_last = proc { |*a| self == parent.children_of_type(self.name).last }

    filter :nth, &nth
    filter :eq, &nth
    filter ":nth-of-type", &nth

    filter :first, &nth_first
    filter ":first-of-type", &nth_first

    filter :last, &nth_last
    filter ":last-of-type", &nth_last

    filter :even do |num,i|
      self.position % 2 == 0
    end

    filter :odd do |num,i|
      self.position % 2 == 1
    end

    filter ':first-child' do |i|
      self == parent.containers.first
    end

    filter ':nth-child' do |arg,i|
      case arg 
      when 'even'; (parent.containers.index(self) + 1) % 2 == 0
      when 'odd';  (parent.containers.index(self) + 1) % 2 == 1
      else         self == (parent.containers[arg.to_i - 1])
      end
    end

    filter ":last-child" do |i|
      self == parent.containers.last
    end
    
    filter ":nth-last-child" do |arg,i|
      self == parent.containers[-1-arg.to_i]
    end

    filter ":nth-last-of-type" do |arg,i|
      self == parent.children_of_type(self.name)[-1-arg.to_i]
    end

    filter ":only-of-type" do |arg,i|
      parent.children_of_type(self.name).length == 1
    end

    filter ":only-child" do |arg,i|
      parent.containers.length == 1
    end

    filter :parent do |*a|
      containers.length > 0
    end

    filter :empty do |*a|
      containers.length == 0
    end

    filter :root do |*a|
      self.is_a? Hpricot::Doc
    end
    
    filter 'text' do |*a|
      self.text?
    end

    filter 'comment' do |*a|
      self.comment?
    end

    filter :contains do |arg, ignore|
      html.include? arg
    end
    
    

    pred_procs =
      {'text()' => proc { |ele, *_| ele.inner_text.strip },
       '@'      => proc { |ele, attr, *_| ele.get_attribute(attr).to_s if ele.elem? }}
    
    oper_procs =
      {'='      => proc { |a,b| a == b },
       '!='     => proc { |a,b| a != b },
       '~='     => proc { |a,b| a.split(/\s+/).include?(b) },
       '|='     => proc { |a,b| a =~ /^#{Regexp::quote b}(-|$)/ },
       '^='     => proc { |a,b| a.index(b) == 0 },
       '$='     => proc { |a,b| a =~ /#{Regexp::quote b}$/ },
       '*='     => proc { |a,b| idx = a.index(b) }}

    pred_procs.each do |pred_n, pred_f|
      oper_procs.each do |oper_n, oper_f|
        filter "#{pred_n}#{oper_n}" do |*a|
          qual = pred_f[self, *a]
          oper_f[qual, a[-2]] if qual
        end
      end
    end

    filter 'text()' do |val,i|
      self.children.grep(Hpricot::Text).detect { |x| x.content =~ /\S/ } if self.children
    end

    filter '@' do |attr,val,i|
      self.elem? and has_attribute? attr
    end

    filter '[' do |val,i|
      self.elem? and search(val).length > 0
    end

  end
end
