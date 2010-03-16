#!/usr/bin/env ruby

# The XChar library is provided courtesy of Sam Ruby (See
# http://intertwingly.net/stories/2005/09/28/xchar.rb)

# --------------------------------------------------------------------

######################################################################
module Hpricot

  ####################################################################
  # XML Character converter, from Sam Ruby:
  # (see http://intertwingly.net/stories/2005/09/28/xchar.rb). 
  #
  module XChar # :nodoc:

    # See
    # http://intertwingly.net/stories/2004/04/14/i18n.html#CleaningWindows
    # for details.
    CP1252 = {			# :nodoc:
      128 => 8364,		# euro sign
      130 => 8218,		# single low-9 quotation mark
      131 =>  402,		# latin small letter f with hook
      132 => 8222,		# double low-9 quotation mark
      133 => 8230,		# horizontal ellipsis
      134 => 8224,		# dagger
      135 => 8225,		# double dagger
      136 =>  710,		# modifier letter circumflex accent
      137 => 8240,		# per mille sign
      138 =>  352,		# latin capital letter s with caron
      139 => 8249,		# single left-pointing angle quotation mark
      140 =>  338,		# latin capital ligature oe
      142 =>  381,		# latin capital letter z with caron
      145 => 8216,		# left single quotation mark
      146 => 8217,		# right single quotation mark
      147 => 8220,		# left double quotation mark
      148 => 8221,		# right double quotation mark
      149 => 8226,		# bullet
      150 => 8211,		# en dash
      151 => 8212,		# em dash
      152 =>  732,		# small tilde
      153 => 8482,		# trade mark sign
      154 =>  353,		# latin small letter s with caron
      155 => 8250,		# single right-pointing angle quotation mark
      156 =>  339,		# latin small ligature oe
      158 =>  382,		# latin small letter z with caron
      159 =>  376,		# latin capital letter y with diaeresis
    }

    # See http://www.w3.org/TR/REC-xml/#dt-chardata for details.
    PREDEFINED = {
      34 => '&quot;', # quotation mark
      38 => '&amp;',  # ampersand
      60 => '&lt;',   # left angle bracket
      62 => '&gt;'    # right angle bracket
    }
    PREDEFINED_U = PREDEFINED.inject({}) { |hsh, (k, v)| hsh[v] = k; hsh }

    # See http://www.w3.org/TR/REC-xml/#charsets for details.
    VALID = [
      0x9, 0xA, 0xD,
      (0x20..0xD7FF), 
      (0xE000..0xFFFD),
      (0x10000..0x10FFFF)
    ]
  end

  class << self
    # XML escaped version of chr
    def xchr(str)
      n = XChar::CP1252[str] || str
      case n when *XChar::VALID
        XChar::PREDEFINED[n] or (n<128 ? n.chr : "&##{n};")
      else
        '*'
      end
    end

    # XML escaped version of to_s
    def xs(str)
      str.to_s.unpack('U*').map {|n| xchr(n)}.join # ASCII, UTF-8
    rescue
      str.to_s.unpack('C*').map {|n| xchr(n)}.join # ISO-8859-1, WIN-1252
    end

    # XML unescape
    def uxs(str)
      str.to_s.
          gsub(/\&\w+;/) { |x| (XChar::PREDEFINED_U[x] || ??).chr }.
          gsub(/\&\#(\d+);/) { [$1.to_i].pack("U*") }
    end
  end
end

