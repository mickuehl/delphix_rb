
module Delphix::Base
  include Delphix::Error

  attr_accessor :connection, :info, :details
  
  # The private new method accepts a connection and a hash
  def initialize(connection, info={})
    unless connection.is_a?(Delphix::Connection)
      raise ArgumentError, "Expected a Delphix::Connection, got: #{connection}."
    end
    
    @connection, @info = connection, info
    @details = nil
  end

  def type
    @info['type'] || 'unknown'
  end
  
  def name
    @info['name'] || ''
  end
  
  def reference
    @info['reference'] || ''
  end
    
  def details
    @details ||= refresh_details
    @info = @details
    @details
  end

  def refresh_details
    # Placeholder. Subclasses need to implement this
  end
    
  def to_s
    "#{self.class.name}[#{type}, #{name}, #{reference}]"
  end
  
  # a generic get method, used when there is not specialized method to invoke an API call
  def get(endpoint, payload)
    @connection.get( endpoint, {}, :body => payload)
  end
  
  # a generic get method, used when there is not specialized method to invoke an API call
  def post(endpoint, payload)
    @connection.post( endpoint, {}, :body => payload)
  end
  
end