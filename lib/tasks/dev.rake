namespace :dev do

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

  # create artists
  task create_artists: :environment do
    Artist.destroy_all

    artist_array = ["大霈",
                    "睡帽樂團",
                    "黃宇寒",
                    "房東的貓",
                    "大象體操",
                    "The Notwist",
                    "The Wedding Present",
                    "Hitorie",
                    "Czecho No Republic",
                    "OVDS",
                    "許含光",
                    "SE SO NEON",
                    "Manic Sheep",
                    "Yogee New Waves",
                    "Noise book",
                    "逆瓣膜",
                    "八十八顆芭樂籽",
                    "B Festival",
                    "等等樂團",
                    "To · Night",
                    "夏寧杉",
                    "曾立馨",
                    "豪古雞",
                    "勞動服務",
                    "黃瑞豐",
                    "徐崇育",
                    "許郁瑛",
                    "潮肩帶",
                    "問題總部",
                    "林苑",
                    "葉翊忻",
                    "瓦曼倫",
                    "獨立人種",
                    "羊與馬群",
                    "蔡晧怡",
                    "Nico'o & The kapiolani Boyz",
                    "The KORS",
                    "林后進",
                    "Everfor",
                    "The Fur.",
                    "感覺莓果",
                    "簡小豪",
                    "Noise Book",
                    "佬步槍",
                    "餵飽豬",
                    "脆弱少女組",
                    "莉莉周她說",
                    "海豚刑警",
                    "JAM BOUND",
                    "雀斑樂團",
                    "I am Puzzle man",
                    "Rudra's Sage",
                    "Kenjiii",
                    "Yngel",
                    "冨田麗香",
                    "Yutaro Ogida",
                    "彩色天穹",
                    "貳伍吸菸所 ",
                    "知更 John Stoniae",
                    "神經博士 Dr. Geek",
                    "Bacon Slap 培根巴掌！",
                    "應許之地 ha-Aretz",
                    "Face ON",
                    "Fifth-Newheavy",
                    "トリコンドル",
                    "Endtrocity 暴行終止",
                    "vuLner",
                    "Retch",
                    "Begräbnis",
                    "塞磐赦 Serpenzer",
                    "UN AVEC DEUX",
                    "PEOPLEJAM",
                    "DJ TXAKO",
                    "THE REAGGE RIDDIMS",
                    "Dystopia",
                    "FUTURE AFTER A SECOND",
                    "私人視線 Private Eyesight",
                    "FROZEN CAKE BAR",
                    "偽造成人計画The Fake Adult Project",
                    "SOUNDBASE"
                  ]

    artist_array.each do |artist|
      Artist.create!(name: artist)
    end
    puts "create #{Artist.all.count} artists"

  end 

  # find artist from detail
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

end