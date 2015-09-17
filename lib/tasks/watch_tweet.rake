namespace :watch_tweet do
  desc 'ストリーミングで位置情報付きツイートを監視'
  # NOTE: :environment で model にアクセス
  task :run => :environment do
    TweetStream::Client.new.track('github') do |tweet|
      p tweet.text
    end
  end

  desc 'サンプルツイート'
  task :sample => :environment do
    p 'load'
    cli = TweetStream::Client.new
    p cli
    cli.sample do |status|
      p status
      if status.user.lang == "ja" && !status.text.index("RT")
        puts "#{status.user.screen_name}: #{status.text}"
      end
    end
  end
end
