$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'delphix'

ENV_NAME = "target"

# set the DE url
Delphix.url = 'http://de.delphix.local'
# enable debug outputs
Delphix.debug = true

# authenticate the connection
Delphix.authenticate!('delphix_admin','delphix')

# discover the environment
environment = Delphix::Environment.list.lookup_by_name ENV_NAME

# disable the evironment with all its sources
environment.disable.wait_for_completion

# enable the environment and all sources provisioned to it
environment.enable true
