class RefineryGenerator < Rails::Generator::NamedBase

  def banner
    puts "This generator has been renamed. Please this instead:"
    puts "ruby script/generate refinery_plugin"
    exit
  end

  def manifest
    banner
  end

end
