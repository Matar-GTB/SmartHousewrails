class Admin::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin
  before_action :set_user, only: [:edit, :update, :destroy]

  # GET /admin/users
  def index
    @users = if params[:pending] == "true"
               User.where(approved: false).order(created_at: :asc)
             else
               User.all.order(created_at: :asc)
             end

    respond_to do |format|
      format.html
      format.csv { send_data @users.to_csv, filename: "users.csv" }
    end
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
      params.require(:user).permit(:points, :admin, :approved)
    end
end

class UsersController < ApplicationController
  def index
    @users = User.all.order(:created_at)
  end

  def show
    @user = User.find(params[:id])
  end
end
