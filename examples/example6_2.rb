$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'delphix'

# set the DE url
Delphix.url = 'http://de.delphix.local'
# enable debug outputs
Delphix.debug = true

# authenticate the connection
Delphix.authenticate!('delphix_admin','delphix')

db = Delphix::Database.list.lookup_by_name 'CRM_TARGET'

# stop and restart the db
db.stop.wait_for_completion
db.start
