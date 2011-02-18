# -*- encoding: utf-8 -*-
module Thounds
  class Client
    class Proxy
      attr_reader :options, :verb, :path

      def initialize
        @verb = :get
        @keys = []
        @ids = {}
        @options = {}
        @path = ""
      end

      def append(key, id=nil, options={})
        @verb = key.to_sym if ["get", "post", "put", "delete"].include? key.to_s
        @keys << key unless ["get", "post", "put", "delete"].include? key.to_s
        @ids[key.to_sym] = id if id
        @options = @options.merge(options) if options
      end

      def compose_request
        # puts "@keys: #{@keys.inspect}"
        # puts "@ids: #{@ids.inspect}"
        # puts "@options: #{@options.inspect}"
        
        # compose request path
        @path = @keys.collect do |key|
          if id = @ids.delete(key.to_sym)
            "#{key}/#{id}"
          else
            key
          end
        end.join("/")
        
        # puts to_s

        self
      end

      def to_s
        "#{@verb.to_s.upcase} /#{@path} OPTIONS: #{@options.inspect}"
      end
    end
  end
end
