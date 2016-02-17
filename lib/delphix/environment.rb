
require 'delphix/base_array'
require 'delphix/repository'

class Delphix::Environment
  include Delphix::Base

  def initialize(reference, details=nil)
    super(reference, details)
  end

  # basic operations

  def delete(delete_all_sources=true)

    if delete_all_sources
      # stop and delete all sources on this environment
      sources = lookup_sources
      if sources != nil
        containers = {}

        # build a list of unique container references
        sources.each do |src|
          container_ref = src.details['container']
          containers[container_ref] = container_ref
        end

        # get a list of all databases
        databases = Delphix::Database.list

        # now delete all containers(databases)
        containers.keys.each do |ref|
          db = databases.lookup_by_ref ref
          db.delete.wait_for_completion
        end
      end
    end

    Delphix::Response.new( Delphix.delete("#{base_endpoint}/#{reference}"))
  end

  # specific operations

  def enable(enable_all_sources=false)
    resp = Delphix::Response.new( Delphix.post("#{base_endpoint}/#{reference}/enable"))
    return resp if !enable_all_sources

    resp.wait_for_completion

    # enable all sources on this environment
    sources = lookup_sources
    if sources != nil
      sources.each do |src|
        src.enable.wait_for_completion
      end
    end

    resp
  end

  def disable(disable_all_sources=true)

    if disable_all_sources
      # stop and disable all sources on this environment
      sources = lookup_sources
      if sources != nil
        sources.each do |src|
          if src.virtual?
            src.stop.wait_for_completion
          end
          src.disable.wait_for_completion
        end
      end
    end

    # now disable the environment itself
    Delphix::Response.new( Delphix.post("#{base_endpoint}/#{reference}/disable"))
  end

  def refresh
    Delphix::Response.new( Delphix.post("#{base_endpoint}/#{reference}/refresh"))
  end

  # inherited operations

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

    # create the environment
    resp = Delphix::Response.new( Delphix.post('/resources/json/delphix/environment', body.to_json))
    return nil if resp.is_error?

    # wait until the environment has been created
    resp.job.wait_for_completion

    # create a new skeleton environment object
    env = Delphix::Environment.new resp.details
    # and refresh the object from the engine
    env.refresh_details

    env
  end

  def self.list
    envs = Delphix::BaseArray.new
    result = Delphix.get('/resources/json/delphix/environment')['result']
    result.each do |env|
      envs << Delphix::Environment.new(env['reference'],env)
    end
    envs
  end

  private

  def lookup_sources
    repos = Delphix::Repository.list
    repos = repos.filter_by 'environment', reference

    # lookup sourceconfigs that are related to this environment
    configs = Delphix::SourceConfig.list
    sourceconfigs = Delphix::BaseArray.new
    repos.each do |repo|
      result = configs.filter_by 'repository', repo.reference
      if result != nil
        result.each do |i|
          sourceconfigs << i
        end
      end
    end

    # find the matching sources
    sources = Delphix::Source.list

    # filter to match sourceconfigs
    vdb_sources = Delphix::BaseArray.new
    sourceconfigs.each do |conf|
      result = sources.filter_by 'config', conf.reference
      if result != nil
        result.each do |i|
          vdb_sources << i
        end
      end
    end

    return nil if vdb_sources.size == 0
    vdb_sources

  end

end
