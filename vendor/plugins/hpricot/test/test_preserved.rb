# -*- coding: utf-8 -*-
#!/usr/bin/env ruby

require 'test/unit'
require 'hpricot'
require 'load_files'

unless "".respond_to?(:lines)
  require 'enumerator'
  class String
    def lines
      Enumerable::Enumerator.new(self, :each_line)
    end
  end
end

class TestPreserved < Test::Unit::TestCase
  def assert_roundtrip str
    doc = Hpricot(str)
    yield doc if block_given?
    str2 = doc.to_original_html
    if RUBY_VERSION =~ /^1.9/
      str2.force_encoding('UTF-8')
    end
    str.lines.zip(str2.lines).each do |s1, s2|
      assert_equal s1, s2
    end
  end

  def assert_html str1, str2
    doc = Hpricot(str2)
    yield doc if block_given?
    assert_equal str1, doc.to_original_html
  end

  def test_simple
    str = "<p>Hpricot is a <b>you know <i>uh</b> fine thing.</p>"
    assert_html str, str
    assert_html "<p class=\"new\">Hpricot is a <b>you know <i>uh</b> fine thing.</p>", str do |doc|
      (doc/:p).set('class', 'new')
    end
  end

  def test_parent
    str = "<html><base href='/'><head><title>Test</title></head><body><div id='wrap'><p>Paragraph one.</p><p>Paragraph two.</p></div></body></html>"
    assert_html str, str
    assert_html "<html><base href='/'><body><div id=\"all\"><div><p>Paragraph one.</p></div><div><p>Paragraph two.</p></div></div></body></html>", str do |doc|
      (doc/:head).remove
      (doc/:div).set('id', 'all')
      (doc/:p).wrap('<div></div>')
    end
  end

  def test_escaping_of_contents
    doc = Hpricot(TestFiles::BOINGBOING)
    assert_equal "Fukuda’s Automatic Door opens around your body as you pass through it. The idea is to save energy and keep the room clean.", doc.at("img[@alt='200606131240']").next.to_s.strip
  end

  def test_files
    assert_roundtrip TestFiles::BASIC
    assert_roundtrip TestFiles::BOINGBOING
    assert_roundtrip TestFiles::CY0
  end

  def test_fixup_link
    doc = %{<?xml version="1.0" encoding="UTF-8"?><rss><channel><link>ht</link></channel></rss>}
    assert_roundtrip doc
    assert_equal Hpricot(doc).to_s,
      %{<?xml version="1.0" encoding="UTF-8"?><rss><channel><link />ht</channel></rss>}
    assert_equal Hpricot.XML(doc).to_s,
      %{<?xml version="1.0" encoding="UTF-8"?><rss><channel><link>ht</link></channel></rss>}
  end

  def test_escaping_of_attrs
    # ampersands in URLs
    str = %{<a href="http://google.com/search?q=hpricot&amp;l=en">Google</a>}
    link = (doc = Hpricot(str)).at(:a)
    assert_equal "http://google.com/search?q=hpricot&l=en", link['href']
    assert_equal "http://google.com/search?q=hpricot&l=en", link.attributes['href']
    assert_equal "http://google.com/search?q=hpricot&l=en", link.get_attribute('href')
    assert_equal "http://google.com/search?q=hpricot&amp;l=en", link.raw_attributes['href']
    assert_equal str, doc.to_html

    # alter the url
    link['href'] = "javascript:alert(\"AGGA-KA-BOO!\")"
    assert_equal %{<a href="javascript:alert(&quot;AGGA-KA-BOO!&quot;)">Google</a>}, doc.to_html
  end
end
