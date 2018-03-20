class EventsController < ApplicationController

  def index
    @events = Event.all.order(date: :desc)
  end

  def show
    @event = Event.find(params[:id])
  end

end
