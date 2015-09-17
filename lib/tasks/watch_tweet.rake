namespace :watch_tweet do
  desc 'ストリーミングで位置情報付きツイートを監視'
  # NOTE: :environment で model にアクセス
  task :run => :environment do
    puts 'load'
    filter = {:locations => '129.30,30.98,147.14,45.80'}
    TweetStream::Client.new.filter(filter) do |status|
      p status.text
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
