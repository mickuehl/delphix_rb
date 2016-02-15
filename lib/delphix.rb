
require 'json'
require 'excon'

module Delphix

  require 'delphix/error'
  require 'delphix/util'
  require 'delphix/connection'
  require 'delphix/base'
  require 'delphix/base_array'
  require 'delphix/environment'
  require 'delphix/group'
  require 'delphix/repository'
  require 'delphix/database'
  require 'delphix/source'
  require 'delphix/sourceconfig'

  def authenticate!(username,password)

    case
      when !username.is_a?(String)
        raise ArgumentError, "Expected a String, got: '#{username}'"
      when !password.is_a?(String)
        raise ArgumentError, "Expected a String, got: '#{password}'"
    end

    reset_connection!

    # create a session
    session = {
      :type => 'APISession',
      :version => {
        :type => 'APIVersion', # Delphix Engine 4.3.1.x and above
        :major => 1,
        :minor => 6,
        :micro => 0
      }
    }
    post('/resources/json/delphix/session', session.to_json)

    # authenticate the session
    auth = {
      :type => 'LoginRequest',
      :username => username,
      :password => password
    }
    post('/resources/json/delphix/login', auth.to_json)

  end

  # a generic get method, used when there is not specialized method to invoke an API call
  def get(endpoint, payload=nil)
    connection.get( endpoint, {}, :body => payload)
  end

  # a generic post method, used when there is not specialized method to invoke an API call
  def post(endpoint, payload=nil)
    connection.post( endpoint, {}, :body => payload)
  end

  # a generic put method, used when there is not specialized method to invoke an API call
  def put(endpoint, payload=nil)
    connection.put( endpoint, {}, :body => payload)
  end

  # a generic delete method, used when there is not specialized method to invoke an API call
  def delete(endpoint, payload=nil)
    connection.delete( endpoint, {}, :body => payload)
  end

  def url
    @url ||= env_url
    @url
  end

  def url=(new_url)
    @url = new_url
    reset_connection!
  end

  def options
    @options ||= env_options
  end

  def options=(new_options)
    @options = env_options.merge(new_options || {})
    reset_connection!
  end

  def debug
    @debug || false
  end

  def debug=(new_value)
    @debug = new_value
  end

private

  def connection
    @connection ||= Connection.new(url, options)
  end

  def reset_connection!
    @connection = nil
  end

  def env_url
    ENV['DELPHIX_URL'] || default_url
  end

  def default_url
    'http://localhost'
  end

  def env_options
    {}
  end

  module_function :get, :post, :put, :delete,
    :authenticate!, :url, :url=, :connection, :reset_connection!,
    :options, :options=, :debug, :debug=,
    :env_url, :default_url, :env_options

end
