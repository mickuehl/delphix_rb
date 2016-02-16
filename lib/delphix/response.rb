
class Delphix::Response
  include Delphix::Error

  attr_accessor :details

  # The private new method accepts a reference string and a hash
  def initialize(details={})
    @details = details
  end

  def type
    @details['type'] || 'unknown'
  end

  def status
    @details['status'] || 'unknown'
  end

  def details
    @details['result'] || nil
  end

  def is_error?
    @details['type'] == 'ErrorResult'
  end

  def job
    return nil if @details['job'] == nil
    Delphix::Job.new( @details['job'])
  end

  def wait_for_completion
    return if is_error?
    job.wait_for_completion if job
  end

  def to_s
    "#{self.class.name}[#{type}, #{status}]"
  end

end
