$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'delphix'

ENV_NAME = "source"

# set the DE url
Delphix.url = 'http://de.delphix.local'
# enable debug outputs
Delphix.debug = true

# authenticate the connection
Delphix.authenticate!('delphix_admin','delphix')

# discover the environment
environment = Delphix::Environment.list.lookup_by_name ENV_NAME

# delete the evironment with all its sources
environment.delete.wait_for_completion
