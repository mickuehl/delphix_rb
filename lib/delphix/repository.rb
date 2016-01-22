
class Delphix::Repository
  include Delphix::Base
  
  def refresh_details
    @details = get("/resources/json/delphix/repository/#{reference}", nil)['result']
  end
    
end
