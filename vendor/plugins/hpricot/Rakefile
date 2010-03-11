require 'rake'
require 'rake/clean'
require 'rake/gempackagetask'
require 'rake/rdoctask'
require 'rake/testtask'
require 'fileutils'
include FileUtils

RbConfig = Config unless defined?(RbConfig)

NAME = "hpricot"
REV = (`#{ENV['GIT'] || "git"} rev-list HEAD`.split.length + 1).to_s
VERS = ENV['VERSION'] || "0.8" + (REV ? ".#{REV}" : "")
PKG = "#{NAME}-#{VERS}"
BIN = "*.{bundle,jar,so,o,obj,pdb,lib,def,exp,class}"
CLEAN.include ["ext/hpricot_scan/#{BIN}", "ext/fast_xs/#{BIN}", "lib/**/#{BIN}",
               'ext/fast_xs/Makefile', 'ext/hpricot_scan/Makefile',
               '**/.*.sw?', '*.gem', '.config', 'pkg']
RDOC_OPTS = ['--quiet', '--title', 'The Hpricot Reference', '--main', 'README', '--inline-source']
PKG_FILES = %w(CHANGELOG COPYING README Rakefile) +
      Dir.glob("{bin,doc,test,lib,extras}/**/*") +
      Dir.glob("ext/**/*.{h,java,c,rb,rl}") +
      %w[ext/hpricot_scan/hpricot_scan.c ext/hpricot_scan/hpricot_css.c ext/hpricot_scan/HpricotScanService.java] # needed because they are generated later
RAGEL_C_CODE_GENERATION_STYLES = {
  "table_driven" => 'T0',
  "faster_table_driven" => 'T1',
  "flat_table_driven" => 'F0',
  "faster_flat_table_driven" => 'F1',
  "goto_driven" => 'G0',
  "faster_goto_driven" => 'G1',
  "really_fast goto_driven" => 'G2'
  # "n_way_split_really_fast_goto_driven" => 'P<N>'
}
DEFAULT_RAGEL_C_CODE_GENERATION = "really_fast goto_driven"
SPEC =
  Gem::Specification.new do |s|
    s.name = NAME
    s.version = VERS
    s.platform = Gem::Platform::RUBY
    s.has_rdoc = true
    s.rdoc_options += RDOC_OPTS
    s.extra_rdoc_files = ["README", "CHANGELOG", "COPYING"]
    s.summary = "a swift, liberal HTML parser with a fantastic library"
    s.description = s.summary
    s.author = "why the lucky stiff"
    s.email = 'why@ruby-lang.org'
    s.homepage = 'http://code.whytheluckystiff.net/hpricot/'
    s.rubyforge_project = 'hobix'
    s.files = PKG_FILES
    s.require_paths = ["lib"]
    s.extensions = FileList["ext/**/extconf.rb"].to_a
    s.bindir = "bin"
  end

Win32Spec = SPEC.dup
Win32Spec.platform = 'x86-mswin32'
Win32Spec.files = PKG_FILES + ["lib/hpricot_scan.so", "lib/fast_xs.so"]
Win32Spec.extensions = []

WIN32_PKG_DIR = "#{PKG}-mswin32"

desc "Does a full compile, test run"
if defined?(JRUBY_VERSION)
task :default => [:compile_java, :test]
else
task :default => [:compile, :test]
end

desc "Packages up Hpricot."
task :package => [:clean, :ragel]

desc "Releases packages for all Hpricot packages and platforms."
task :release => [:package, :package_win32, :package_jruby]


desc "Run all the tests"
Rake::TestTask.new do |t|
    t.libs << "test"
    t.test_files = FileList['test/test_*.rb']
    t.verbose = true
end

Rake::RDocTask.new do |rdoc|
    rdoc.rdoc_dir = 'doc/rdoc'
    rdoc.options += RDOC_OPTS
    rdoc.main = "README"
    rdoc.rdoc_files.add ['README', 'CHANGELOG', 'COPYING', 'lib/**/*.rb']
end

Rake::GemPackageTask.new(SPEC) do |p|
    p.need_tar = true
    p.gem_spec = SPEC
end

['hpricot_scan', 'fast_xs'].each do |extension|
  ext = "ext/#{extension}"
  ext_so = "#{ext}/#{extension}.#{Config::CONFIG['DLEXT']}"
  ext_files = FileList[
    "#{ext}/*.c",
    "#{ext}/*.h",
    "#{ext}/*.rl",
    "#{ext}/extconf.rb",
    "#{ext}/Makefile",
    "lib"
  ]

  desc "Builds just the #{extension} extension"
  task extension.to_sym => [:ragel, "#{ext}/Makefile", ext_so ]

  file "#{ext}/Makefile" => ["#{ext}/extconf.rb"] do
    Dir.chdir(ext) do ruby "extconf.rb" end
  end

  file ext_so => ext_files do
    Dir.chdir(ext) do
      sh(RUBY_PLATFORM =~ /mswin/ ? 'nmake' : 'make')
    end
    cp ext_so, "lib"
  end

  desc "Cross-compile the #{extension} extension for win32"
  file "#{extension}_win32" => [WIN32_PKG_DIR] do
    cp "extras/mingw-rbconfig.rb", "#{WIN32_PKG_DIR}/ext/#{extension}/rbconfig.rb"
    sh "cd #{WIN32_PKG_DIR}/ext/#{extension}/ && ruby -I. extconf.rb && make"
    mv "#{WIN32_PKG_DIR}/ext/#{extension}/#{extension}.so", "#{WIN32_PKG_DIR}/lib"
  end
