class Admin::ArtistsController < Admin::BaseController

  before_action :set_artist, only: [:update, :edit, :destroy]

  ALLOW_QUERIES = %w[s created_at updated_at name_cont].freeze

  def index
    # ransack
    @q = Artist.ransack(ransack_params)
    @artists = @q.result(distinct: true).order(updated_at: :desc).page(params[:page]).per(20)

    if params[:id]
      @artist = Artist.find(params[:id])
    else
      @artist = Artist.new
    end

  end

  def create
    @artist = Artist.new(artist_params)
    if @artist.save
      Admin::Stream.create_stream_data(@artist)
      Admin::Stream.check_event_artist(@artist)
      redirect_back(fallback_location: admin_artists_path)
      flash[:notice] = "成功建立藝人資料"
    else
      @q = Artist.ransack(ransack_params)
      @artists = @q.result(distinct: true).order(updated_at: :desc).page(params[:page]).per(20)
      render :index
    end
  end

  def update

    temp_video = @artist.artist_video
    temp_spotify_id = @artist.artist_spotify_id

    if @artist.update(artist_params)
      redirect_back(fallback_location: admin_artists_path)
      flash[:notice] = "成功更新藝人資料"
    else
      @artists = Artist.all
      render :index
    end

    Admin::Stream.check_stream_data(temp_video, temp_spotify_id, @artist)
    Admin::Stream.update_relative_events(@artist)
    Admin::Stream.check_event_artist(@artist)
  end

  def destroy
    @artist.destroy
  end

  def search
    @artist = Artist.find(params[:id])
    Admin::Stream.create_stream_data(@artist)
    Admin::Stream.update_relative_events(@artist)
    redirect_back(fallback_location: admin_artists_path)
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
    params.require(:artist).permit(:name, :artist_video, :artist_spotify_id)
  end

end
