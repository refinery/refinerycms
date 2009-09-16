class ResaveRefinerySettingsThroughSerializer < ActiveRecord::Migration
  def self.up
		RefinerySetting.all.each do |rs|
			rs.update_attribute(:value, rs[:value])
		end
  end

  def self.down
		RefinerySetting.all.each do |rs|
			rs.update_attribute(:value, rs[:value])
		end
  end
end
