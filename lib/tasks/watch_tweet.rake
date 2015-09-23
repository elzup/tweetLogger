require 'date'
require 'json'

namespace :watch_tweet do
  desc 'ストリーミングで位置情報付きツイートを監視'
  # NOTE: :environment で model にアクセス
  task :run => :environment do
    puts 'load'
    filter = {:locations => '129.30,30.98,147.14,45.80'}
    # binding.pry
    word_lib = load_lib()
    nm = Natto::MeCab.new

    TweetStream::Client.new.filter(filter) do |status|
      user = User.find_or_create_by({ :twitter_user_id => status.user.id })
      tweet_id = status.id
      # HACK: to def, data binding check
      if status.geo.nil?
        next
      end
      lat, lon = status.geo.coordinates

      # HACK:
      point = calc_emotion_point(status.text, word_lib, nm)
      p point
      params = {
          :lat => lat,
          :lon => lon,
          :tweet_id => tweet_id,
          :emotion => point,
          :tweet_created_at => status.created_at
      }
      user.logs.build(params)
      user.save
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

  def load_lib
    json_path = Rails.root.join('dict', 'pn_ja.json')
    lib = open(json_path) do |io|
      JSON.load(io)
    end
    lib
  end

  def calc_emotion_point(text, word_lib, nm)
      nm.parse(text) do |n|
        features = n.feature.split(',')
        # 品詞を取得
        speech = features[0]
        # 原形を取得
        word = features[6]
        if ! word_lib.key?(speech) or !word_lib[speech].key?(word)
          next
        end
        point += word_lib[speech][word].to_f
      end
  end
end
