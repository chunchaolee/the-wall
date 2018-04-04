class Admin::Stream

  def self.check_event_artist(artist)

    @events = Event.all
    @events.each do |event|

      if event.artist_name == nil || event.artist_name == ""
        if event.title.include?(artist.name)
          event.artist_name = artist.name
          event.artist_id = artist.id
          # YT
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
            event.video = "https://www.youtube.com/embed/#{id}?enablejsapi=1"
          end

          # spotify
          @spotify_data = event.get_spotify_data(artist.name)
          if @spotify_data == nil
            @spotify_artist_id = nil
          else
            event.spotify_artist_id = @spotify_data.id
          end

          event.save!

        elsif event.detail.include?(artist.name)
          event.artist_name = artist.name
          event.artist_id = artist.id
          # YT
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
            event.video = "https://www.youtube.com/embed/#{id}?enablejsapi=1"
          end

          # spotify
          @spotify_data = event.get_spotify_data(artist.name)
          if @spotify_data == nil
            @spotify_artist_id = nil
          else
            event.spotify_artist_id = @spotify_data.id
          end

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
        event.save!
      elsif  event.video == nil || event.video == ""
        event.artist_name = artist.name
        # YT
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
          event.video = "https://www.youtube.com/embed/#{id}?enablejsapi=1"
        end

        if event.spotify_artist_id == nil || event.spotify_artist_id == ""
          # spotify
          @spotify_data = event.get_spotify_data(artist.name)
          if @spotify_data == nil
            @spotify_artist_id = nil
          else
            event.spotify_artist_id = @spotify_data.id
          end
        end

        event.save!

      elsif event.spotify_artist_id == nil || event.spotify_artist_id == ""
        event.artist_name = artist.name
        # spotify
        @spotify_data = event.get_spotify_data(artist.name)
        if @spotify_data == nil
          @spotify_artist_id = nil
        else
          event.spotify_artist_id = @spotify_data.id
        end

        event.save!
          
      else
        check_event_artist(artist)
      end
      event.save!
      
    end
  end

end