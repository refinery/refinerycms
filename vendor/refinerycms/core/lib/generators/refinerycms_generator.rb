require 'fileutils'

class RefinerycmsGenerator < ::Refinery::Generators::EngineInstaller

  engine_name :refinerycms
  source_root Refinery.root

  def generate
    # First, rename files that get in the way of Refinery CMS
    ['public/index.html', 'app/views/layouts/application.html.erb', 'db/seeds.rb'].each do |roadblock|
      if (roadblock = Rails.root.join(roadblock)).file?
        rename_to = roadblock.to_s.gsub(roadblock.split.last.to_s, "your_#{roadblock.split.last}")
        FileUtils::mv roadblock, rename_to
        puts "Renamed #{roadblock.to_s.split("#{Rails.root}/").last} to #{rename_to.to_s.split("#{Rails.root}/").last}"
      end
    end

    super
  end

end
