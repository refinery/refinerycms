Gem::Specification.new do |s|
  s.name = %q{hpricot}
  s.version = "0.8"
 
  s.authors = ["why the lucky stiff"]
  s.date = %q{2009-03-23}
  s.description = %q{a swift, liberal HTML parser with a fantastic library}
  s.email = %q{why@ruby-lang.org}
  s.extensions = ["ext/fast_xs/extconf.rb", "ext/hpricot_scan/extconf.rb"]
  s.extra_rdoc_files = ["README", "CHANGELOG", "COPYING"]
  s.files = ["CHANGELOG", "COPYING", "README", "Rakefile", "test/files", "test/files/basic.xhtml", "test/files/boingboing.html", "test/files/cy0.html", "test/files/immob.html", "test/files/pace_application.html", "test/files/tenderlove.html", "test/files/uswebgen.html", "test/files/utf8.html", "test/files/week9.html", "test/files/why.xml", "test/load_files.rb", "test/test_alter.rb", "test/test_builder.rb", "test/test_parser.rb", "test/test_paths.rb", "test/test_preserved.rb", "test/test_xml.rb", "lib/hpricot", "lib/hpricot/blankslate.rb", "lib/hpricot/builder.rb", "lib/hpricot/elements.rb", "lib/hpricot/htmlinfo.rb", "lib/hpricot/inspect.rb", "lib/hpricot/modules.rb", "lib/hpricot/parse.rb", "lib/hpricot/tag.rb", "lib/hpricot/tags.rb", "lib/hpricot/traverse.rb", "lib/hpricot/xchar.rb", "lib/hpricot.rb", "extras/mingw-rbconfig.rb", "ext/hpricot_scan/hpricot_scan.h", "ext/fast_xs/FastXsService.java", "ext/hpricot_scan/HpricotScanService.java", "ext/fast_xs/fast_xs.c", "ext/hpricot_scan/hpricot_scan.c", "ext/hpricot_scan/hpricot_css.c", "ext/fast_xs/extconf.rb", "ext/hpricot_scan/extconf.rb", "ext/hpricot_scan/hpricot_common.rl", "ext/hpricot_scan/hpricot_scan.java.rl", "ext/hpricot_scan/hpricot_scan.rl"]
  s.has_rdoc = true
  s.homepage = %q{http://wiki.github.com/hpricot/hpricot}
  s.rdoc_options = ["--quiet", "--title", "The Hpricot Reference", "--main", "README", "--inline-source"]
  s.require_paths = ["lib"]
  s.summary = %q{a swift, liberal HTML parser with a fantastic library}
end
