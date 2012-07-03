module Refinery
  module Admin
    module DashboardHelper

      def activity_message_for(record)
        return if (plugin = find_plugin(record)).blank? || (activity = find_activity(record, plugin)).blank?

        link_to t('.latest_activity_message',
                  :what => record.send(activity.title),
                  :kind => record.class.model_name.human,
                  :action => t("with_article \"#{plugin_article(plugin)}\"",
                               :scope => "refinery.#{record_action(record)}")
                 ).downcase.capitalize, eval("#{activity.url}(#{activity.nesting('record')})")
      end

      private

      def find_plugin(record)
        Refinery::Plugins.active.find_by_model record.class
      end

      def find_activity(record, plugin = nil)
        plugin ||= find_plugin(record) # avoid double lookup if we already have it
        plugin.activity_by_class_name(record.class.name).first
      end

      def record_action(record)
        record.updated_at.eql?(record.created_at) ? 'created' : 'updated'
      end

      # get article to define gender of model name, some languages require this for proper grammar
      def plugin_article(plugin)
        article = t('article', :scope => "refinery.plugins.#{plugin.name}.", :default => 'the')
      end

    end
  end
end
