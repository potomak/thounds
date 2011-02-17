require File.expand_path('../spec_helper', __FILE__)

describe Thounds do
  after do
    Thounds.reset
  end

  context "when delegating to a client" do

    before do
      stub_get("users/31").
        to_return(:body => fixture("user_31.js"), :headers => {:content_type => "application/json; charset=utf-8"})
    end

    it "should get the correct resource" do
      Thounds.users(31) {|user| user}
      a_get("users/31").
        should have_been_made
    end

    it "should return the same results as a client" do
      Thounds.users(31) {|user| user}.should == Thounds::Client.new.users(31) {|user| user}
    end

  end

  describe ".client" do
    it "should be a Thounds::Client" do
      Thounds.client.should be_a Thounds::Client
    end
  end

  describe ".adapter" do
    it "should return the default adapter" do
      Thounds.adapter.should == Thounds::Configuration::DEFAULT_ADAPTER
    end
  end

  describe ".adapter=" do
    it "should set the adapter" do
      Thounds.adapter = :typhoeus
      Thounds.adapter.should == :typhoeus
    end
  end

  describe ".endpoint" do
    it "should return the default endpoint" do
      Thounds.endpoint.should == Thounds::Configuration::DEFAULT_ENDPOINT
    end
  end

  describe ".endpoint=" do
    it "should set the endpoint" do
      Thounds.endpoint = 'http://tumblr.com/'
      Thounds.endpoint.should == 'http://tumblr.com/'
    end
  end

  describe ".format" do
    it "should return the default format" do
      Thounds.format.should == Thounds::Configuration::DEFAULT_FORMAT
    end
  end

  describe ".format=" do
    it "should set the format" do
      Thounds.format = 'xml'
      Thounds.format.should == 'xml'
    end
  end

  describe ".user_agent" do
    it "should return the default user agent" do
      Thounds.user_agent.should == Thounds::Configuration::DEFAULT_USER_AGENT
    end
  end

  describe ".user_agent=" do
    it "should set the user_agent" do
      Thounds.user_agent = 'Custom User Agent'
      Thounds.user_agent.should == 'Custom User Agent'
    end
  end

  describe ".configure" do

    Thounds::Configuration::VALID_OPTIONS_KEYS.each do |key|

      it "should set the #{key}" do
        Thounds.configure do |config|
          config.send("#{key}=", key)
          Thounds.send(key).should == key
        end
      end
    end
  end
end
