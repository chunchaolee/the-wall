class EventsController < ApplicationController

  ALLOW_QUERIES = %w[s artist_name_cont title_cont city_cont date_cont time_cont stage_eq stage_cont views_count interests_count detail_cont artist_name_or_title_or_city_or_detail_or_stage_cont date_gteq date_lteq created_at city_eq].freeze

  def index
    # ransack
    @q = Event.ransack(ransack_params)
    @events = @q.result(distinct: true).order(date: :asc).page(params[:page]).per(12)

  end

  def show
    @event = Event.find(params[:id])

    # views count
    @event.count_views
    if current_user
      if current_user.viewed_events.include?(@event)
        @view = current_user.views.where(event_id: @event)
        @view.destroy_all
      end
      current_user.views.create(event_id: params[:id])
    end

    if @event.artist
      @artist = @event.artist
    else
      @artist = Artist.new
    end

  end

  def posts
    # ransack
    @q = Event.ransack(ransack_params)
    @events = @q.result(distinct: true).order(created_at: :desc).page(params[:page]).per(5)
    @popular_events = Event.all.order(interests_count: :desc).limit(5)
  end

  private 

  def ransack_params
    if params[:q].present?
      params.require(:q).permit(*ALLOW_QUERIES)
    end
  end

end
