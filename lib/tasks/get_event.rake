# require 'koala'
# require 'json'
namespace :get_event do
  task fb_event: :environment do

    # access_token and other values aren't required if you set the defaults as described above

    # fb_config = Rails.application.config_for(:facebook)
    # fb_config["api_token"]
    # @graph = Koala::Facebook::API.new(fb_config["api_token"])

    # # 遠端專用
    config.omniauth :facebook
    @graph = Koala::Facebook::API.new(ENV['FACEBOOK_API_TOKEN'])

    page_array = ["LegacyHomePage",
                  "thewall.tw",
                  "pipelivemusic",
                  "RevolverTW",
                  #"%E5%A5%B3%E5%B7%AB%E5%BA%97-133362243371354", 粉絲團未公開資訊給API
                  "moonromantictw",
                  "Riverside.Music"
                ]
                page_array =["Riverside.Music"]
    # 獲取資訊: 活動
    # 
    node_type = "events"
    node_type = "events?fields=id,name,description,place,start_time,cover" 
    # get posts with standard content
    page_array.each do |page_name|
      # 限制筆數 limit: 10
      posts_standard = @graph.get_connections(page_name, node_type, limit:10)
      # posts_standard = @graph.get_connections(page_name, node_type)

      posts_standard.each do |list|
        temp = JSON.parse(list.to_json)
        
        # puts   temp["cover"] != nil ? temp["cover"]["source"]: "no imgage"
        # puts temp["place"]["location"] != nil ?  temp["place"]["location"]["city"] : "no city"
        # 活動宣傳照
        # puts temp["cover"]["source"]
        # 活動專屬id, 可以存這個id在db, 每次可以比對若存在則不將資料寫入db
        # puts  temp["id"] 
        # # 活動名稱
        # puts  temp["name"] 
        # # 活動預計開始時間, 判斷執行爬蟲當天日期若大於活動日,也不寫資料進db
        # puts  temp["start_time"]
        # # 活動預計結束時間
        # puts  temp["end_time"]  
        # # 活動描述
        # puts  temp["description"] 
        # # 活動地點
        # puts  temp["place"]["name"]
        # # 活動地點專屬id, 
        # puts  temp["place"]["id"]
        # puts  temp["place"]["location"]["city"]
        # puts  temp["place"]["location"]["street"]
        # puts  temp["cover"]
        # event.time = temp["start_time"].split('T')[1]
        # event.title = temp["name"] 
        # 日期
        # puts temp["start_time"].slice(0..9) 
        # # 時間
        # puts temp["start_time"].slice(11..temp["start_time"].length) 
        # # 日期
        # puts temp["start_time"].split('T')[0]
        # # 時間
        # puts temp["start_time"].split('T')[1]
        day =  temp["start_time"].split('T')[0]
        show_time = Time.new(day.split('-')[0], day.split('-')[1], day.split('-')[2]) 
        # 當天日期若已超過活動日, 則代表後續的活動都不需要寫入資料庫
        break if show_time < Time.now
        
        # 活動若已存在Event, 則跳過
        next if Event.exists?(special_id: temp["id"])

        Event.create!(
          special_id: temp["id"],
          title: temp["name"],
          date: show_time,
          time: temp["start_time"].split('T')[1],
          city: temp["place"]["location"] != nil ? temp["place"]["location"]["city"] : nil,
          detail: temp["description"] ,
          stage: temp["place"]["name"],
          img: temp["cover"] != nil ?temp["cover"]["source"] : nil
            )
        puts "save to event"  
      end
    puts "Finished for #{page_name}"  
    end
  end


  # add find_artist_name and fetch_video 
  task fb_event_new: :environment do

    # 刪除過期Event
    @events = Event.all
    @events.each do |event|
      if event.date < Date.today
        event.destroy
        puts "Destroy the event"
      end
    end

    # Event.destroy_all
    # access_token and other values aren't required if you set the defaults as described above
    
    if Rails.env.development?
      # local用
      fb_config = Rails.application.config_for(:facebook)
      @graph = Koala::Facebook::API.new(fb_config["api_token"])
    elsif Rails.env.production?
      # heroku用
      @graph = Koala::Facebook::API.new(ENV['FACEBOOK_API_TOKEN'])
    end

    page_array = ["LegacyHomePage",
                  "thewall.tw",
                  "pipelivemusic",
                  "RevolverTW",
                  #"%E5%A5%B3%E5%B7%AB%E5%BA%97-133362243371354", 粉絲團未公開資訊給API
                  "moonromantictw",
                  "Riverside.Music",
                  "Kornertw"
                ]
    # 獲取資訊: 活動
    node_type = "events?fields=id,name,description,place,start_time,cover" 
    # get posts with standard content
    page_array.each do |page_name|
      # 限制筆數 limit: 1
      posts_standard = @graph.get_connections(page_name, node_type)
      # posts_standard = @graph.get_connections(page_name, node_type)
      if posts_standard != nil
        posts_standard.each do |list|
          temp = JSON.parse(list.to_json)

          day =  temp["start_time"].split('T')[0]
          show_time = Time.new(day.split('-')[0], day.split('-')[1], day.split('-')[2]) 
          # 當天日期若已超過活動日, 則代表後續的活動都不需要寫入資料庫
          break if show_time < Time.now
          
          # 活動若已存在Event, 則跳過
          next if Event.exists?(special_id: temp["id"])

          # 比對 title/detail 的 artist name
          temp_name = nil
          temp_artist_id = nil
          Artist.all.each do |artist|
            match_name = artist.name
            title = temp["name"].strip() if temp["name"] != nil
            if artist.name != nil && temp["name"] != nil && title.include?(match_name)
              temp_name = artist.name
              temp_artist_id = artist.id
              puts temp_name + "find in title"
              break
            else
              if temp["description"] != nil 
                details = temp["description"].strip().split(/\n/).each do |line|
                  match_name = artist.name.strip()
                  # puts temp["description"]
                  if artist.name != nil && line.include?(match_name)
                    temp_name = artist.name
                    temp_artist_id = artist.id
                    puts temp_name + "find in detail"
                    break
                  end
                end
              end
            end
          end

          # # 比對 detail 與 artist name
          # temp_name = nil
          # Artist.all.each do |artist|
          #   # puts artist.name
          #   # puts temp["description"]
          #   if artist.name != nil && temp["description"].include?(artist.name)
          #     temp_name = artist.name
          #     break
          #   end
          # end

          # fetch youtube video
          if temp_name != nil  
            temp_video = nil
            searching = temp_name

            if Rails.env.development?
              # local用
              yt_config = Rails.application.config_for(:youtube)
              url = "https://www.googleapis.com/youtube/v3/search?part=snippet&key=#{yt_config["app_id"]}&q=#{searching}&type=video&maxResults=1"
            elsif Rails.env.production?
              # heroku用
              url = "https://www.googleapis.com/youtube/v3/search?part=snippet&key=#{ENV['YOUTUBE_APP_ID']}&q=#{searching}&type=video&maxResults=1"
            end

            response = RestClient.get(URI::encode(url))
            data = JSON.parse(response.body)

            if data["items"] != []
              id = data["items"][0]["id"]["videoId"]
              temp_video = "https://www.youtube.com/embed/#{id}?enablejsapi=1"
            else
              puts "found no video"
            end
          end

          begin

            # 建立活動
            Event.create!(
            artist_name: temp_name,
            artist_id: temp_artist_id,
            special_id: temp["id"],
            title: temp["name"],
            date: show_time,
            time: temp["start_time"].split('T')[1],
            city: temp["place"]["location"] != nil ? temp["place"]["location"]["city"] : nil,
            detail: temp["description"] ,
            stage: temp["place"]["name"],
            video: temp_video,
            img: temp["cover"] != nil ?temp["cover"]["source"] : nil
              )

          rescue
            puts $!
            next
          end

          puts temp_name
          puts "save to event"  
        end
      puts "Finished for #{page_name}"
      end

      puts "now have #{Event.all.count} events"
    end
  end
end