module Thounds
  # Defines HTTP request methods
  module Request
    # Perform an HTTP request
    def request(method, path, options={}, raw=false)
      response = connection(raw).send(method) do |request|
        case method
        when :get, :delete
          request.url(formatted_path(path), options)
        when :post, :put
          request.path = formatted_path(path)
          request.body = options unless options.empty?
        end
      end
      raw ? response : response.body
    end
    
    private

    def formatted_path(path)
      path
    end
  end
end
