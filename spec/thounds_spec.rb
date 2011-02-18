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
      class_obj = nil
      client_obj = nil
      
      Thounds.users(31) {|user| class_obj = user}
      Thounds::Client.new.users(31) {|user| client_obj = user}
      
      class_obj.should == client_obj
    end

  end
  
  context "when making a request to" do
    
    describe "profile" do
      before do
        stub_get("profile")
      end
      
      it "should use 'profile' reqest path" do
        Thounds.profile {|r| r}.proxy.path.should == "profile"
      end
    end
    
    ["band", "library", "notifications"].each do |member|
      describe "profile/#{member}" do
        before do
          stub_get("profile/#{member}")
        end

        it "should use 'profile/#{member}' reqest path" do
          Thounds.profile.send(member) {|r| r}.proxy.path.should == "profile/#{member}"
        end
      end
    end
    
    describe "users/666" do
      before do
        stub_get("users/666")
      end
      
      it "should use 'users/666' reqest path" do
        Thounds.users(666) {|r| r}.proxy.path.should == "users/666"
      end
    end
    
    ["band", "library"].each do |member|
      describe "users/666/#{member}" do
        before do
          stub_get("users/666/#{member}")
        end

        it "should use 'users/666/#{member}' reqest path" do
          Thounds.users(666).send(member) {|r| r}.proxy.path.should == "users/666/#{member}"
        end
      end
    end
    
    describe "home" do
      before do
        stub_get("home")
      end
      
      it "should use 'home' reqest path" do
        Thounds.home {|r| r}.proxy.path.should == "home"
      end
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
