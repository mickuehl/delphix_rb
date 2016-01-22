
module Delphix::Base
  include Delphix::Error

  attr_accessor :details
  
  # The private new method accepts a connection and a hash
  def initialize(reference=nil, details=nil)
    if details == nil
      @details = { 'reference' => reference }
    else
      @details = details
    end
  end

  def type
    @details['type'] || 'unknown'
  end
  
  def name
    @details['name'] || ''
  end
  
  def reference
    @details['reference'] || ''
  end
    
  def details
    @details ||= refresh_details
    @details
  end

  def refresh_details
    # Placeholder. Subclasses need to implement this
  end
  
  def base_endpoint
    # Placeholder. Subclasses need to implement this
  end
  
  def to_s
    "#{self.class.name}[#{type}, #{name}, #{reference}]"
  end
  
  # a generic get method, used when there is not specialized method to invoke an API call
  def get(endpoint, payload)
    Delphix.get( endpoint, payload)
  end
  
  # a generic post method, used when there is not specialized method to invoke an API call
  def post(endpoint, payload)
    Delphix.post( endpoint, payload)
  end
  
  # a generic delete method, used when there is not specialized method to invoke an API call
  def delete(endpoint, payload)
    Delphix.delete( endpoint, payload)
  end
  
end