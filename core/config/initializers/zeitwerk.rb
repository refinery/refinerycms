# frozen_string_literal: true

class RefineryInflector < Zeitwerk::Inflector
  def camelize(basename, abspath)
    return 'Refinery' if basename.start_with?('refinerycms-')
    super
  end
end

Rails.autoloaders.each do |autoloader|
  autoloader.inflector = RefineryInflector.new
end
