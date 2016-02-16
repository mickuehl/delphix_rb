$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'delphix'

SOURCE_ENV_NAME = "source"

# set the DE url
Delphix.url = 'http://de.delphix.local'
# enable debug outputs
Delphix.debug = true

# authenticate the connection
Delphix.authenticate!('delphix_admin','delphix')

# discover the environment(s)
environments = Delphix::Environment.list
environment = environments.lookup_by_name SOURCE_ENV_NAME

puts environment.refresh

#jobs = Delphix::Job.list
#job = jobs.first # the most recent job

#puts jobs
#puts '---'
#puts job.cancel!
