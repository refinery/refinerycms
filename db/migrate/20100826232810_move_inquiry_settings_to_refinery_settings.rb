class MoveInquirySettingsToRefinerySettings < ActiveRecord::Migration
  def self.up
    if defined?(InquirySetting)
      InquirySetting.all.each do |inquiry_setting|
        RefinerySetting.set(:"inquiry_#{inquiry_setting.name.downcase.gsub(' ', '_')}", {
          :value => inquiry_setting.value,
          :destroyable => false
        })

      end
    end
  end

  def self.down
    if defined?(InquirySetting)
      RefinerySetting.find(:all, :conditions => "name LIKE 'inquiry_%'").each do |rs|
        InquirySetting.create(:name => rs.name.to_s.gsub('inquiry_', '').titleize,
                              :value => rs.value,
                              :destroyable => false)
      end
    end
  end
end
