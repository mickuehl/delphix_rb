
class Delphix::Repository
  include Delphix::Base

  def initialize(reference, details=nil)
    super(reference, details)
  end

  # basic operations

  # specific operations
  def provisioning?
    @details['provisioningEnabled'] == true
  end

  def provisioning!(provisioning)
    return if provisioning? == provisioning
    body = {
      :type => type,
      :provisioningEnabled => provisioning
    }
    Delphix.post("#{base_endpoint}/#{reference}", body.to_json)
    # TODO error handling on wait for completion!
    refresh_details
  end

  def staging?
    @details['staging'] == true
  end

  def staging!(staging)
    return if staging? == staging
    body = {
      :type => type,
      :staging => staging
    }
    Delphix.post("#{base_endpoint}/#{reference}", body.to_json)
    # TODO error handling on wait for completion!
    refresh_details
  end

  # inherited operations

  def refresh_details
    @details = Delphix.get("#{base_endpoint}/#{reference}")['result']
  end

  def base_endpoint
    '/resources/json/delphix/repository'
  end

  # class methods

  def self.list
    repos = Delphix::BaseArray.new
    result = Delphix.get('/resources/json/delphix/repository')['result']
    result.each do |repo|
      repos << Delphix::Repository.new(repo['reference'],repo)
    end
    repos
  end

end
