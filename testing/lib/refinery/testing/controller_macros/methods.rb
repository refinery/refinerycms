module Refinery
  module Testing
    module ControllerMacros
      module Methods
        def get(action, parameters = nil, session = nil, flash = nil)
          process_refinery_action(action, parameters, session, flash, "GET")
        end

        # Executes a request simulating POST HTTP method and set/volley the response
        def post(action, parameters = nil, session = nil, flash = nil)
          process_refinery_action(action, parameters, session, flash, "POST")
        end

        # Executes a request simulating PUT HTTP method and set/volley the response
        def put(action, parameters = nil, session = nil, flash = nil)
          process_refinery_action(action, parameters, session, flash, "PUT")
        end

        # Executes a request simulating DELETE HTTP method and set/volley the response
        def delete(action, parameters = nil, session = nil, flash = nil)
          process_refinery_action(action, parameters, session, flash, "DELETE")
        end

        private

        def process_refinery_action(action, parameters = nil, session = nil, flash = nil, method = "GET")
          parameters ||= {}
          process(action, parameters.merge!(:use_route => :refinery), session, flash, method)
        end
      end
    end
  end
end
