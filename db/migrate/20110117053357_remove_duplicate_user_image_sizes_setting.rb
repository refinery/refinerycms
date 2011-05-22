class RemoveDuplicateUserImageSizesSetting < ActiveRecord::Migration
  def self.up
    if (settings = ::Refinery::Setting.where(:name => :user_image_sizes)).count > 1
      default_value = { :small => '110x110>', :medium => '225x255>', :large => '450x450>' }

      if (non_default_setting = settings.detect { |setting| setting[:value] != default_value })
        settings.detect { |setting| setting[:value] == default_value }.destroy
        non_default_setting[:destroyable] = false
        non_default_setting.save
      else
        settings.detect { |setting| setting[:destroyable] == true }.destroy
      end
      say "Removed duplicate user image sizes settings"
    else
      say "Nothing done, no duplicate settings found"
    end
  end

  def self.down
    # there is no step down ...
  end
end
