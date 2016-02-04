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

# lookup the group reference
group = Delphix::Group.list.lookup_by_name 'DEV'

# lookup the dSource reference
dsource = Delphix::Database.list.lookup_by_name 'CRM_SOURCE'

# lookup the repository reference, i.e. the DB installation on the target Environment
repository = Delphix::Repository.list.lookup_by_ref 'MYSQL_INSTALL-2'

# provision a new VDB now that we have the basic details
vdb = Delphix::VDB.create 'CRM_DEV', dsource.reference, group.reference, repository.reference, '/home/delphix/toolkit/V', 5506
