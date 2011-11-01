class Refinerycms<%= class_name.pluralize %> < Refinery::Generators::EngineInstaller

  source_root File.expand_path('../../', __FILE__)
  engine_name "<%= plural_name %>"

end
