
class Delphix::Database
  include Delphix::Base

  def initialize(reference, details=nil)
    super(reference, details)
  end

  # basic operations

  def delete
    delphix_delete("#{base_endpoint}/#{reference}", nil)['result']
  end

  # inherited operations

  def refresh_details
    @details = delphix_get("#{base_endpoint}/#{reference}", nil)['result']
  end

  def base_endpoint
    '/resources/json/delphix/database'
  end

  # class methods

  def self.list
    databases = Delphix::BaseArray.new
    result = Delphix.get('/resources/json/delphix/database', nil)['result']
    result.each do |db|
      databases << Delphix::Database.new(db['reference'],db)
    end
    databases
  end

end
