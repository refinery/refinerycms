= Hpricot, Read Any HTML

Hpricot is a fast, flexible HTML parser written in C.  It's designed to be very
accommodating (like Tanaka Akira's HTree) and to have a very helpful library
(like some JavaScript libs -- JQuery, Prototype -- give you.)  The XPath and CSS
parser, in fact, is based on John Resig's JQuery.

Also, Hpricot can be handy for reading broken XML files, since many of the same
techniques can be used.  If a quote is missing, Hpricot tries to figure it out.
If tags overlap, Hpricot works on sorting them out.  You know, that sort of
thing.

*Please read this entire document* before making assumptions about how this
software works.

== An Overview

Let's clear up what Hpricot is.

# Hpricot is *a standalone library*.  It requires no other libraries.  Just Ruby!
# While priding itself on speed, Hpricot *works hard to sort out bad HTML* and
  pays a small penalty in order to get that right.  So that's slightly more important
  to me than speed.
# *If you can see it in Firefox, then Hpricot should parse it.*  That's
  how it should be!  Let me know the minute it's otherwise.
# Primarily, Hpricot is used for reading HTML and tries to sort out troubled
  HTML by having some idea of what good HTML is.  Some people still like to use
  Hpricot for XML reading, but *remember to use the Hpricot::XML() method* for that!

== The Hpricot Kingdom

First, here are all the links you need to know:

* http://wiki.github.com/hpricot/hpricot is the Hpricot wiki and
  http://github.com/hpricot/hpricot/issues is the bug tracker.
  Go there for news and recipes and patches.  It's the center of activity.
* http://github.com/hpricot/hpricot is the main Git
  repository for Hpricot.  You can get the latest code there.
* See COPYING for the terms of this software. (Spoiler: it's absolutely free.)

If you have any trouble, don't hesitate to contact the author.  As always, I'm
not going to say "Use at your own risk" because I don't want this library to be
risky.  If you trip on something, I'll share the liability by repairing things
as quickly as I can.  Your responsibility is to report the inadequacies.

== Installing Hpricot

You may get the latest stable version from Rubyforge. Win32 binaries,
Java binaries (for JRuby), and source gems are available.

  $ gem install hpricot

== An Hpricot Showcase

We're going to run through a big pile of examples to get you jump-started.
Many of these examples are also found at
http://wiki.github.com/hpricot/hpricot/hpricot-basics, in case you
want to add some of your own.

=== Loading Hpricot Itself

You have probably got the gem, right?  To load Hpricot:

 require 'rubygems'
 require 'hpricot'

If you've installed the plain source distribution, go ahead and just:

 require 'hpricot'

=== Load an HTML Page

The <tt>Hpricot()</tt> method takes a string or any IO object and loads the
contents into a document object.

 doc = Hpricot("<p>A simple <b>test</b> string.</p>")

To load from a file, just get the stream open:

 doc = open("index.html") { |f| Hpricot(f) }

To load from a web URL, use <tt>open-uri</tt>, which comes with Ruby:

 require 'open-uri'
 doc = open("http://qwantz.com/") { |f| Hpricot(f) }

Hpricot uses an internal buffer to parse the file, so the IO will stream
properly and large documents won't be loaded into memory all at once.  However,
the parsed document object will be present in memory, in its entirety.

=== Search for Elements

Use <tt>Doc.search</tt>:

 doc.search("//p[@class='posted']")
 #=> #<Hpricot:Elements[{p ...}, {p ...}]>

<tt>Doc.search</tt> can take an XPath or CSS expression.  In the above example,
all paragraph <tt><p></tt> elements are grabbed which have a <tt>class</tt>
attribute of <tt>"posted"</tt>.

A shortcut is to use the divisor:

 (doc/"p.posted")
 #=> #<Hpricot:Elements[{p ...}, {p ...}]>

=== Finding Just One Element

If you're looking for a single element, the <tt>at</tt> method will return the
first element matched by the expression.  In this case, you'll get back the
element itself rather than the <tt>Hpricot::Elements</tt> array.

 doc.at("body")['onload']

The above code will find the body tag and give you back the <tt>onload</tt>
attribute.  This is the most common reason to use the element directly: when
reading and writing HTML attributes.

=== Fetching the Contents of an Element

Just as with browser scripting, the <tt>inner_html</tt> property can be used to
get the inner contents of an element.

 (doc/"#elementID").inner_html
 #=> "..<b>contents</b>.."

If your expression matches more than one element, you'll get back the contents
of ''all the matched elements''.  So you may want to use <tt>first</tt> to be
sure you get back only one.

 (doc/"#elementID").first.inner_html
 #=> "..<b>contents</b>.."

=== Fetching the HTML for an Element

If you want the HTML for the whole element (not just the contents), use
<tt>to_html</tt>:

 (doc/"#elementID").to_html
 #=> "<div id='elementID'>...</div>"

=== Looping

All searches return a set of <tt>Hpricot::Elements</tt>.  Go ahead and loop
through them like you would an array.

 (doc/"p/a/img").each do |img|
   puts img.attributes['class']
 end

=== Continuing Searches

Searches can be continued from a collection of elements, in order to search deeper.

 # find all paragraphs.
 elements = doc.search("/html/body//p")
 # continue the search by finding any images within those paragraphs.
 (elements/"img")
 #=> #<Hpricot::Elements[{img ...}, {img ...}]>

Searches can also be continued by searching within container elements.

 # find all images within paragraphs.
 doc.search("/html/body//p").each do |para|
   puts "== Found a paragraph =="
   pp para

   imgs = para.search("img")
   if imgs.any?
     puts "== Found #{imgs.length} images inside =="
   end
 end

Of course, the most succinct ways to do the above are using CSS or XPath.

 # the xpath version
 (doc/"/html/body//p//img")
 # the css version
 (doc/"html > body > p img")
 # ..or symbols work, too!
 (doc/:html/:body/:p/:img)

=== Looping Edits

You may certainly edit objects from within your search loops.  Then, when you
spit out the HTML, the altered elements will show.

 (doc/"span.entryPermalink").each do |span|
   span.attributes['class'] = 'newLinks'
 end
 puts doc

This changes all <tt>span.entryPermalink</tt> elements to
<tt>span.newLinks</tt>.  Keep in mind that there are often more convenient ways
of doing this.  Such as the <tt>set</tt> method:

 (doc/"span.entryPermalink").set(:class => 'newLinks')

=== Figuring Out Paths

Every element can tell you its unique path (either XPath or CSS) to get to the
element from the root tag.

The <tt>css_path</tt> method:

 doc.at("div > div:nth(1)").css_path
   #=> "div > div:nth(1)" 
 doc.at("#header").css_path
   #=> "#header" 

Or, the <tt>xpath</tt> method:

 doc.at("div > div:nth(1)").xpath
   #=> "/div/div:eq(1)" 
 doc.at("#header").xpath
   #=> "//div[@id='header']" 

== Hpricot Fixups

When loading HTML documents, you have a few settings that can make Hpricot more
or less intense about how it gets involved.

== :fixup_tags

Really, there are so many ways to clean up HTML and your intentions may be to
keep the HTML as-is.  So Hpricot's default behavior is to keep things flexible.
Making sure to open and close all the tags, but ignore any validation problems.

As of Hpricot 0.4, there's a new <tt>:fixup_tags</tt> option which will attempt
to shift the document's tags to meet XHTML 1.0 Strict.

 doc = open("index.html") { |f| Hpricot f, :fixup_tags => true }

This doesn't quite meet the XHTML 1.0 Strict standard, it just tries to follow
the rules a bit better.  Like: say Hpricot finds a paragraph in a link, it's
going to move the paragraph below the link.  Or up and out of other elements
where paragraphs don't belong.

If an unknown element is found, it is ignored.  Again, <tt>:fixup_tags</tt>.

== :xhtml_strict

So, let's go beyond just trying to fix the hierarchy.  The
<tt>:xhtml_strict</tt> option really tries to force the document to be an XHTML
1.0 Strict document.  Even at the cost of removing elements that get in the way.

 doc = open("index.html") { |f| Hpricot f, :xhtml_strict => true }

What measures does <tt>:xhtml_strict</tt> take?

 1. Shift elements into their proper containers just like :fixup_tags.
 2. Remove unknown elements.
 3. Remove unknown attributes.
 4. Remove illegal content.
 5. Alter the doctype to XHTML 1.0 Strict.

== Hpricot.XML()

The last option is the <tt>:xml</tt> option, which makes some slight variations
on the standard mode.  The main difference is that :xml mode won't try to output
tags which are friendlier for browsers.  For example, if an opening and closing
<tt>br</tt> tag is found, XML mode won't try to turn that into an empty element.

XML mode also doesn't downcase the tags and attributes for you.  So pay attention
to case, friends.

The primary way to use Hpricot's XML mode is to call the Hpricot.XML method:

 doc = open("http://redhanded.hobix.com/index.xml") do |f|
   Hpricot.XML(f)
 end

*Also, :fixup_tags is canceled out by the :xml option.*  This is because
:fixup_tags makes assumptions based how HTML is structured.  Specifically, how
tags are defined in the XHTML 1.0 DTD.
