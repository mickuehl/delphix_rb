# This module holds shared logic that doesn't really belong anywhere else in the gem.

module Delphix::Util
  include Delphix::Error

  module_function

  def parse_json(body)
    JSON.parse(body) unless body.nil? || body.empty? || (body == 'null')
  rescue JSON::ParserError => ex
    raise UnexpectedResponseError, ex.message
  end

  def pretty_print_json(body)
    JSON.pretty_generate( JSON.parse( body))
  end

  module_function :parse_json, :pretty_print_json

end
