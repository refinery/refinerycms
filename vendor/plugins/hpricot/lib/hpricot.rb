# == About hpricot.rb
#
# All of Hpricot's various part are loaded when you use <tt>require 'hpricot'</tt>.
#
# * hpricot_scan: the scanner (a C extension for Ruby) which turns an HTML stream into tokens.
# * hpricot/parse.rb: uses the scanner to sort through tokens and give you back a complete document object.
# * hpricot/tag.rb: sets up objects for the various types of elements in an HTML document.
# * hpricot/modules.rb: categorizes the various elements using mixins.
# * hpricot/traverse.rb: methods for searching documents.
# * hpricot/elements.rb: methods for dealing with a group of elements as an Hpricot::Elements list.
# * hpricot/inspect.rb: methods for displaying documents in a readable form.

# If available, Nikolai's UTF-8 library will ease use of utf-8 documents.
# See http://git.bitwi.se/ruby-character-encodings.git/.
begin
  require 'encoding/character/utf-8'
rescue LoadError
end

require 'hpricot_scan'
require 'hpricot/tag'
require 'hpricot/modules'
require 'hpricot/traverse'
require 'hpricot/inspect'
require 'hpricot/parse'
require 'hpricot/builder'
