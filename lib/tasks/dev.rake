namespace :dev do

  task fetch_video: :environment do

    searching = Event.first.artist_name
    yt_config = Rails.application.config_for(:youtube)
    url = "https://www.googleapis.com/youtube/v3/search?part=snippet&key=" + yt_config["app_id"] + "&q=" + searching + "&type=video&order=viewcount&maxResults=1"

    response = RestClient.get(URI::encode(url))
    data = JSON.parse(response.body)

    if data["items"] != []
      id = data["items"][0]["id"]["videoId"]

      event = Event.first
      event.video = "https://www.youtube.com/embed/" + id + "?enablejsapi=1"
      event.save

      puts "save video url"
      puts "video: #{event.video}"
    else
      puts "found no video"
    end
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