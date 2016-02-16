
class Delphix::Job
  include Delphix::Base

  def initialize(reference, details=nil)
    super(reference, details)
  end

  # basic operations

  # specific operations

  def state
    @details['jobState'] # RUNNING, SUSPENDED, CANCELED, COMPLETED, FAILED
  end

  def state?
    refresh_details
    state
  end

  def cancel!
    Delphix.post("#{base_endpoint}/#{reference}/cancel")['result']
  end

  # inherited operations

  def to_s
    "#{self.class.name}[#{@details['actionType']}, #{reference}, #{@details['jobState']}]"
  end

  def refresh_details
    @details = Delphix.get("#{base_endpoint}/#{reference}")['result']
  end

  def base_endpoint
    '/resources/json/delphix/job'
  end

  # class methods

  def self.list
    jobs = Delphix::BaseArray.new
    result = Delphix.get('/resources/json/delphix/job')['result']
    result.each do |job|
      jobs << Delphix::Job.new(job['reference'],job)
    end
    jobs
  end

end