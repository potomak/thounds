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
    
    # http://developers.thounds.com/API/HomeStream
    describe "GET home" do
      before do
        stub_get("home")
      end
      
      it "should use 'home' request path" do
        Thounds.home {|r| r}.proxy.path.should == "home"
      end
    end
    
    # http://developers.thounds.com/API/UserMetadata
    describe "GET profile" do
      before do
        stub_get("profile")
      end
      
      it "should use 'profile' request path" do
        Thounds.profile {|r| r}.proxy.path.should == "profile"
      end
    end
    
    # http://developers.thounds.com/API/UserMetadata
    describe "GET users/123" do
      before do
        stub_get("users/123")
      end
      
      it "should use 'users/123' request path" do
        Thounds.users(123) {|r| r}.proxy.path.should == "users/123"
      end
    end
    
    # http://developers.thounds.com/API/UserBand
    # http://developers.thounds.com/API/UserLibrary
    # http://developers.thounds.com/API/UserNotifications
    ["band", "library", "notifications"].each do |member|
      describe "GET profile/#{member}" do
        before do
          stub_get("profile/#{member}")
        end

        it "should use 'profile/#{member}' request path" do
          Thounds.profile.send(member) {|r| r}.proxy.path.should == "profile/#{member}"
        end
      end
    end
    
    # http://developers.thounds.com/API/UserBand
    # http://developers.thounds.com/API/UserLibrary
    ["band", "library"].each do |member|
      describe "GET users/123/#{member}" do
        before do
          stub_get("users/123/#{member}")
        end

        it "should use 'users/123/#{member}' request path" do
          Thounds.users(123).send(member) {|r| r}.proxy.path.should == "users/123/#{member}"
        end
      end
    end
    
    # http://developers.thounds.com/API/UserRegistration
    describe "POST users" do
      before do
        stub_post("users")
        
        @options = {
          :user => {
            :name => "John Doe",
            :email => "john@doe.com",
            :country => "Italy",
            :city => "Roma",
            :tags => "jazz vocal"
          }
        }
        @request = Thounds.users.post(@options) {|r| r}
      end
      
      it "should use 'users' request path" do
        @request.proxy.path.should == "users"
      end
      
      it "should use POST request verb" do
        @request.proxy.verb.should == :post
      end
      
      it "should include new user parameters into request" do
        @request.proxy.options.should == @options
      end
    end
    
    # http://developers.thounds.com/API/FriendshipRequest
    describe "POST users/123/friendships" do
      before do
        stub_post("users/123/friendships")
        
        @request = Thounds.users(123).friendships.post {|r| r}
      end
      
      it "should use 'users/123/friendships' request path" do
        @request.proxy.path.should == "users/123/friendships"
      end
      
      it "should use POST request verb" do
        @request.proxy.verb.should == :post
      end
    end
    
    # http://developers.thounds.com/API/FriendshipAcceptRefuse
    # http://developers.thounds.com/API/FriendshipDelete
    [:put, :delete].each do |verb|
      describe "#{verb.to_s.upcase} profile/friendships/123" do
        before do
          send("stub_#{verb}", "profile/friendships/123")

          @request = Thounds.profile.friendships(123).send(verb) {|r| r}
        end

        it "should use 'profile/friendships/123' request path" do
          @request.proxy.path.should == "profile/friendships/123"
        end

        it "should use #{verb.to_s.upcase} request verb" do
          @request.proxy.verb.should == verb
        end
      end
    end
    
    # http://developers.thounds.com/API/ThoundMetadata
    # http://developers.thounds.com/API/ThoundDelete
    [:get, :delete].each do |verb|
      describe "#{verb.to_s.upcase} thounds/123" do
        before do
          send("stub_#{verb}", "thounds/123")

          @request = Thounds.thounds(123).send(verb) {|r| r}
        end

        it "should use 'thounds/123' request path" do
          @request.proxy.path.should == "thounds/123"
        end

        it "should use #{verb.to_s.upcase} request verb" do
          @request.proxy.verb.should == verb
        end
      end
    end
    
    # http://developers.thounds.com/API/ThoundPublicStream
    describe "GET thounds/public_stream" do
      before do
        stub_get("thounds/public_stream")
      end
      
      it "should use 'thounds/public_stream' request path" do
        Thounds.thounds.public_stream {|r| r}.proxy.path.should == "thounds/public_stream"
      end
    end
    
    # http://developers.thounds.com/API/ThoundSearch
    describe "GET thounds/search" do
      before do
        stub_get("thounds/search?q=query")
        
        @options = {:q => "query"}
        @request = Thounds.thounds.search(@options) {|r| r}
      end

      it "should use 'thounds/search' request path" do
        @request.proxy.path.should == "thounds/search"
      end
      
      it "should include new user parameters into request" do
        @request.proxy.options.should == @options
      end
    end
    
    # http://developers.thounds.com/API/TrackCreate
    # http://developers.thounds.com/API/ThoundCreate
    describe "POST tracks" do
      before do
        stub_post("tracks")
        
        @options = {
          :track => {
            :delay => 0,
            :offset => 0,
            :duration => 0,
            :lat => 45.4375,
            :lng => 12.3358,
            :title => "My new default thound!",
            :privacy => "contacts",
            :thound_attributes => {
              :bpm => 90
            },
            :tag_list => "vocal jazz",
            :thoundfile => "SUQzB...",
            :coverfile => "iVBOR..."
          }
        }
        @request = Thounds.tracks.post(@options) {|r| r}
      end
      
      it "should use 'tracks' request path" do
        @request.proxy.path.should == "tracks"
      end
      
      it "should use POST request verb" do
        @request.proxy.verb.should == :post
      end
      
      it "should include new track parameters into request" do
        @request.proxy.options.should == @options
      end
    end
    
    # http://developers.thounds.com/API/TrackDelete
    describe "DELETE tracks/123" do
      before do
        stub_delete("tracks/123")
        
        @request = Thounds.tracks(123).delete {|r| r}
      end
      
      it "should use 'tracks/123' request path" do
        @request.proxy.path.should == "tracks/123"
      end
      
      it "should use DELETE request verb" do
        @request.proxy.verb.should == :delete
      end
    end
    
    # http://developers.thounds.com/API/TrackNotificationsDelete
    describe "DELETE track_notifications/123" do
      before do
        stub_delete("track_notifications/123")
        
        @request = Thounds.track_notifications(123).delete {|r| r}
      end
      
      it "should use 'track_notifications/123' request path" do
        @request.proxy.path.should == "track_notifications/123"
      end
      
      it "should use DELETE request verb" do
        @request.proxy.verb.should == :delete
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
