$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'delphix'
#require 'delphix/environment'

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

groups = Delphix::Group.list
group = groups.lookup_by_name 'FOO'

puts group
