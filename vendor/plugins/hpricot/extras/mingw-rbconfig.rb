
# This rbconfig.rb corresponds to a Ruby installation for win32 cross-compiled
# with mingw under i686-linux. It can be used to cross-compile extensions for
# win32 using said toolchain.
# 
# This file assumes that a cross-compiled mingw32 build (compatible with the
# mswin32 builds) is installed under $HOME/ruby-mingw32.

module Config
  #RUBY_VERSION == "1.8.5" or
  #  raise "ruby lib version (1.8.5) doesn't match executable version (#{RUBY_VERSION})"

  mingw32 = ENV['MINGW32_RUBY'] || "#{ENV["HOME"]}/ruby-mingw32"
  mingwpre = ENV['MINGW32_PREFIX']
  TOPDIR = File.dirname(__FILE__).chomp!("/lib/ruby/1.8/i386-mingw32")
  DESTDIR = '' unless defined? DESTDIR
  CONFIG = {}
  CONFIG["DESTDIR"] = DESTDIR
  CONFIG["INSTALL"] = "/usr/bin/install -c"
  CONFIG["prefix"] = (TOPDIR || DESTDIR + mingw32)
  CONFIG["EXEEXT"] = ".exe"
  CONFIG["ruby_install_name"] = "ruby"
  CONFIG["RUBY_INSTALL_NAME"] = "ruby"
  CONFIG["RUBY_SO_NAME"] = "msvcrt-ruby18"
  CONFIG["SHELL"] = "/bin/sh"
  CONFIG["PATH_SEPARATOR"] = ":"
  CONFIG["PACKAGE_NAME"] = ""
  CONFIG["PACKAGE_TARNAME"] = ""
  CONFIG["PACKAGE_VERSION"] = ""
  CONFIG["PACKAGE_STRING"] = ""
  CONFIG["PACKAGE_BUGREPORT"] = ""
  CONFIG["exec_prefix"] = "$(prefix)"
  CONFIG["bindir"] = "$(exec_prefix)/bin"
  CONFIG["sbindir"] = "$(exec_prefix)/sbin"
  CONFIG["libexecdir"] = "$(exec_prefix)/libexec"
  CONFIG["datadir"] = "$(prefix)/share"
  CONFIG["sysconfdir"] = "$(prefix)/etc"
  CONFIG["sharedstatedir"] = "$(prefix)/com"
  CONFIG["localstatedir"] = "$(prefix)/var"
  CONFIG["libdir"] = "$(exec_prefix)/lib"
  CONFIG["includedir"] = "$(prefix)/include"
  CONFIG["oldincludedir"] = "/usr/include"
  CONFIG["infodir"] = "$(prefix)/info"
  CONFIG["mandir"] = "$(prefix)/man"
  CONFIG["build_alias"] = "i686-linux"
  CONFIG["host_alias"] = "#{mingwpre}"
  CONFIG["target_alias"] = "i386-mingw32"
  CONFIG["ECHO_C"] = ""
  CONFIG["ECHO_N"] = "-n"
  CONFIG["ECHO_T"] = ""
  CONFIG["LIBS"] = "-lwsock32 "
  CONFIG["MAJOR"] = "1"
  CONFIG["MINOR"] = "8"
  CONFIG["TEENY"] = "4"
  CONFIG["build"] = "i686-pc-linux"
  CONFIG["build_cpu"] = "i686"
  CONFIG["build_vendor"] = "pc"
  CONFIG["build_os"] = "linux"
  CONFIG["host"] = "i586-pc-mingw32msvc"
  CONFIG["host_cpu"] = "i586"
  CONFIG["host_vendor"] = "pc"
  CONFIG["host_os"] = "mingw32msvc"
  CONFIG["target"] = "i386-pc-mingw32"
  CONFIG["target_cpu"] = "i386"
  CONFIG["target_vendor"] = "pc"
  CONFIG["target_os"] = "mingw32"
  CONFIG["CC"] = "#{mingwpre}-gcc"
  CONFIG["CFLAGS"] = "-g -O2 "
  CONFIG["LDFLAGS"] = ""
  CONFIG["CPPFLAGS"] = ""
  CONFIG["OBJEXT"] = "o"
  CONFIG["CPP"] = "#{mingwpre}-gcc -E"
  CONFIG["EGREP"] = "grep -E"
  CONFIG["GNU_LD"] = "yes"
  CONFIG["CPPOUTFILE"] = "-o conftest.i"
  CONFIG["OUTFLAG"] = "-o "
  CONFIG["YACC"] = "bison -y"
  CONFIG["RANLIB"] = "#{mingwpre}-ranlib"
  CONFIG["AR"] = "#{mingwpre}-ar"
  CONFIG["NM"] = "#{mingwpre}-nm"
  CONFIG["WINDRES"] = "#{mingwpre}-windres"
  CONFIG["DLLWRAP"] = "#{mingwpre}-dllwrap"
  CONFIG["OBJDUMP"] = "#{mingwpre}-objdump"
  CONFIG["LN_S"] = "ln -s"
  CONFIG["SET_MAKE"] = ""
  CONFIG["INSTALL_PROGRAM"] = "$(INSTALL)"
  CONFIG["INSTALL_SCRIPT"] = "$(INSTALL)"
  CONFIG["INSTALL_DATA"] = "$(INSTALL) -m 644"
  CONFIG["RM"] = "rm -f"
  CONFIG["CP"] = "cp"
  CONFIG["MAKEDIRS"] = "mkdir -p"
  CONFIG["LIBOBJS"] = " fileblocks$(U).o crypt$(U).o flock$(U).o acosh$(U).o win32$(U).o"
  CONFIG["ALLOCA"] = ""
  CONFIG["DLDFLAGS"] = " -Wl,--enable-auto-import,--export-all"
  CONFIG["ARCH_FLAG"] = ""
  CONFIG["STATIC"] = ""
  CONFIG["CCDLFLAGS"] = ""
  CONFIG["LDSHARED"] = "#{mingwpre}-gcc -shared -s"
  CONFIG["DLEXT"] = "so"
  CONFIG["DLEXT2"] = "dll"
  CONFIG["LIBEXT"] = "a"
  CONFIG["LINK_SO"] = ""
  CONFIG["LIBPATHFLAG"] = " -L\"%s\""
  CONFIG["RPATHFLAG"] = ""
  CONFIG["LIBPATHENV"] = ""
  CONFIG["TRY_LINK"] = ""
  CONFIG["STRIP"] = "strip"
  CONFIG["EXTSTATIC"] = ""
  CONFIG["setup"] = "Setup"
  CONFIG["MINIRUBY"] = "ruby -rfake"
  CONFIG["PREP"] = "fake.rb"
  CONFIG["RUNRUBY"] = "$(MINIRUBY) -I`cd $(srcdir)/lib; pwd`"
  CONFIG["EXTOUT"] = ".ext"
  CONFIG["ARCHFILE"] = ""
  CONFIG["RDOCTARGET"] = ""
  CONFIG["XCFLAGS"] = " -DRUBY_EXPORT"
  CONFIG["XLDFLAGS"] = " -Wl,--stack,0x02000000 -L."
  CONFIG["LIBRUBY_LDSHARED"] = "#{mingwpre}-gcc -shared -s"
  CONFIG["LIBRUBY_DLDFLAGS"] = " -Wl,--enable-auto-import,--export-all -Wl,--out-implib=$(LIBRUBY)"
  CONFIG["rubyw_install_name"] = "rubyw"
  CONFIG["RUBYW_INSTALL_NAME"] = "rubyw"
  CONFIG["LIBRUBY_A"] = "lib$(RUBY_SO_NAME)-static.a"
  CONFIG["LIBRUBY_SO"] = "$(RUBY_SO_NAME).dll"
  CONFIG["LIBRUBY_ALIASES"] = ""
  CONFIG["LIBRUBY"] = "lib$(LIBRUBY_SO).a"
  CONFIG["LIBRUBYARG"] = "$(LIBRUBYARG_SHARED)"
  CONFIG["LIBRUBYARG_STATIC"] = "-l$(RUBY_SO_NAME)-static"
  CONFIG["LIBRUBYARG_SHARED"] = "-l$(RUBY_SO_NAME)"
  CONFIG["SOLIBS"] = "$(LIBS)"
  CONFIG["DLDLIBS"] = ""
  CONFIG["ENABLE_SHARED"] = "yes"
  CONFIG["MAINLIBS"] = ""
  CONFIG["COMMON_LIBS"] = "m"
  CONFIG["COMMON_MACROS"] = ""
  CONFIG["COMMON_HEADERS"] = "windows.h winsock.h"
  CONFIG["EXPORT_PREFIX"] = ""
  CONFIG["MINIOBJS"] = "dmydln.o"
  CONFIG["MAKEFILES"] = "Makefile GNUmakefile"
  CONFIG["arch"] = "i386-mingw32"
  CONFIG["sitearch"] = "i386-msvcrt"
  CONFIG["sitedir"] = "$(prefix)/lib/ruby/site_ruby"
  CONFIG["configure_args"] = "'--host=#{mingwpre}' '--target=i386-mingw32' '--build=i686-linux' '--prefix=#{mingw32}' 'build_alias=i686-linux' 'host_alias=#{mingwpre}' 'target_alias=i386-mingw32'"
  CONFIG["NROFF"] = "/usr/bin/nroff"
  CONFIG["MANTYPE"] = "doc"
  CONFIG["LTLIBOBJS"] = " fileblocks$(U).lo crypt$(U).lo flock$(U).lo acosh$(U).lo win32$(U).lo"
  CONFIG["ruby_version"] = "$(MAJOR).$(MINOR)"
  CONFIG["rubylibdir"] = "$(libdir)/ruby/$(ruby_version)"
  CONFIG["archdir"] = "$(rubylibdir)/$(arch)"
  CONFIG["sitelibdir"] = "$(sitedir)/$(ruby_version)"
  CONFIG["sitearchdir"] = "$(sitelibdir)/$(sitearch)"
  CONFIG["topdir"] = File.dirname(__FILE__)
  MAKEFILE_CONFIG = {}
  CONFIG.each{|k,v| MAKEFILE_CONFIG[k] = v.dup}
  def Config::expand(val, config = CONFIG)
    val.gsub!(/\$\$|\$\(([^()]+)\)|\$\{([^{}]+)\}/) do |var|
      if !(v = $1 || $2)
	'$'
      elsif key = config[v = v[/\A[^:]+(?=(?::(.*?)=(.*))?\z)/]]
	pat, sub = $1, $2
	config[v] = false
	Config::expand(key, config)
	config[v] = key
	key = key.gsub(/#{Regexp.quote(pat)}(?=\s|\z)/n) {sub} if pat
	key
      else
	var
      end
    end
    val
  end
  CONFIG.each_value do |val|
    Config::expand(val)
  end
end
RbConfig = Config # compatibility for ruby-1.9
CROSS_COMPILING = nil unless defined? CROSS_COMPILING
