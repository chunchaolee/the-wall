class Admin::UsersController < Admin::BaseController

  ALLOW_QUERIES = %w[s id name name_cont email email_cont created_at provider provider_cont is_admin last_sign_in_at sign_in_count created_at_gteq created_at_lteq sign_in_count_gteq sign_in_count_lteq].freeze

  def index
    @users = User.all
    # ransack
    @q = User.ransack(ransack_params)
    @users = @q.result(distinct: true).page(params[:page]).per(20)
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
  end

  private 

  def ransack_params
    if params[:q].present?
      params.require(:q).permit(*ALLOW_QUERIES)
    end
  end

end
