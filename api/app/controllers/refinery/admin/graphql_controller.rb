module Refinery
  module Admin
    class GraphqlController < Refinery::AdminController

      def execute
        query = params[:query]
        variables = params[:variables] || {}

        begin
          result = Refinery::Api::GraphqlSchema.execute(query, variables: variables, context: context)
        rescue => error
          result = { errors: [{ message: error.message }] }
        end

        render json: result
      end

      private

      def context
        {
          current_user: current_refinery_user
        }
      end
    end
  end
end