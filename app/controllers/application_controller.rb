class ApplicationController < ActionController::Base
  
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :age, :gender, :birthdate, :member_type, :first_name, :last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :age, :gender, :birthdate, :member_type, :first_name, :last_name, :password, :password_confirmation, :current_password])
  end

  def after_sign_in_path_for(resource)
    # +1 point à chaque connexion
    current_user.increment!(:points, 1) if resource.is_a?(User)
    super(resource)  # redirige vers le chemin par défaut (root_path)
  end
  helper_method :user_signed_in?, :current_user, :user_session
end
