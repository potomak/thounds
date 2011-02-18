#
# TO RUN TEST
# irb -r test.rb
#

#
# Thounds API paths
# 
# home                  => /home
# profile               => /profile
# profile_band          => /profile/band
# profile_library       => /profile/library
# profile_notifications => /profile/notifications
# profile_friendships   => /profile/friendships/:friendship_id
# users                 => /users
# users                 => /users/:user_id
# users_band            => /users/:user_id/band
# users_library         => /users/:user_id/library
# users_friendships     => /users/:user_id/friendships
# thounds               => /thounds/:thound_id
# thounds               => /thounds/:thound_hash
# thounds_public_stream => /thounds/public_stream
# thounds_search        => /thounds/search
# tracks                => /tracks
# tracks                => /tracks/:track_id
# track_notifications   => /track_notifications/:thound_id

require 'lib/thounds'

# puts "======================"
# puts "== Public resources =="
# puts "======================"
# 
# Thounds.thounds.public_stream do |thounds|
#   puts "Thounds.thounds.public_stream: #{thounds}"
# end

# thounds configuration
Thounds.configure do |config|
  config.consumer_key = "s4GaRKJE5qpYdz58tUfg"
  config.consumer_secret = "sfpcQXQ6vjQGkVMG6QX95XUym9Ng1bMMYvYqDJtW"
  config.oauth_token = "ih6CDX3LqWe5ko9YpDfA"
  config.oauth_token_secret = "B9hDILdmOAY0qK45QQo3X74inF1DwZeBTTIH0LAh"
end

puts "============================="
puts "== Authenticated resources =="
puts "============================="

# Thounds.profile do |profile|
#   puts "Thounds.profile.name: #{profile.name}"
#   puts "Thounds.profile.profile_url: #{profile.profile_url}"
# end
# 
# Thounds.profile.library do |thounds|
#   thounds['thounds-collection'].thounds[0].tracks[0].title
#   puts "Thounds.profile.library['thounds-collection'].thounds[0].tracks[0].title: #{thounds['thounds-collection'].thounds[0].tracks[0].title}"
# end
# 
# Thounds.profile.band do |users|
#   puts "Thounds.profile.band['friends-collection'].friends[0].name: #{users['friends-collection'].friends[0].name}"
# end
# 
# Thounds.profile.notifications do |notifications|
#   puts "Thounds.profile.notifications.band_requests[0].user.name: #{notifications.band_requests[0].user.name}"
# end
# 
# Thounds.users(171) do |user|
#   puts "Thounds.users(171).name: #{user.name}"
# end
#
# Thounds.users(241).friendships.post do |response|
#   puts "Thounds.users(241).friendships.post: #{response}"
# end

Thounds.profile.friendships(2920).delete do |response|
  puts "Thounds.profile.friendships(2920).delete: #{response}"
end