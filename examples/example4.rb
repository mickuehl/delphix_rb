$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'delphix'

# set the DE url
Delphix.url = 'http://de.delphix.local'
# enable debug outputs
Delphix.debug = true

# authenticate the connection
Delphix.authenticate!('delphix_admin','delphix')

# lookup the group reference
group = Delphix::Group.list.lookup_by_name 'DEV'

# lookup the dSource reference
dsource = Delphix::Database.list.lookup_by_name 'CRM_SOURCE'

# lookup the repository reference, i.e. the DB installation on the target Environment
environment = Delphix::Environment.list.lookup_by_name 'target'

# discover all repositories
repos = Delphix::Repository.list
repos_on_target = repos.filter_by 'environment', environment.reference
repos = repos_on_target.filter_by 'type', 'MySQLInstall'
repository = repos.first # there could be more than one though !

# provision a new VDB now that we have the basic details
resp = Delphix::Database.create_vdb 'CRM_DEV', dsource.reference, group.reference, repository.reference, '/home/delphix/toolkit/V', 5507
resp.wait_for_completion

db = Delphix::Database.list.lookup_by_name 'CRM_DEV'
puts db
puts db.details
