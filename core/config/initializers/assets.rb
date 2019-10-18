# frozen_string_literal: true

if Rails.application.config.respond_to?(:assets)
  Rails.application.config.assets.precompile << 'refinery_core_manifest.js'
end
