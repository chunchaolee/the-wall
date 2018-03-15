namespace :dev do

  task fetch_video: :environment do

    searching = "sodagreen"
    yt_config = Rails.application.config_for(:youtube)
    url = "https://www.googleapis.com/youtube/v3/search?part=snippet&key=" + yt_config["app_id"] + "&q=" + searching + "&type=video&order=viewcount&maxResults=1"

    response = RestClient.get(url)
    data = JSON.parse(response.body)
    id = data["items"][0]["id"]["videoId"]

    event = Event.first
    event.video = "https://www.youtube.com/embed/" + id + "?enablejsapi=1"
    event.save

    puts "save video url"
    puts "video: #{event.video}"
  end

end