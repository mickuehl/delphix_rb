
class Delphix::Group
  include Delphix::Base

  def initialize(reference, details=nil)
    super(reference, details)
  end

  # basic operations

  def delete
    Delphix::Response.new( Delphix.delete("#{base_endpoint}/#{reference}"))
  end

  # specific operations

  # inherited operations

  def refresh_details
    @details = Delphix.get("#{base_endpoint}/#{reference}")['result']
  end

  def base_endpoint
    '/resources/json/delphix/group'
  end

  # class methods

  def self.create(name)
    body = {
      :type => 'Group',
      :name => name
    }
    ref = Delphix.post('/resources/json/delphix/group', body.to_json)['result']

    # create a new skeleton group object
    group = Delphix::Group.new ref

    # refresh the object from DE
    group.refresh_details

    group
  end

  def self.list
    groups = Delphix::BaseArray.new
    result = Delphix.get('/resources/json/delphix/group')['result']
    result.each do |group|
      groups << Delphix::Group.new(group['reference'],group)
    end
    groups
  end

end
