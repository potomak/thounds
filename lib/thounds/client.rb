module Thounds
  # Wrapper for the Thounds REST API
  #
  # @note See the {http://developers.thounds.com/doc Thounds API Documentation} for more informations.
  # @see http://developers.thounds.com
  class Client < API
    # Require client method modules after initializing the Client class in
    # order to avoid a superclass mismatch error, allowing those modules to be
    # Client-namespaced.
    Dir[File.expand_path('../client/*.rb', __FILE__)].each{|f| require f}

    alias :api_endpoint :endpoint
    
    attr_reader :proxy
    
    def initialize(options={})
      super(options)
      @proxy = Proxy.new
    end
    
    # Delegate to Thounds::Client
    def method_missing(method, *args, &block)
      options = args.last.is_a?(Hash) ? args.pop : {}
      id = args.last ? args.pop : nil
      
      # puts "method: #{method}"
      # puts "options: #{options.inspect}"
      # puts "id: #{id}"
      
      @proxy.append(method, id, options)
      
      if block_given?
        @proxy.compose_request
        yield send(:request, @proxy.verb, @proxy.path, @proxy.options)
      end
      
      self
      
      # begin
      #   send(verb, path, options)
      # rescue Yajl::ParseError => e
      #   puts "error: #{e}"
      # end
    end
  end
end
