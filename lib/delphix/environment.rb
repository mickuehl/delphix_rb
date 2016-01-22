
require 'delphix/base_array'
require 'delphix/repository'

class Delphix::Environment
  include Delphix::Base
  
  def initialize(reference)
    @connection = Delphix.connection
    @info = { 'reference' => reference }
    @details = nil
  end
  
  def repositories
    repos = Delphix::BaseArray.new
    result = get('/resources/json/delphix/repository', nil)['result']
    result.each do |o|
      repos << Delphix::Repository.new(connection, o) if o['environment'] == reference
    end
    repos
  end
  
  def refresh_details
    @details = get("/resources/json/delphix/environment/#{reference}", nil)['result']
  end
  
  def self.create(name, address, port, toolkit_path, username, password)
    body = {
      :type => 'HostEnvironmentCreateParameters',
      :primaryUser => {
        :type => 'EnvironmentUser',
        :name => username,
        :credential => {
          :type => 'PasswordCredential',
          :password => password
        }
      },
      :hostEnvironment => {
        :type => 'UnixHostEnvironment',
        :name => name
      },
      :hostParameters => {
        :type => 'UnixHostCreateParameters',
        :host => {
          :type => 'UnixHost',
          :address => address,
          :sshPort => port,
          :toolkitPath => toolkit_path
        }
      }
    }
    response = Delphix.post('/resources/json/delphix/environment', body.to_json)
    
    ref = response['result']
    job = response['job']
    
    # create a new skeleton group object
    env = Delphix::Environment.new ref
    
    # refresh the object from the DE
    env.details
    
    env
  end
  
end
