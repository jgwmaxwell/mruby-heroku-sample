class Router
  def initialize(&block)
    @routeset = {}
    block.call(@routeset)
  end

  def dispatch(request)
    @routeset[request.uri].new(request).handle
  end
end

class Handler
  def initialize(request)
    @request = request
  end

  def request_headers
    @request_headers  ||= Nginx::Headers_in.new
  end
  
  def response_headers
    @response_headers ||= Nginx::Headers_out.new
  end

  def write(*args)
    Nginx::echo *args
  end
end

class HomeHandler < Handler
  def handle
    response_headers['X-SERVER-CLASS'] = 'HomeHandler'
    write "#{self.class}:"
  end
end

Routes = Router.new do |routes|
  routes['/'] = HomeHandler
end