class Admin::EventsController < ApplicationController
  # 後台權限認證
  before_action :authenticate_user!
  before_action :authenticate_admin
  before_action :set_event, only: [:edit, :update, :destroy]

  ALLOW_QUERIES = %w[s artist_name_cont title_cont city_cont date_cont time_cont stage_eq stage_cont views_count interests_count detail_cont artist_name_or_title_or_city_or_detail_cont date_lteq date_gteq views_count_gteq interests_count_gteq].freeze

  def index
    @events = Event.all.order(date: :desc)
    # ransack
    @q = Event.ransack(ransack_params)
    @events = @q.result(distinct: true).order(date: :desc)
  end

  def update
    if current_user.is_admin
      if @event.update_attributes(event_params)
        flash[:notice] = "Admin功能：更新活動頁面成功"
        redirect_to admin_events_path
      else
        render :action => :edit
      end
    else
      flash[:alert] = "非Admin，無此權限"
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @event.destroy
  end

  private 

  def ransack_params
    if params[:q].present?
      params.require(:q).permit(*ALLOW_QUERIES)
    end
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:artist_name, :title, :date, :time, :stage, :video, :detail, :city, :stage, :spotify_artist_id)
  end

end
