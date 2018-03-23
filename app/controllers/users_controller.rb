class UsersController < ApplicationController

  before_action :set_user, only: [:edit, :update, :show]

  def show
    @interested_events = @user.interested_events.order("interests.created_at DESC")
    @viewed_events = @user.viewed_events.limit(8).order("views.created_at DESC")
  end

  def update
    # user validates
    if current_user == @user
      if @user.update_attributes(user_params)
        redirect_to root_url, :notice => "個人資料更新成功"
      else
        render :action => :edit
      end
    else
      redirect_to root_url, :alert => "您非該使用者，無法更變該使用者資料"
    end
  end


  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :name)
  end

end
