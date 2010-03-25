# -*- coding: utf-8 -*-
#!/usr/bin/env ruby

require 'test/unit'
require 'hpricot'

class TestBuilder < Test::Unit::TestCase
  def test_escaping_text
    doc = Hpricot() { b "<a\"b>" }
    assert_equal "<b>&lt;a&quot;b&gt;</b>", doc.to_html
    assert_equal %{<a"b>}, doc.at("text()").to_s
  end

  def test_no_escaping_text
    doc = Hpricot() { div.test.me! { text "<a\"b>" } }
    assert_equal %{<div class="test" id="me"><a"b></div>}, doc.to_html
    assert_equal %{<a"b>}, doc.at("text()").to_s
  end

  def test_latin1_entities
    doc = Hpricot() { b "€•" }
    assert_equal "<b>&#8364;&#8226;</b>", doc.to_html
    assert_equal "€•", doc.at("text()").to_s
  end

  def test_escaping_attrs
    text = "<span style='font-family:\"MS Mincho\"'>Some text</span>"
    assert_equal "<span style=\"font-family:\\\"MS Mincho\\\"\">Some text</span>",
      Hpricot(text).to_html
  end

  def test_korean_utf8_entities
    a = '한글'
    doc = Hpricot() { b a }
    assert_equal "<b>&#54620;&#44544;</b>", doc.to_html
  end
end
