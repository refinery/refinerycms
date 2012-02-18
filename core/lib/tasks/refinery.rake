namespace :refinery do
  desc "Override files for use in an application"
  task :override => :environment do
    Refinery::CLI.new.override(ENV)
  end

  desc "Un-crudify a method on a controller that uses crudify"
  task :uncrudify => :environment do
    unless (controller_name = ENV["controller"]).present? and (action = ENV["action"]).present?
      abort <<-HELPDOC.strip_heredoc
        You didn't specify anything to uncrudify. Here's some examples:
        rake refinery:uncrudify controller=refinery/admin/pages action=create
        rake refinery:uncrudify controller=products action=new
      HELPDOC
    end

    controller_class_name = "#{controller_name}_controller".classify
    begin
      controller_class = controller_class_name.constantize
    rescue NameError
      abort "#{controller_class_name} is not defined"
    end

    crud_lines = Refinery.roots(:'refinery/core').join('lib', 'refinery', 'crud.rb').read
    if (matches = crud_lines.scan(/(\ +)(def #{action}.+?protected)/m).first).present? and
       (method_lines = "#{matches.last.split(%r{^#{matches.first}end}).first.strip}\nend".split("\n")).many?
      indent = method_lines.second.index(%r{[^ ]})
      crud_method = method_lines.join("\n").gsub(/^#{" " * indent}/, "  ")

      crud_options = controller_class.try(:crudify_options) || {}
      crud_method.gsub!('#{options[:redirect_to_url]}', crud_options[:redirect_to_url].to_s)
      crud_method.gsub!('#{options[:conditions].inspect}', crud_options[:conditions].inspect)
      crud_method.gsub!('#{options[:title_attribute]}', crud_options[:title_attribute])
      crud_method.gsub!('#{singular_name}', crud_options[:singular_name])
      crud_method.gsub!('#{class_name}', crud_options[:class_name])
      crud_method.gsub!('#{plural_name}', crud_options[:plural_name])
      crud_method.gsub!('\\#{', '#{')

      puts crud_method
    end
  end

end

desc "Recalculate $LOAD_PATH frequencies."
task :recalculate_loaded_features_frequency => :environment do
  require 'refinery/load_path_analyzer'

  frequencies     = LoadPathAnalyzer.new($LOAD_PATH, $LOADED_FEATURES).frequencies
  ideal_load_path = frequencies.to_a.sort_by(&:last).map(&:first)

  Rails.root.join('config', 'ideal_load_path').open("w") do |f|
    f.puts ideal_load_path
  end
end
