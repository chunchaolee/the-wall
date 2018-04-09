class Artist < ApplicationRecord
  
  require 'rspotify'

  validates_presence_of :name
  validates_uniqueness_of :name
  # 一個藝人可以有很多活動
  has_many :events

  def get_spotify_data

    artist_name = self.name
    return if artist_name.blank?

    if Rails.env.development?
      # local用
      spotify_config = Rails.application.config_for(:spotify)
      client_id = spotify_config["client_id"]
      client_secret = spotify_config["client_secret"]
    elsif Rails.env.production?
      # heroku用
      client_id = ENV['SPOTIFY_CLIENT_ID']
      client_secret = ENV['SPOTIFY_CLIENT__SECRET']
    end

    RSpotify.authenticate("#{client_id}", "#{client_secret}")
    artist = RSpotify::Artist.search(artist_name)
    artist_data = artist.first
  end


  def check_event_artist

    @events = Event.all
    @events.each do |event|
      next if event.artist_name.present?

      if event.title.include?(self.name) || event.detail.include?(self.name)
        event.artist_name = self.name
        event.artist_id = self.id
        event.video = self.artist_video
        event.spotify_artist_id = self.artist_spotify_id
        event.save! 
      end
    end

  end


  def update_relative_events
    @events = self.events
    @events.each do |event|
      event.artist_name = self.name
      event.video = self.artist_video
      event.spotify_artist_id = self.artist_spotify_id
      event.save!
    end
    self.check_event_artist
  end


  def create_stream_data

    searching = self.name
    
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
      self.artist_video = "https://www.youtube.com/embed/#{id}?enablejsapi=1"
    end

    # spotify
    spotify_data = self.get_spotify_data
    if spotify_data == nil
      self.artist_spotify_id = nil
    else
      self.artist_spotify_id = spotify_data.id
    end
    self.save!

  end


  def check_stream_data(temp_video, temp_spotify_id)

    if temp_video.blank? && temp_spotify_id.blank?
      if self.artist_video.blank?
        searching = self.name
        
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
          self.artist_video = "https://www.youtube.com/embed/#{id}?enablejsapi=1"
        end

        if self.artist_spotify_id.blank?
          # spotify
          spotify_data = self.get_spotify_data
          if spotify_data.blank?
            self.artist_spotify_id = nil
          else
            self.artist_spotify_id = spotify_data.id
          end
        end
        self.save!
      elsif self.artist_spotify_id.blank?
        # spotify
        spotify_data = self.get_spotify_data
        if spotify_data.blank?
          self.artist_spotify_id = nil
        else
          self.artist_spotify_id = spotify_data.id
        end
        self.save!
      end
    end

  end

end
