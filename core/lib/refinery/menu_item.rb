module Refinery
  class MenuItem < HashWithIndifferentAccess

    (ATTRIBUTES = [:title, :parent_id, :lft, :rgt, :url, :menu_match]).each do |attribute|  
      class_eval %{
        def #{attribute}
          @#{attribute} ||= self[:#{attribute}]
        end
        
        def #{attribute}=(attr)
          @#{attribute} = attr
        end
      }
    end

    def inspect
      ATTRIBUTES.inject({}) do |hash, attribute| 
        hash[attribute] = self[attribute]
      end
    end

  end
end