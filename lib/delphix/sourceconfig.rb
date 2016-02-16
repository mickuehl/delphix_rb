
class Delphix::SourceConfig
  include Delphix::Base

  def initialize(reference, details=nil)
    super(reference, details)
  end

  # basic operations

  # specific operations

  # inherited operations

  def base_endpoint
    '/resources/json/delphix/sourceconfig'
  end

  # class methods

  def self.list
    sources = Delphix::BaseArray.new
    result = Delphix.get('/resources/json/delphix/sourceconfig')['result']
    result.each do |src|
      sources << Delphix::SourceConfig.new(src['reference'],src)
    end
    sources
  end

end
