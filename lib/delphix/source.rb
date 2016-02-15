
class Delphix::Source
  include Delphix::Base

  def initialize(reference, details=nil)
    super(reference, details)
  end

  # basic operations

  # specific operations

  # inherited operations

  def refresh_details
    @details = Delphix.get("#{base_endpoint}/#{reference}")['result']
  end

  def base_endpoint
    '/resources/json/delphix/source'
  end

  # class methods

  def self.list
    sources = Delphix::BaseArray.new
    result = Delphix.get('/resources/json/delphix/source')['result']
    result.each do |src|
      sources << Delphix::Source.new(src['reference'],src)
    end
    sources
  end

end
