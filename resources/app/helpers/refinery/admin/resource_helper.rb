module Refinery
  module Admin
    module ResourceHelper

      def resource_meta_information(resource)
        tag.span number_to_human_size(resource.size), class: [:label, :meta]
      end
    end
  end
end
