##
# Ensures presence of Rack::Cache to enable optional Dragonfly injection.
#
# Production Use
# ==============
#
# While ActiveSupport::Cache::MemoryStore is threadsafe, it won't share cache
# data between server processes. Disk storage will allow multiple processes to
# share cache state, while a distributed memory cache like memcached will allow
# multiple nodes to share it.
#
# Disk Storage
# ------------
# Disk Storage will grow until the disk is full unless you periodically delete
# old entries. Each cache should be configured with a different filesystem
# location to prevent collisions. Configuration example:
#
#     Rails.application.config.cache_store = :file_store, "#{Rails.root}/tmp/cache/rails"
#     Rails.application.config.action_dispatch.rack_cache = {
#       :metastore    => URI.encode("file:#{Rails.root}/tmp/cache/rack/meta"),
#       :entitystore  => URI.encode("file:#{Rails.root}/tmp/cache/rack/body"),
#       :allow_reload => false
#     }
#
# Memcached
# ---------
# In production a memcached instance may be configured to store the frequently-
# accessed MetaStore, which will reduce the overall latency of the cache. It is
# inadvisable to configure memcached as the EntityStore, since Rack::Cache may
# use this store for large objects. Dragonfly objects, for instance, will be
# cached in the EntityStore, whatever their size may be. Refinery::Images and
# Refinery::Resources both depend on Dragonfly.
#
# Example configuration of memcached and disk storage using the 'dalli' gem:
#
#     Rails.application.config.cache_store = :dalli_store
#     Rails.application.config.action_dispatch.rack_cache = {
#       :metastore    => Dalli::Client.new,
#       :entitystore  => URI.encode("file:#{Rails.root}/tmp/cache/rack/body"),
#       :allow_reload => false
#     }
#
module Refinery
  module Cache
    class << self
      ##
      # Injects the Rack::Cache middleware if it's not already loaded.
      def attach!(app)
        app.config.middleware.insert 0, 'Rack::Cache', {
          :verbose     => !::Rails.env.production?,
          :metastore   => default_metastore,
          :entitystore => default_entitystore
        } if insert_rack_cache_middleware?
      end

      ##
      # Avoid adding Rack::Cache twice since it's automatically enabled in
      # production by default as of Rails 3.1.
      def insert_rack_cache_middleware?
        not ::Rails.application.config.action_controller.perform_caching
      end

      ##
      # A sane default MetaStore for Rack::Cache.
      #
      # This is likely to be accessed frequently, so a low-latency cache store
      # is advised.
      def default_metastore
        ::Rails.application.config.action_dispatch.rack_cache[:metastore] rescue 'rails:/'
      end

      ##
      # A sane default EntityStore for Rack::Cache.
      #
      # This should definitely be larger than a single object expected
      # to be stored (by default Refinery::Resources may be up to 50MB).
      #
      # The Rack::Cache documentation suggests that disk storage is a good fit,
      # since the EntityStore can grow quite large, and it is not as sensitive
      # to latency as the MetaStore.
      def default_entitystore
        ::Rails.application.config.action_dispatch.rack_cache[:entitystore] rescue 'rails:/'
      end

      private :default_metastore, :default_entitystore,
              :insert_rack_cache_middleware?

    end
  end
end
