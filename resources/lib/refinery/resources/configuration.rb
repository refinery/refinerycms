# frozen_string_literal: true

module Refinery
  module Resources
    extend Refinery::Dragonfly::ExtensionConfiguration
    include ActiveSupport::Configurable

    config_accessor :max_file_size, :pages_per_dialog, :pages_per_admin_index,
                    :content_disposition, :whitelisted_mime_types

    self.content_disposition = :attachment
    self.max_file_size = 52_428_800
    self.pages_per_dialog = 12
    self.pages_per_admin_index = 20

    self.dragonfly_name = :refinery_resources

    self.whitelisted_mime_types = %w[
      audio/mp4
      audio/mpeg
      audio/wav
      audio/x-wav

      image/gif
      image/jpeg
      image/png
      image/svg+xml
      image/tiff
      image/x-psd

      video/mp4
      video/mpeg
      video/quicktime
      video/x-msvideo
      video/x-ms-wmv

      text/csv
      text/plain

      application/pdf
      application/rtf
      application/x-rar
      application/zip

      application/vnd.ms-excel
      application/vnd.ms-powerpoint
      application/vnd.msword

      application/vnd.openxmlformats-officedocument.presentationml.presentation
      application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
      application/vnd.openxmlformats-officedocument.wordprocessingml.document
    ]
  end
end