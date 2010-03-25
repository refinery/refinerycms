require 'hpricot/htmlinfo'

def Hpricot(input = nil, opts = {}, &blk)
  Hpricot.make(input, opts, &blk)
end

module Hpricot
  # Exception class used for any errors related to deficiencies in the system when
  # handling the character encodings of a document.
  class EncodingError < StandardError; end

  # Hpricot.parse parses <i>input</i> and return a document tree.
  # represented by Hpricot::Doc.
  def Hpricot.parse(input = nil, opts = {}, &blk)
    make(input, opts, &blk)
  end

  # Hpricot::XML parses <i>input</i>, disregarding all the HTML rules
  # and returning a document tree.
  def Hpricot.XML(input = nil, opts = {}, &blk)
    opts.merge! :xml => true
    make(input, opts, &blk)
  end

  # :stopdoc:

  def Hpricot.make(input = nil, opts = {}, &blk)
    if blk
      doc = Hpricot.build(&blk)
      doc.instance_variable_set("@options", opts)
      doc
    else
      Hpricot.scan(input, opts)
    end
  end

  # :startdoc:
end
