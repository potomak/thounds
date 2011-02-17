require File.expand_path('../../spec_helper', __FILE__)

describe Faraday::Response do
  before do
    @client = Thounds::Client.new
  end

  {
    400 => Thounds::BadRequest,
    401 => Thounds::Unauthorized,
    403 => Thounds::Forbidden,
    404 => Thounds::NotFound,
    406 => Thounds::NotAcceptable,
    500 => Thounds::InternalServerError,
    502 => Thounds::BadGateway,
    503 => Thounds::ServiceUnavailable,
  }.each do |status, exception|
    context "when HTTP status is #{status}" do

      before do
        stub_get('users/171').to_return(:status => status)
      end

      it "should raise #{exception.name} error" do
        lambda do
          @client.users(171) {|user| user}
        end.should raise_error(exception)
      end
    end
  end
end
