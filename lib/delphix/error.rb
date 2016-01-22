# This module holds the Errors for the gem.

module Delphix::Error

  # The default error. It's never actually raised, but can be used to catch all
  # gem-specific errors that are thrown as they all subclass from this.
  class DelphixError < StandardError
  end

  # Raised when invalid arguments are passed to a method.
  class ArgumentError < DelphixError; end

  # Raised when a request returns a 400.
  class ClientError < DelphixError; end

  # Raised when a request returns a 401.
  class UnauthorizedError < DelphixError; end

  # Raised when a request returns a 404.
  class NotFoundError < DelphixError; end

  # Raised when a request returns a 500.
  class ServerError < DelphixError; end

  # Raised when there is an unexpected response code / body.
  class UnexpectedResponseError < DelphixError; end

  # Raised when there is an incompatible version of Delphix.
  class VersionError < DelphixError; end

  # Raised when a request times out.
  class TimeoutError < DelphixError; end

  # Raised when login fails.
  class AuthenticationError < DelphixError; end

  # Raised when an IO action fails.
  class IOError < DelphixError; end
end
