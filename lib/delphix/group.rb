
class Delphix::Group
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
    '/resources/json/delphix/group'
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
    group.refresh_details

    group
  end

end
