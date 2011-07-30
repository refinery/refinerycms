# TODO: remove this monkeypatch as soon as
# https://github.com/markevans/dragonfly/pull/99 gets merged in
# and new version of dragonfly gets released.
module Dragonfly
  module ActiveModelExtensions
    class Attachment
      alias_method :length, :size
    end
  end
end
