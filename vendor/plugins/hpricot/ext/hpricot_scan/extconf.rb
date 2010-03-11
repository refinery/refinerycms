require 'mkmf'

dir_config("hpricot_scan")
have_library("c", "main")

create_makefile("hpricot_scan")
