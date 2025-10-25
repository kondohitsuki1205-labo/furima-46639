class ApplicationController < ActionController::Base
  def configure_permitted_parameters
   added = %i[nickname last_name first_name last_name_kana first_name_kana birthday]
   devise_parameter_sanitizer.permit(:sign_up,        keys: added)
   devise_parameter_sanitizer.permit(:account_update, keys: added)
  end
end
