class DeviceDataController < ApplicationController
  before_action :authenticate_user!
  before_action :set_device

  def create
    if current_user.advanced? || current_user.admin?
      @device.device_data.create(device_data_params)
      redirect_to @device, notice: "Donnée ajoutée avec succès."
    else
      redirect_to @device, alert: "Accès non autorisé."
    end
  end

  def destroy
    data = @device.device_data.find(params[:id])
    if current_user.admin?
      data.destroy
      redirect_to @device, notice: "Donnée supprimée."
    else
      redirect_to @device, alert: "Suppression non autorisée."
    end
  end

  private

  def set_device
    @device = Device.find(params[:device_id])
  end

  def device_data_params
    params.require(:device_datum).permit(:key, :value)
  end
end
