module Refinery
  class TranslatedFieldPresenter
    def initialize(record)
      @record = record
    end

    def call(field)
      record.send(field).presence ||
        record.translations.detect {|t| t.send(field).present?}.send(field)
    end

    private
    attr_accessor :record
  end
end