class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  add_flash_types :success, :info, :warning, :danger

  def after_sign_in_path_for(resource)
    if resource.sign_in_count > 1
      super
    else
      # first time sign in
      edit_user_path
    end
  end
end
