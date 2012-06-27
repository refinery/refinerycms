module Refinery
  module Testing
    module ControllerMacros
      module Methods
        def get(action, options = {})
          process_refinery_action(action, 'GET', options)
        end

        # Executes a request simulating POST HTTP method and set/volley the response
        def post(action, options = {})
          process_refinery_action(action, 'POST', options)
        end

        # Executes a request simulating PUT HTTP method and set/volley the response
        def put(action, options = {})
          process_refinery_action(action, 'PUT', options)
        end

        # Executes a request simulating PUT HTTP method and set/volley the response
        def patch(action, options = {})
          process_refinery_action(action, 'PATCH', options)
        end

        # Executes a request simulating DELETE HTTP method and set/volley the response
        def delete(action, options = {})
          process_refinery_action(action, 'DELETE', options)
        end

        private

        def process_refinery_action(action, http_method = 'GET', options)
          process(action, http_method, options.merge(:use_route => :refinery))
        end
      end
    end
  end
end
