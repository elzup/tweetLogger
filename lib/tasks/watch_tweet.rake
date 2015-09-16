namespace :watch_tweet do
  desc 'ストリーミングで位置情報付きツイートを監視'
  # NOTE: :environment で model にアクセス
  task :run => :environment do
    Log.create({ :tweet_id => 644134010344464384, :lat => 1.234, :lon => 9.876})
  end
end
