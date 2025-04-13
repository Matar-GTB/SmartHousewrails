class StaticPagesController < ApplicationController
  helper_method :current_user, :user_signed_in?, :user_session
  def home
  end

  def about
  end

  def contact
  end

  def legal
  end
  def goodbye
    # Par exemple, affiche un message de déconnexion
  end
end
