$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'delphix'

#
# basic authentication
#

# set the DE url
Delphix.url = 'http://de.delphix.local'
# enable debug outputs
Delphix.debug = true

# authenticate the connection
Delphix.authenticate!('delphix_admin','delphix')

jobs = Delphix::Job.list
job = jobs.first # the most recent job

puts job.cancel!
