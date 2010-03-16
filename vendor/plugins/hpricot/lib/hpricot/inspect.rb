require 'pp'

module Hpricot
  # :stopdoc:
  class Elements
    def pretty_print(q)
      q.object_group(self) { super }
    end
    alias inspect pretty_print_inspect
  end

  class Doc
    def pretty_print(q)
      q.object_group(self) { children.each {|elt| q.breakable; q.pp elt } if children }
    end
    alias inspect pretty_print_inspect
  end

  module Leaf
    def pretty_print(q)
      q.group(1, '{', '}') {
        q.text self.class.name.sub(/.*::/,'').downcase
        if rs = raw_string
          rs.scan(/[^\r\n]*(?:\r\n?|\n|[^\r\n]\z)/) {|line|
            q.breakable
            q.pp line
          }
        elsif self.respond_to? :to_s
          q.breakable
          q.text self.to_s
        end
      }
    end
    alias inspect pretty_print_inspect
  end

  class Elem
    def pretty_print(q)
      if empty?
        q.group(1, '{emptyelem', '}') {
          q.breakable; pretty_print_stag q
        }
      else
        q.group(1, "{elem", "}") {
          q.breakable; pretty_print_stag q
          if children
            children.each {|elt| q.breakable; q.pp elt }
          end
          if etag
            q.breakable; q.text etag
          end
        }
      end
    end
    def pretty_print_stag(q)
      q.group(1, '<', '>') {
        q.text name

        if raw_attributes
          raw_attributes.each {|n, t|
            q.breakable
            if t
              q.text "#{n}=\"#{Hpricot.uxs(t)}\""
            else
              q.text n
            end
          }
        end
      }
    end
    alias inspect pretty_print_inspect
  end

  class ETag
    def pretty_print(q)
      q.group(1, '</', '>') {
        q.text name
      }
    end
    alias inspect pretty_print_inspect
  end

  class Text
    def pretty_print(q)
      q.text content.dump
    end
  end

  class BogusETag
    def pretty_print(q)
      q.group(1, '{', '}') {
        q.text self.class.name.sub(/.*::/,'').downcase
        if rs = raw_string
          q.breakable
          q.text rs
        else
          q.text "</#{name}>"
        end
      }
    end
  end
  # :startdoc:
end
