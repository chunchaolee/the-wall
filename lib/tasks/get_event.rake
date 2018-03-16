# require 'koala'
# require 'json'
namespace :get_event do
  task fb_event: :environment do
    # access_token and other values aren't required if you set the defaults as described above
    fb_config = Rails.application.config_for(:facebook)
    fb_config["api_token"]
    @graph = Koala::Facebook::API.new(fb_config["api_token"])
    
    page_array = ["LegacyHomePage",
                  "thewall.tw",
                  "pipelivemusic",
                  "RevolverTW",
                  #"%E5%A5%B3%E5%B7%AB%E5%BA%97-133362243371354", 粉絲團未公開資訊給API
                  "moonromantictw",
                  "Riverside.Music"
                ]
    # 獲取資訊: 活動
    node_type = "events"
    # get posts with standard content
    page_array.each do |page_name|
      # 限制筆數 limit: 1
      # posts_standard = @graph.get_connections(page_name, node_type, limit:1)
      posts_standard = @graph.get_connections(page_name, node_type)

      posts_standard.each do |list|
        temp = JSON.parse(list.to_json)
        d = DateTime.now
        d.strftime("%d/%m/%Y %H:%M")
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
        city: temp["place"]["location"]["city"],
        detail: temp["description"] ,
        stage: temp["place"]["name"]
          )
        puts "save to event"  
      end
    puts "Finished for #{page_name}"  
    end
  end
end

