module ActiveRecord
  module ModelTranslations
    module ClassMethods
      def translates(*attributes)
        add_translation_model_and_logic unless included_modules.include?(InstanceMethods)
        add_translatable_attributes(attributes)
      end

      private
      def add_translation_model_and_logic
        type = self.to_s.underscore
        translation_class_name = "#{self.to_s}Translation"
        translation_class = Class.new(ActiveRecord::Base) { belongs_to type.to_sym }
        Object.const_set(translation_class_name, translation_class)

        include InstanceMethods

        has_many :model_translations, :class_name => translation_class_name, :dependent => :delete_all , :order => 'created_at desc'
        after_save :update_translations!
      end

      def add_translatable_attributes(attributes)
        attributes = attributes.collect{ |attribute| attribute.to_sym }
        attributes.each do |attribute|
          define_method "#{attribute}=" do |value|
            translated_attributes[attribute] = value
          end

          define_method attribute do
            return translated_attributes[attribute] if translated_attributes[attribute]
            return nil if new_record?

            translation = model_translations.detect { |t| t.locale == I18n.locale.to_s } ||
                          model_translations.detect { |t| t.locale == I18n.default_locale.to_s } ||
                          model_translations.first
            translation ? translation[attribute] : nil
          end
        end
      end
    end

    module InstanceMethods
      def translated_attributes
        @translated_attributes ||= {}
      end

      def update_translations!
        return if translated_attributes.blank?
        translation = model_translations.find_or_initialize_by_locale(I18n.locale.to_s)
        translation.attributes = translation.attributes.merge(translated_attributes)
        translation.save!
      end
    end
  end
end
