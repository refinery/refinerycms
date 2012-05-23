module Refinery
  module Testing
    module ControllerMacros
      module Methods
        def get(action, *args)
          process_refinery_action(action, 'GET', *args)
        end

        # Executes a request simulating POST HTTP method and set/volley the response
        def post(action, *args)
          process_refinery_action(action, 'POST', *args)
        end

        # Executes a request simulating PUT HTTP method and set/volley the response
        def put(action, *args)
          process_refinery_action(action, 'PUT', *args)
        end

        # Executes a request simulating DELETE HTTP method and set/volley the response
        def delete(action, *args)
          process_refinery_action(action, 'DELETE', *args)
        end

        private

        def process_refinery_action(action, http_method = 'GET', *args)
          process(action, http_method, *args, :use_route => :refinery)
        end
      end
    end
  end
end
