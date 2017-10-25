module Refinery
  module Api
    class GraphqlController < ::ApplicationController

    def execute
      query = params[:query]
      variables = params[:variables] || {}
      context = {
        current_user: current_user
      }
      begin
        result = GraphqlSchema.execute(query, variables: variables, context: context)
      rescue => error
        result = { errors: [{ message: error.message }] }
      end
      render json: result
    end
  end
end
