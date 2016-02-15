$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'delphix'

#
# basic authentication
#

ENV_NAME = "target"

# set the DE url
Delphix.url = 'http://de.delphix.local'
# enable debug outputs
Delphix.debug = true

# authenticate the connection
Delphix.authenticate!('delphix_admin','delphix')

# discover the environment(s)
environments = Delphix::Environment.list
environment = environments.lookup_by_name ENV_NAME

environment.stop_vdb
