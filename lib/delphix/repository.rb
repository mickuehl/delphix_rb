
class Delphix::Repository
  include Delphix::Base
  
  def initialize(reference, details=nil)
    super(reference, details)
  end
  
  def refresh_details
    @details = get("/resources/json/delphix/repository/#{reference}", nil)['result']
  end
    
end
