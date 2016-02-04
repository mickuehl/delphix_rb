
require 'delphix/base_array'
require 'delphix/repository'

class Delphix::Environment
  include Delphix::Base

  def initialize(reference, details=nil)
    super(reference, details)
  end

  # basic operations

  def enable
    delphix_post("#{base_endpoint}/#{reference}/enable", nil)['result']
  end

  def disable
    delphix_post("#{base_endpoint}/#{reference}/disable", nil)['result']
  end

  def delete
    delphix_delete("#{base_endpoint}/#{reference}", nil)['result']
  end

  # inherited operations

  def refresh_details
    @details = delphix_get("#{base_endpoint}/#{reference}", nil)['result']
  end

  def base_endpoint
    '/resources/json/delphix/environment'
  end

  # class methods

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
    env.refresh_details

    env
  end

  def self.list
    envs = Delphix::BaseArray.new
    result = Delphix.get('/resources/json/delphix/environment', nil)['result']
    result.each do |env|
      envs << Delphix::Environment.new(env['reference'],env)
    end
    envs
  end

end
