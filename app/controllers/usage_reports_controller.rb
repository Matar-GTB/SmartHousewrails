class UsageReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_access, only: [:index]
  before_action :require_admin, only: [:admin]

  def index
    @user_devices = current_user.admin? ? Device.all : current_user.devices
    @total_data_points = @user_devices.sum { |device| device.device_data.count }
    @most_active_device = @user_devices.max_by { |device| device.device_data.count }
  end

  def admin
    @total_users = User.count
    @total_devices = Device.count
    @total_data_points = DeviceDatum.count
    @recent_data = DeviceDatum.order(created_at: :desc).limit(10)

    @total_energy = DeviceDatum.where(key: "consommation").pluck(:value).map(&:to_f).sum
  end

  private

  def require_access
    unless current_user&.advanced? || current_user.admin?
      redirect_to root_path, alert: "Accès réservé aux utilisateurs avancés ou admin."
    end
  end

  def require_admin
    redirect_to root_path, alert: "Accès réservé à l’administrateur." unless current_user.admin?
  end
end
