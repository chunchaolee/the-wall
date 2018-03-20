class EventsController < ApplicationController

  def index
    @events = Event.all.order(date: :desc)
  end

end
