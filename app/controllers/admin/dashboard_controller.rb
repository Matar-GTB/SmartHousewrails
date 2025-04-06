
class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin

  def index
    @users_count   = User.count
    @devices_count = Device.count
    @latest_devices = Device.order(created_at: :desc).limit(5)
    @latest_users   = User.order(created_at: :desc).limit(5)
  end

  private

  def require_admin
    redirect_to root_path, alert: "Accès non autorisé." unless current_user.admin?
  end
end
