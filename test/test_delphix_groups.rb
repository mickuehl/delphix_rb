
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'delphix'

# set the DE url
Delphix.url = 'http://de.delphix.local'
Delphix.debug = true

# authenticate the connection
Delphix.authenticate!('delphix_admin','delphix')

# ceate a new group
group = Delphix::Group.create 'FOO'
puts group