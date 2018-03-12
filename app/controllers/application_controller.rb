class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # 加上自訂欄位name到Devise的註冊和編輯頁面
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    end

end
