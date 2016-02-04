$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'delphix'

#
# basic authentication
#

SOURCE_ENV_NAME = "source"

# set the DE url
Delphix.url = 'http://de.delphix.local'
# enable debug outputs
Delphix.debug = true

# authenticate the connection
Delphix.authenticate!('delphix_admin','delphix')

# lookup a specific DB installation on a given environment
environment = Delphix::Environment.list.lookup_by_name 'target'

# discover all repositories
repos = Delphix::Repository.list

# filter repositories by environment and type
repos_on_target = repos.filter_by 'environment', environment.reference
repos = repos_on_target.filter_by 'type', 'MySQLInstall'
repo = repos.first # there could be more than one though !

# the result
puts repo.details
puts "provisioning=#{repo.provisioning?}"
puts "staging=#{repo.staging?}"
