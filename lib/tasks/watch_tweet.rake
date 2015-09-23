require 'date'
require 'json'

namespace :watch_tweet do
  desc 'ストリーミングで位置情報付きツイートを監視'
  # NOTE: :environment で model にアクセス
  task :run => :environment do
    puts 'load'
    filter = {:locations => '129.30,30.98,147.14,45.80'}
    # binding.pry
    libs = load_lib
    nm = Natto::MeCab.new

    TweetStream::Client.new.filter(filter) do |status|
      user = User.find_or_create_by({:twitter_user_id => status.user.id})
      tweet_id = status.id
      # HACK: to def, data binding check
      if status.geo.nil?
        next
      end
      lat, lon = status.geo.coordinates

      # HACK:
      point = calc_emotion_point(status.text, libs, nm)
      params = {
          :lat => lat,
          :lon => lon,
          :tweet_id => tweet_id,
          :emotion => point,
          :tweet_created_at => status.created_at
      }
      user.logs.build(params)
      user.save
      p "#{point} #{status.text}"
      p "\n\n"
    end
  end

  desc 'サンプルツイート'
  task :sample => :environment do
    p 'load sample'
    TweetStream::Client.new.filter({:locations => '-80.29,32.57,-79.56,33.09'}) do |status|
      puts "#{status.user.screen_name}: #{status.text}"
    end
  end

  def load_lib
    posi_lib_path = Rails.root.join('dict', 'posi.dict')
    nega_lib_path = Rails.root.join('dict', 'nega.dict')
    lib = []
    [posi_lib_path, nega_lib_path].each do |path|
      lines = IO.readlines(path)
      lines.each {|line| line.chomp!}
      lib << lines
    end
    lib
  end

  def calc_emotion_point(text, libs, nm)
    point = 0
    nm.parse(text) do |n|
      features = n.feature.split(',')
      # 原形を取得
      word = features[6]
      if libs[0].include? word
        point += 1
      elsif libs[1].include? word
        point -= 1
      end
    end
    [[point, 5].min, -5].max
  end
end
