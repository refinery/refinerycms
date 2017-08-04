class TranslateRefineryImages < ActiveRecord::Migration[4.2]
  def self.up
    begin
      ::Refinery::Image.create_translation_table!({
        image_alt: :string,
        image_title: :string
      }, {
        :migrate_data => true
      })
    rescue NameError
      warn "Refinery::Image was not defined!"
    end
  end

  def self.down
    begin
      Refinery::Image.drop_translation_table! migrate_data: true
    rescue NameError
      warn "Refinery::Image was not defined!"
    end
  end
end