end

task "lib" do
  directory "lib"
end

desc "Compiles the Ruby extension"
task :compile => [:hpricot_scan, :fast_xs] do
  if Dir.glob(File.join("lib","hpricot_scan.*")).length == 0
    STDERR.puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    STDERR.puts "Gem actually failed to build.  Your system is"
    STDERR.puts "NOT configured properly to build hpricot."
    STDERR.puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    exit(1)
  end
end

desc "Determines the Ragel version and displays it on the console along with the location of the Ragel binary."
task :ragel_version do
  @ragel_v = `ragel -v`[/(version )(\S*)/,2].to_f
  puts "Using ragel version: #{@ragel_v}, location: #{`which ragel`}"
  @ragel_v
end

desc "Generates the C scanner code with Ragel."
task :ragel => [:ragel_version] do
  if @ragel_v >= 6.1
    @ragel_c_code_generation_style = RAGEL_C_CODE_GENERATION_STYLES[DEFAULT_RAGEL_C_CODE_GENERATION]
    Dir.chdir("ext/hpricot_scan") do
      sh %{ragel hpricot_scan.rl -#{@ragel_c_code_generation_style} -o hpricot_scan.c}
      sh %{ragel hpricot_css.rl -#{@ragel_c_code_generation_style} -o hpricot_css.c}
    end
  else
    STDERR.puts "Ragel 6.1 or greater is required."
    exit(1)
  end
end

# Java only supports the table-driven code
# generation style at this point.
desc "Generates the Java scanner code using the Ragel table-driven code generation style."
task :ragel_java => [:ragel_version] do
  if @ragel_v >= 6.1
    puts "compiling with ragel version #{@ragel_v}"
    Dir.chdir("ext/hpricot_scan") do
      sh %{ragel -J -o HpricotCss.java hpricot_css.java.rl}
      sh %{ragel -J -o HpricotScanService.java hpricot_scan.java.rl}
    end
  else
    STDERR.puts "Ragel 6.1 or greater is required."
    exit(1)
  end
end

### Win32 Packages ###

desc "Package up the Win32 distribution."
file WIN32_PKG_DIR => [:package] do
  sh "tar zxf pkg/#{PKG}.tgz"
  mv PKG, WIN32_PKG_DIR
end

desc "Build the binary RubyGems package for win32"
task :package_win32 => ["fast_xs_win32", "hpricot_scan_win32"] do
  Dir.chdir("#{WIN32_PKG_DIR}") do
    Gem::Builder.new(Win32Spec).build
    verbose(true) {
      mv Dir["*.gem"].first, "../pkg/"
    }
  end
end

CLEAN.include WIN32_PKG_DIR

### JRuby Packages ###

def java_classpath_arg # myriad of ways to discover JRuby classpath
  begin
    cpath  = Java::java.lang.System.getProperty('java.class.path').split(File::PATH_SEPARATOR)
    cpath += Java::java.lang.System.getProperty('sun.boot.class.path').split(File::PATH_SEPARATOR)
    jruby_cpath = cpath.compact.join(File::PATH_SEPARATOR)
  rescue => e
  end
  unless jruby_cpath
    jruby_cpath = ENV['JRUBY_PARENT_CLASSPATH'] || ENV['JRUBY_HOME'] &&
      FileList["#{ENV['JRUBY_HOME']}/lib/*.jar"].join(File::PATH_SEPARATOR)
  end
  jruby_cpath ? "-cp \"#{jruby_cpath}\"" : ""
end

def compile_java(filenames, jarname)
  sh %{javac -source 1.5 -target 1.5 #{java_classpath_arg} #{filenames.join(" ")}}
  sh %{jar cf #{jarname} *.class}
end

task :hpricot_scan_java => [:ragel_java] do
  Dir.chdir "ext/hpricot_scan" do
    compile_java(["HpricotScanService.java", "HpricotCss.java"], "hpricot_scan.jar")
  end
end

task :fast_xs_java do
  Dir.chdir "ext/fast_xs" do
    compile_java(["FastXsService.java"], "fast_xs.jar")
  end
end

desc "Compiles the JRuby extensions"
task :compile_java => [:hpricot_scan_java, :fast_xs_java] do
  %w(hpricot_scan fast_xs).each {|ext| mv "ext/#{ext}/#{ext}.jar", "lib"}
end

JRubySpec = SPEC.dup
JRubySpec.platform = 'java'
JRubySpec.files = PKG_FILES + ["lib/hpricot_scan.jar", "lib/fast_xs.jar"]
JRubySpec.extensions = []

JRUBY_PKG_DIR = "#{PKG}-java"

desc "Package up the JRuby distribution."
file JRUBY_PKG_DIR => [:ragel_java, :package] do
  sh "tar zxf pkg/#{PKG}.tgz"
  mv PKG, JRUBY_PKG_DIR
end

desc "Build the RubyGems package for JRuby"
task :package_jruby => JRUBY_PKG_DIR do
  Dir.chdir("#{JRUBY_PKG_DIR}") do
    Rake::Task[:compile_java].invoke
    Gem::Builder.new(JRubySpec).build
    verbose(true) {
      mv Dir["*.gem"].first, "../pkg/#{JRUBY_PKG_DIR}.gem"
    }
  end
end

CLEAN.include JRUBY_PKG_DIR

task :install do
  sh %{rake package}
  sh %{sudo gem install pkg/#{NAME}-#{VERS}}
end

task :uninstall => [:clean] do
  sh %{sudo gem uninstall #{NAME}}
end
