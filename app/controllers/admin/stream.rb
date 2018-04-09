class Admin::Stream

  def self.check_event_artist(artist)

    @events = Event.all
    @events.each do |event|

      if event.artist_name == nil || event.artist_name == ""
        if event.title.include?(artist.name)
          event.artist_name = artist.name
          event.artist_id = artist.id
          event.video = artist.artist_video
          event.spotify_artist_id = artist.artist_spotify_id
          event.save!
        elsif event.detail.include?(artist.name)
          event.artist_name = artist.name
          event.artist_id = artist.id
          event.video = artist.artist_video
          event.spotify_artist_id = artist.artist_spotify_id
          event.save! 
        end
      end

    end

  end

  def self.update_relative_events(artist)
    @events = artist.events
    @events.each do |event|
      event.artist_name = artist.name
      if event.video != nil && event.video != "" && event.spotify_artist_id != nil && event.spotify_artist_id != ""
        event.video = artist.artist_video
        event.spotify_artist_id = artist.artist_spotify_id
        event.save!
      else
        event.video = artist.artist_video
        event.spotify_artist_id = artist.artist_spotify_id
        event.save!
        check_event_artist(artist)
      end
      
    end
  end

  def self.create_stream_data(artist)

    searching = artist.name
    
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
      artist.artist_video = "https://www.youtube.com/embed/#{id}?enablejsapi=1"
    end

    # spotify
    spotify_data = artist.get_spotify_data
    if spotify_data == nil
      artist.artist_spotify_id = nil
    else
      artist.artist_spotify_id = spotify_data.id
    end
    artist.save!

  end


  def self.check_stream_data(temp_video, temp_spotify_id, artist)

    if (temp_video == nil || temp_video == "") && (temp_spotify_id == nil || temp_spotify_id == "")
      if artist.artist_video == nil || artist.artist_video == ""
        searching = artist.name
        
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
          artist.artist_video = "https://www.youtube.com/embed/#{id}?enablejsapi=1"
        end

        if artist.artist_spotify_id == nil || artist.artist_spotify_id == ""
          # spotify
          spotify_data = artist.get_spotify_data
          if spotify_data == nil
            artist.artist_spotify_id = nil
          else
            artist.artist_spotify_id = spotify_data.id
          end
        end
        artist.save!
      elsif artist.artist_spotify_id == nil || artist.artist_spotify_id == ""
        # spotify
        spotify_data = artist.get_spotify_data
        if spotify_data == nil
          artist.artist_spotify_id = nil
        else
          artist.artist_spotify_id = spotify_data.id
        end
        artist.save!
      end
    end

  end

end