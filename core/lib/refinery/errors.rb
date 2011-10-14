module Refinery

  # = Refinery Errors
  #
  # Generic Refinery exception class
  class RefineryError < StandardError
  end

  # Raised when an engine has not been properly defined. See the exception message for further
  # details
  class InvalidEngineError < RefineryError
  end
end
