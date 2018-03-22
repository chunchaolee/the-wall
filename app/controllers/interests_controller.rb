class InterestsController < ApplicationController

  def create
    @interest = current_user.interests.build(event_id: params[:event_id])

    if @interest.save
      redirect_back(fallback_location: root_path)
    else
      flash[:alert] = @interest.errors.full_messages.to_sentence
      redirect_back(fallback_location: root_path)
    end
  end

end
