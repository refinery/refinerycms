module Refinery

  # = Refinery Errors
  #
  # Generic Refinery exception class
  class RefineryError < StandardError
  end

  # Raised when an extension has not been properly defined. See the exception message for further
  # details
  class InvalidEngineError < RefineryError
  end
end
