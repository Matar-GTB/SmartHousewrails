class ApplicationController < ActionController::Base
  # On définit une méthode pour accéder à Warden depuis l'environnement de la requête.
  def warden
    request.env['warden']
  end

  # Définir current_user explicitement en interrogeant Warden.
  def current_user
    @current_user ||= warden.authenticate(scope: :user)
  end

  # Définir user_signed_in? en vérifiant la présence de current_user.
  def user_signed_in?
    current_user.present?
  end

  # Définir user_session pour accéder à la session utilisateur via Warden.
  def user_session
    request.env['warden'].user(:user)
  end

  # Rendre ces méthodes disponibles dans toutes les vues.
  helper_method :current_user, :user_signed_in?, :user_session

  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    extra_keys = [:username, :age, :gender, :birthdate, :member_type, :first_name, :last_name]
    devise_parameter_sanitizer.permit(:sign_up, keys: extra_keys)
    devise_parameter_sanitizer.permit(:account_update, keys: extra_keys)
  end
  

  # Redirections après connexion/déconnexion 
  def after_sign_in_path_for(resource)
    # Ajouter 1 point à chaque connexion
  if resource.is_a?(User)
    resource.increment!(:points, 1)
    resource.update_level!
  end
    resource.admin? ? admin_dashboard_path : root_path
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end
