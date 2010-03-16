#!/usr/bin/env ruby
require 'rubygems'
require 'open-uri'
require 'hpricot'
require 'nokogiri'
require 'benchmark'

content = File.read("test/files/boingboing.html")

N = 100

unless Gem.loaded_specs['hpricot'].version > Gem::Version.new('0.6.161')
  abort "** Use higher than Hpricot 0.6.161!"
end

puts "Hpricot #{Gem.loaded_specs['hpricot'].version} vs. Nokogiri #{Gem.loaded_specs['nokogiri'].version}"
hdoc = Hpricot(content)
ndoc = Nokogiri.Hpricot(content)

Benchmark.bm do |x|
  x.report('hpricot:doc') do
    N.times do
      Hpricot(content)
    end
  end

  x.report('nokogiri:doc') do
    N.times do
      Nokogiri.Hpricot(content)
    end
  end
end

Benchmark.bm do |x|
  x.report('hpricot:xpath') do
    N.times do
      info = hdoc.search("//a[@name='027906']").first.inner_text
      url = hdoc.search("h3[text()='College kids reportedly taking more smart drugs']").first.inner_text
    end
  end

  x.report('nokogiri:xpath') do
    N.times do
      info = ndoc.search("//a[@name='027906']").first.inner_text
      url = ndoc.search("h3[text()='College kids reportedly taking more smart drugs']").first.inner_text
    end
  end
end

Benchmark.bm do |x|
  x.report('hpricot:css') do
    N.times do
      info = hdoc.search('form input[@checked]').first
      url = hdoc.search('td spacer').first.inner_text
    end
  end

  x.report('nokogiri:css') do
    N.times do
      info = ndoc.search('form input[@checked]').first
      url = ndoc.search('td spacer').first.inner_text
    end
  end
end
