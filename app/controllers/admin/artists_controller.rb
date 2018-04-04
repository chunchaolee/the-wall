class Admin::ArtistsController < Admin::BaseController

  before_action :set_artist, only: [:update, :destroy]

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
      redirect_to admin_artists_path
      flash[:notice] = "成功建立藝人名稱"
    else
      @artists = Artist.all
      render :index
    end
    Admin::Stream.check_event_artist(@artist)
  end

  def update
    if @artist.update(artist_params)
      redirect_to admin_artists_path
      flash[:notice] = "成功更新藝人名稱"
    else
      @artists = Artist.all
      render :index
    end
    Admin::Stream.update_relative_events(@artist)
    Admin::Stream.check_event_artist(@artist)
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

end
