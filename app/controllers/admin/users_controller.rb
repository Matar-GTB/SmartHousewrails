
class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin
  before_action :set_user, only: [:edit, :update, :destroy]

  # GET /admin/users
  def index
    @users = User.all.order(created_at: :asc)
  end

  # GET /admin/users/:id/edit
  def edit
  end

  # PATCH/PUT /admin/users/:id
  def update
    if @user.update(admin_user_params)
      redirect_to admin_users_path, notice: "Utilisateur mis à jour."
    else
      render :edit, alert: "Erreur lors de la mise à jour."
    end
  end

  # DELETE /admin/users/:id
  def destroy
    if @user != current_user
      @user.destroy 
      redirect_to admin_users_path, notice: "Compte utilisateur supprimé."
    else
      redirect_to admin_users_path, alert: "Impossible de supprimer votre propre compte."
    end
  end

  private

    def require_admin
      redirect_to root_path, alert: "Accès non autorisé." unless current_user.admin?
    end

    def set_user
      @user = User.find(params[:id])
    end

    def admin_user_params
      # On ne permet à l'admin de modifier que certains champs du user
      params.require(:user).permit(:points, :admin)
    end
end
