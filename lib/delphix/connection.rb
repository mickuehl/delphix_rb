# This class represents a Connection to a Delphix Engine. The Connection is
# immutable in that once the url and options is set they cannot be changed.
class Delphix::Connection
  include Delphix::Error
  
  attr_reader :url, :options
  
  def initialize(url, opts)
    case
    when !url.is_a?(String)
      raise ArgumentError, "Expected a String, got: '#{url}'"
    when !opts.is_a?(Hash)
      raise ArgumentError, "Expected a Hash, got: '#{opts}'"
    else
      @url, @options = url, opts
      
      # new HTTP client and session
      @session = Excon.new(url, options)
      @session_cookie = nil
    end
  end
  
  # The actual client that sends HTTP methods to the Delphix Engine.
  def session
    @session
  end
  
  private :session
  
  # Send a request to the server
  def request(*args, &block)
    
    request = compile_request_params(*args, &block)
    
    log_request(request) if Delphix.debug
    
    # execute the request and grao the session cookie if not already set
    response = session.request(request)
    @session_cookie ||= cookie?(response)
    
    log_response(response) if Delphix.debug
    
    return Delphix::Util.parse_json( response.body)
    
  rescue Excon::Errors::BadRequest => ex
    raise ClientError, ex.response.body
  rescue Excon::Errors::Unauthorized => ex
    raise UnauthorizedError, ex.response.body
  rescue Excon::Errors::NotFound => ex
    raise NotFoundError, ex.response.body
  rescue Excon::Errors::Conflict => ex
    raise ConflictError, ex.response.body
  rescue Excon::Errors::InternalServerError => ex
    raise ServerError, ex.response.body
  rescue Excon::Errors::Timeout => ex
    raise TimeoutError, ex.message
  end

  # Delegate all HTTP methods to the #request.
  [:get, :put, :post, :delete].each do |method|
    define_method(method) { |*args, &block| request(method, *args, &block) }
  end
  
  def log_request(request)
    puts "#{[request[:method], request[:path], request[:body]]}" if Delphix.debug
  end
  
  def log_response(response)
    puts "#{[response.headers, response.body]}" if Delphix.debug
  end
  
  def to_s
    "Delphix::Connection { :url => #{url}, :options => #{options} }"
  end

private
    
  # Given an HTTP method, path, optional query, extra options, and block compiles a request.
  def compile_request_params(http_method, path, query = nil, opts = nil, &block)
    query ||= {}
    opts ||= {}
    headers = opts.delete(:headers) || {}
    headers = { 'Cookie' => @session_cookie}.merge(headers) if @session_cookie
    content_type = 'application/json'
    user_agent = "Delphix/Delphix-API"
    
    {
      :method        => http_method,
      :path          => "#{path}",
      :query         => query,
      :headers       => { 'Content-Type' => content_type,
                          'User-Agent'   => user_agent,
                        }.merge(headers),
      :expects       => (200..204).to_a << 304 << 403 << 500,
      :idempotent    => http_method == :get,
      :request_block => block
    }.merge(opts).reject { |_, v| v.nil? }
    
  end
  
  def cookie?(response)
    response.headers['Set-Cookie']
  end

end