require 'simplecov'
SimpleCov.start do
  add_group 'Thounds', 'lib/thounds'
  add_group 'Faraday Middleware', 'lib/faraday'
  add_group 'Specs', 'spec'
end

require File.expand_path('../../lib/thounds', __FILE__)

require 'rspec'
require 'webmock/rspec'
RSpec.configure do |config|
  config.include WebMock::API
end

def a_delete(path)
  a_request(:delete, Thounds.endpoint + path)
end

def a_get(path)
  a_request(:get, Thounds.endpoint + path)
end

def a_post(path)
  a_request(:post, Thounds.endpoint + path)
end

def a_put(path)
  a_request(:put, Thounds.endpoint + path)
end

def stub_delete(path)
  stub_request(:delete, Thounds.endpoint + path)
end

def stub_get(path)
  stub_request(:get, Thounds.endpoint + path)
end

def stub_post(path)
  stub_request(:post, Thounds.endpoint + path)
end

def stub_put(path)
  stub_request(:put, Thounds.endpoint + path)
end

def fixture_path
  File.expand_path("../fixtures", __FILE__)
end

def fixture(file)
  File.new(fixture_path + '/' + file)
end
