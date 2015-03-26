class MigratePagePartNames < ActiveRecord::Migration
  def up
    Refinery::PagePart.where(:title => 'Body').each do |pp|
      pp.title = 'Content0';
      pp.save;
    end
  end

  def down
    Refinery::PagePart.where(:title => 'Content0').each do |pp|
      pp.title = 'Body';
      pp.save;
    end
  end
end
