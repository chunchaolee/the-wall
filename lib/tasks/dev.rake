namespace :dev do

  # fetch artists from the wall
  task fetch_artists: :environment do
    Artist.destroy_all

    # 1..1785
    for i in 1..1785 do
      url = "https://api-staging.thewall.tw/artists/" + "#{i}"

      begin
       response = RestClient.get(url)
       # puts response
      rescue RestClient::ExceptionWithResponse => err
        err.response
        next
      end
      
      data = JSON.parse(response.body)
      # puts data

      Artist.create!(
        name: data["artist"]["name"],
        detail: data["artist"]["profile"] != nil,
        thewall_artist_id: data["artist"]["id"]
      )
      
      puts "save artist #{data["artist"]["id"]}"
    end
    
    puts "now there are #{Artist.all.size} artists"
  end

  # fetch youtube videos
  task fetch_video: :environment do

    Event.all.each do |event|
      searching = event.artist_name.to_s
      yt_config = Rails.application.config_for(:youtube)
      
      if searching != nil
        url = "https://www.googleapis.com/youtube/v3/search?part=snippet&key=" + yt_config["app_id"] + "&q=" + searching + "&type=video&maxResults=1"

        response = RestClient.get(URI::encode(url))
        data = JSON.parse(response.body)

        if data["items"] != []
          id = data["items"][0]["id"]["videoId"]

          event.video = "https://www.youtube.com/embed/" + id + "?enablejsapi=1"
          event.save

          puts "save video url"
          puts "video: #{event.video}"
        else
          puts "found no video"
        end
      end
    end

  end

  ## find artist from detail
  task find_artist: :environment do

    Event.all.each do |event|
      Artist.all.each do |artist|
        if event.detail.include?(artist.name)
          event.artist_name = artist.name
          event.save
          break
        end
      end
    end

    puts "done!"

  end


  task fake_user: :environment do
    20.times do |i|
      name = FFaker::Name::first_name

      user = User.new(
        name: name,
        email: "#{name}@example.co",
        password: "12345678",
        provider: ["Facebook", "Spotify", nil ].sample,
        is_admin: [true, false].sample
      )

      user.save!
      puts user.name
    end
  end

  # create artists
  task create_artists: :environment do
    Artist.destroy_all

    artist_array = [
      "PEOPLEJAM",
      "Thank You For Getting Lung Cancer",
      "Nico'o & The kapiolani Boyz",
      "the Minnesota Voodoo Men",
      "Little Shy On Allen Street",
      "Emerging from the cocoon",
      "FUTURE AFTER A SECOND",
      "GREEN EYED MONSTER",
      "The Wedding Present",
      "THE REAGGE RIDDIMS",
      "Czecho No Republic",
      "Thy Art Is Murder",
      "知更 John Stoniae",
      "Taiko Super Kicks",
      "my little airport",
      "Instinct of Sight",
      "Greedy Black Hole",
      "Falling In Reverse",
      "Rafael Bittencourt",
      "Taiko Super Kicks",
      "Vanilla Acoustic",
      "Fujiya & Miyagi",
      "Yogee New Waves",
      "I am Puzzle man",
      "FROZEN CAKE BAR",
      "ShinSight Trio",
      "Anderson .Paak",
      "Fifth-Newheavy",
      "The Roadside Inn",
      "Defeat The Giant",
      "Salamander",
      "Yawai Mawlin",
      "The Solutions",
      "Rainer Maria",
      "JAM Project",
      "Beach Fossils",
      "Swimbrights",
      "MONKEY MAJIK",
      "Yutaro Ogida",
      "Rudra's Sage",
      "UN AVEC DEUX",
      "Wild Nothing",
      "Chad Valley",
      "LUCKY TAPES",
      "Eiji Kadota",
      "Mac Demarco",
      "The Notwist",
      "Manic Sheep",
      "Deca joins",
      "SE SO NEON",
      "Noise book",
      "Main Line 10",
      "Dement3d Records",
      "Baek A Yeon",
      "Cosmo Pyke",
      "THE ANDS",
      "Peter Sagar",
      "Shin-Ski",
      "Endtrocity",
      "Homeshake",
      "Begräbnis",
      "Soundbase",
      "earthists.",
      "Iron & Wine",
      "Daniel Powter",
      "kiiyama shoten",
      "Mikael Jonasson",
      "Mary See the Future",
      "Phum Viphurit",
      "Puzzleman",
      "Rudra's Sage",
      "Deeply Rooted",
      "subyub lee",
      "Dizparity",
      "DJ Mykal",
      "I Mean Us",
      "Dystopia",
      "MADZINE",
      "The Fur.",
      "DJ TXAKO",
      "P!SCO",
      "Shlømo",
      "DJ Ryow",
      "Face ON",
      "Hitorie",
      "The Fin.",
      "Phoenix",
      "Everfor",
      "Shigeto",
      "R-Shitei",
      "JAMES ARIES",
      "AURORA HALAL",
      "JOHN TALABOT",
      "LUJIACHI",
      "FRANCOIS X",
      "Andy Chiu",
      "NDRU INNERWORK",
      "STEVE BICKNELL",
      "Samuli Kemppi",
      "The Mystery Lights",
      "Vulture Disaster",
      "Young Marco",
      "vuLner",
      "Peatle",
      "ASHEN",
      "Heize",
      "Masego",
      "VOOID ",
      "Mr. Big",
      "SHAM 69",
      "Yngel",
      "Retch",
      "tricot",
      "VICE CITY",
      "angra",
      "Suuns",
      "OVDS",
      "Yuck",
      "DIIV",
      "POMO",
      "Voli",
      "9m88",
      "DJ Paige",
      "Minijay",
      "FKJ",
      "toe",
      "Dasu",
      "The Game Shop",
      "神經博士 Dr. Geek",
      "Nancy Leung 呀嬋",
      "seaweed 藻樂團",
      "大霈 X Victor",
      "八十八顆芭樂籽",
      "三十萬年老虎鉗",
      "鹿比 ∞ 吠陀 ",
      "偽造成人計画",
      "Violet Lens 紺",
      "LOGOS樂高斯樂團",
      "飛行荷蘭人 The Flying Dutchman",
      "壞蛋王・老五",
      "血肉果汁機",
      "麻花捲怪獸",
      "貳伍吸菸所",
      "秋瀾九十九",
      "梅西的房間",
      "脆弱少女組",
      "莉莉周她說",
      "沙沙小樂團",
      "南方壞男孩",
      "PiA吳蓓雅",
      "森林木樂團",
      "阿克曼樂團",
      "April Red 紅",
      "懶散暴徒樂團",
      "SADOG人間",
      "才能有限公司",
      "TOBE樂團",
      "面向異日",
      "先知瑪莉",
      "眼鏡小胖",
      "理化兄弟",
      "自由落體",
      "嵐馨樂團",
      "貝克小姐",
      "應許之地",
      "鱷魚樂團",
      "秋夜慢跑",
      "等等樂團",
      "睡帽樂團",
      "私人視線",
      "獨立人種",
      "問題總部",
      "房東的貓",
      "大象體操",
      "培根巴掌",
      "勞動服務",
      "羊與馬群",
      "感覺莓果",
      "海豚刑警",
      "雀斑樂團",
      "冨田麗香",
      "深深一擊",
      "傷心欲絕",
      "十字路口",
      "非人物種",
      "顯然樂隊",
      "張三李四",
      "粉紅噪音",
      "原子邦妮",
      "迷幻香菇",
      "恆月三途",
      "冰霜之淚",
      "木頭超人",
      "自由引力",
      "平克孩子",
      "屁孩隊長",
      "榖製浪板",
      "沙羅曼蛇",
      "高浩哲",
      "奮樂團",
      "莊俊寅",
      "藍又時",
      "張芸京",
      "七號青",
      "朝瀬蘭",
      "賴軍諺",
      "郭達年",
      "許皓筌",
      "宋東玲",
      "賴儀婷",
      "張之謙",
      "陳明章",
      "林生祥",
      "王嘉儀",
      "牛奶白",
      "魏如萱",
      "脆樂團",
      "柯泯薰",
      "李宣榕",
      "四葉草",
      "李佳薇",
      "害喜喜",
      "糯米糰",
      "滅火器",
      "瓦曼倫",
      "塞磐赦",
      "黃宇寒",
      "許含光",
      "逆瓣膜",
      "夏寧杉",
      "曾立馨",
      "豪古雞",
      "黃瑞豐",
      "徐崇育",
      "許郁瑛",
      "潮肩帶",
      "葉翊忻",
      "蔡晧怡",
      "林后進",
      "簡小豪",
      "佬步槍",
      "餵飽豬",
      "謎路人",
      "暴噬者",
      "孔雀眼",
      "徐宏愷",
      "何韻詩",
      "洪安妮",
      "重擊者",
      "詹森淮",
      "吟遊家",
      "赤世代",
      "李拾壹",
      "蘭花刀",
      "盧廣仲",
      "王宏恩",
      "徐宏愷",
      "廢結合",
      "詹森淮",
      "魏嘉瑩",
      "賴蔓蒂",
      "王彙筑",
      "許郁瑛",
      "飯匙槍",
      "嘻扣",
      "激膚",
      "雨國",
      "林苑",
      "渣泥",
      "唐貓",
      "樂夏",
      "王立",
      "舒喆",
      "丁曄",
      "藍婷",
      "暴君",
      "キュウソネコカミ",
      "カネコアヤノ",
      "キネマズ"
                  ]

    artist_array.each do |artist|
      Artist.create!(name: artist)
    end
    puts "create #{Artist.all.count} artists"

  end 

  

end