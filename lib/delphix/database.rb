
class Delphix::Database
  include Delphix::Base

  def initialize(reference, details=nil)
    super(reference, details)
  end

  # basic operations

  def delete
    Delphix::Response.new( Delphix.delete("#{base_endpoint}/#{reference}"))
  end

  # specific operations

  def start
    Delphix::Response.new( Delphix.post("/resources/json/delphix/source/#{lookup_source_ref}/start"))
  end

  def stop
    Delphix::Response.new( Delphix.post("/resources/json/delphix/source/#{lookup_source_ref}/stop"))
  end

  # inherited operations

  def base_endpoint
    '/resources/json/delphix/database'
  end

  # class methods

  def self.list
    databases = Delphix::BaseArray.new
    result = Delphix.get('/resources/json/delphix/database')['result']
    result.each do |db|
      databases << Delphix::Database.new(db['reference'],db)
    end
    databases
  end

  def self.create_vdb(name, source_ref, group_ref, environment_ref, mount_base, port, params={})

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

    Delphix::Response.new( Delphix.post('/resources/json/delphix/database/provision', body.to_json))

  end

  private

  def lookup_source_ref
    sources = Delphix::Source.list
    source = sources.filter_by 'container', reference
    source[0].reference # FIXME assumes there is only one ...
  end

end
