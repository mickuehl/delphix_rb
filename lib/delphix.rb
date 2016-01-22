  
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
    
  def environments
    envs = BaseArray.new
    result = get('/resources/json/delphix/environment', nil)['result']
    result.each do |env|
      envs << Environment.new(env['reference'],env)
    end
    envs
  end
  
  def groups
    groups = BaseArray.new
    result = get('/resources/json/delphix/group', nil)['result']
    result.each do |group|
      groups << Group.new(group['reference'],group)
    end
    groups
  end
  
  def repositories
    repos = BaseArray.new
    result = get('/resources/json/delphix/repository', nil)['result']
    result.each do |repo|
      repos << Repository.new(repo['reference'],repo)
    end
    repos
  end
  
  def targets
  end
  
  def sources
  end
  
  # a generic get method, used when there is not specialized method to invoke an API call
  def get(endpoint, payload)
    connection.get( endpoint, {}, :body => payload)
  end
  
  # a generic post method, used when there is not specialized method to invoke an API call
  def post(endpoint, payload)
    connection.post( endpoint, {}, :body => payload)
  end
  
  # a generic put method, used when there is not specialized method to invoke an API call
  def put(endpoint, payload)
    connection.put( endpoint, {}, :body => payload)
  end
  
  # a generic delete method, used when there is not specialized method to invoke an API call
  def delete(endpoint, payload)
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
    :environments, :groups, :repositories,
    :authenticate!, :url, :url=, :options, :options=, :connection, :reset_connection!, :debug, :debug=,
    :env_url, :default_url, :env_options
         
end