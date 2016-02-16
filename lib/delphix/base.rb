
module Delphix::Base
  include Delphix::Error

  attr_accessor :details

  # The private new method accepts a reference string and a hash
  def initialize(reference=nil, details=nil)
    # FIXME change this, passing the reference does not make sense !!!
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
    # TODO Subclasses should override this if needed
    @details = Delphix.get("#{base_endpoint}/#{reference}")['result']
  end

  def base_endpoint
    # Placeholder. Subclasses need to implement this
  end

  def to_s
    "#{self.class.name}[#{type}, #{name}, #{reference}]"
  end

end
