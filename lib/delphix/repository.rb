
class Delphix::Repository
  include Delphix::Base

  def initialize(reference, details=nil)
    super(reference, details)
  end

  def refresh_details
    @details = delphix_get("#{base_endpoint}/#{reference}", nil)['result']
  end

  def base_endpoint
    '/resources/json/delphix/repository'
  end

  # class methods

  def self.list
    repos = Delphix::BaseArray.new
    result = Delphix.get('/resources/json/delphix/repository', nil)['result']
    result.each do |repo|
      repos << Delphix::Repository.new(repo['reference'],repo)
    end
    repos
  end

end
