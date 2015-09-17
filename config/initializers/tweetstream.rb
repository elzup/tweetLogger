twitter_conf = Rails.application.secrets.twitter_app
if twitter_conf['consumer_key'].nil?
  puts 'error: empty env values, twitter auth keys'
end
TweetStream.configure do |config|
  config.consumer_key       = twitter_conf['consumer_key']
  config.consumer_secret    = twitter_conf['consumer_secret']
  config.oauth_token        = twitter_conf['token_key']
  config.oauth_token_secret = twitter_conf['token_secret']
  config.auth_method        = :oauth
end
