class EventsController < ApplicationController

  ALLOW_QUERIES = %w[s artist_name title city date time stage_eq views_count interests_count detail_cont].freeze

  def index
    @events = Event.all.order(date: :desc)
    # ransack
    @q = Event.ransack(ransack_params)
    @events = @q.result(distinct: true)

  end

  def show
    @event = Event.find(params[:id])
    artist_name = @event.artist_name
    
    if @event.spotify_artist_id == nil
      @spotify_data = Event.get_spotify_data(artist_name)
      if @spotify_data == nil
        @spotify_artist_id = nil
      else
        @spotify_artist_id = @spotify_data.id
        @event.spotify_artist_id = @spotify_artist_id
        @event.save
      end
    else
      @spotify_artist_id = @event.spotify_artist_id
    end
  end

  private 

  def ransack_params
    if params[:q].present?
      params.require(:q).permit(*ALLOW_QUERIES)
    end
  end

end
