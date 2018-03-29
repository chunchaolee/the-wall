class InterestsController < ApplicationController

  def create
    @interest = current_user.interests.build(event_id: params[:event_id])
    @event = Event.find(params[:event_id])
    if @interest.save
      NotificationMailer.event_notification(@interest).deliver_later!
      # NotificationMailer.event_notification(@interest).deliver_now
      # redirect_back(fallback_location: root_path)
    else
      flash[:alert] = @interest.errors.full_messages.to_sentence
      # redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @interest = current_user.interests.where(event_id: params[:id]).first
    @interest.destroy
    # redirect_back(fallback_location: root_path)
  end
  
end
