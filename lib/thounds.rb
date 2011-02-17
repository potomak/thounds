require File.expand_path('../thounds/error', __FILE__)
require File.expand_path('../thounds/configuration', __FILE__)
require File.expand_path('../thounds/api', __FILE__)
require File.expand_path('../thounds/client', __FILE__)

module Thounds
  extend Configuration

  # Alias for Thounds::Client.new
  #
  # @return [Thounds::Client]
  def self.client(options={})
    Thounds::Client.new(options)
  end

  # Delegate to Thounds::Client
  def self.method_missing(method, *args, &block)
    #return super unless client.respond_to?(method)
    client.send(method, *args, &block)
  end

  # Delegate to Thounds::Client
  # def self.respond_to?(method)
  #   return client.respond_to?(method) || super
  # end
end
