namespace :watch_tweet do
  desc 'ストリーミングで位置情報付きツイートを監視'
  # NOTE: :environment で model にアクセス
  task :run => :environment do
    puts 'load'
    filter = {:locations => '129.30,30.98,147.14,45.80'}
    TweetStream::Client.new.filter(filter) do |status|
      p status.text
      user = User.find_or_create_by({:twitter_user_id => status.user.id})
      # binding.pry
      tweet_id = status.id
      lat, lon = status.geo.coordinates
      log = user.logs.build({:lat => lat, :lon => lon, :tweet_id => tweet_id})
      user.save
    end
  end

  desc 'サンプルツイート'
  task :sample => :environment do
    p 'load sample'
    TweetStream::Client.new.filter({:locations => '-80.29,32.57,-79.56,33.09'}) do |status|
      puts "#{status.user.screen_name}: #{status.text}"
    end
  end
end
