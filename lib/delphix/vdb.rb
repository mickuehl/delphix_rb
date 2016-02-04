
class Delphix::VDB
  include Delphix::Base

  def initialize(reference, details=nil)
    super(reference, details)
  end

  # basic operations

  def delete

  end

  # inherited operations

  def refresh_details
    @details = delphix_get("#{base_endpoint}/#{reference}", nil)['result']
  end

  def base_endpoint
    '/resources/json/delphix/group'
  end

  def self.create(name, source_ref, group_ref, environment_ref, mount_base, port, params={})

    body = {
      :type => 'MySQLProvisionParameters',
      :container => {
        :type => 'MySQLDatabaseContainer',
        :name => name,
        :group => group_ref,
        :sourcingPolicy => {
          :type => 'SourcingPolicy'
        }
      },
      :source => {
        :type => 'MySQLVirtualSource',
        :mountBase => mount_base
      },
      :sourceConfig => {
        :type => 'MySQLServerConfig',
        :port => port,
        :repository => environment_ref
      },
      :timeflowPointParameters => {
        :type => 'TimeflowPointSemantic',
        :container => source_ref,
        :location => 'LATEST_SNAPSHOT'
      }
    }

    response = Delphix.post('/resources/json/delphix/database/provision', body.to_json)
    response
  end

end
