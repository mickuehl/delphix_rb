
class Delphix::Group
  include Delphix::Base
  
  def initialize(reference)
    @connection = Delphix.connection
    @info = { 'reference' => reference }
    @details = nil
  end
  
  def refresh_details
    @details = get("/resources/json/delphix/group/#{reference}", nil)['result']
  end
  
  def self.create(name)
    body = {
      :type => 'Group',
      :name => name
    }
    ref = Delphix.post('/resources/json/delphix/group', body.to_json)['result']
    
    # create a new skeleton group object
    group = Delphix::Group.new ref
    
    # refresh the object from the DE
    group.details
    
    group
  end
  
end
