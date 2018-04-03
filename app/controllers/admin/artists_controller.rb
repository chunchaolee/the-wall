class Admin::ArtistsController < ApplicationController

  # 後台權限認證
  before_action :authenticate_user!
  before_action :authenticate_admin
  before_action :set_artist, only: [:update, :destroy]

  ALLOW_QUERIES = %w[s created_at updated_at name_cont].freeze

  def index
    # ransack
    @q = Artist.ransack(ransack_params)
    @artists = @q.result(distinct: true).order(created_at: :desc)

    if params[:id]
      @artist = Artist.find(params[:id])
    else
      @artist = Artist.new
    end

  end

  def create
    @artist = Artist.new(artist_params)
    if @artist.save
      redirect_to admin_artists_path
      flash[:notice] = "成功建立藝人名稱"
    else
      @artists = Artist.all
      render :index
    end
    check_event_artist(@artist)
  end

  def update
    if @artist.update(artist_params)
      redirect_to admin_artists_path
      flash[:notice] = "成功更新藝人名稱"
    else
      @artists = Artist.all
      render :index
    end
    update_relative_events(@artist)
  end

  def destroy
    @artist.destroy
  end



  private

  def set_artist
    @artist = Artist.find(params[:id])
  end

  def ransack_params
    if params[:q].present?
      params.require(:q).permit(*ALLOW_QUERIES)
    end
  end

  def artist_params
    params.require(:artist).permit(:name)
  end

  def check_event_artist(artist)

    @events = Event.all
    @events.each do |event|

      if event.artist_name == nil || event.artist_name == ""
        if event.title.include?(artist.name)
          event.artist_name = artist.name
          event.artist_id = artist.id
          # YT
          searching = artist.name
          # local用
          # yt_config = Rails.application.config_for(:youtube)
          # url = "https://www.googleapis.com/youtube/v3/search?part=snippet&key=#{yt_config["app_id"]}&q=#{searching}&type=video&maxResults=1"
          # heroku用
          url = "https://www.googleapis.com/youtube/v3/search?part=snippet&key=#{ENV['YOUTUBE_APP_ID']}&q=#{searching}&type=video&maxResults=1"
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
          serching = artist.name
          # local用
          # yt_config = Rails.application.config_for(:youtube)
          # url = "https://www.googleapis.com/youtube/v3/search?part=snippet&key=#{yt_config["app_id"]}&q=#{searching}&type=video&maxResults=1"
          # heroku用
          url = "https://www.googleapis.com/youtube/v3/search?part=snippet&key=#{ENV['YOUTUBE_APP_ID']}&q=#{searching}&type=video&maxResults=1"
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

  def update_relative_events(artist)
    @events = artist.events
    @events.each do |event|
      if (event.video != nil && event.video != "" && event.spotify_artist_id != nil && event.spotify_artist_id != "") || ((event.video != nil && event.video != "") || (event.spotify_artist_id != nil && event.spotify_artist_id != ""))
        event.artist_name = artist.name
        event.artist_id = artist.id
        event.save!
      else
        check_event_artist(artist)
      end
    end
  end

end
