class DeviceDataController < ApplicationController
  before_action :authenticate_user!
  before_action :set_data, only: [:update, :destroy]

  def create
    @device = Device.find(params[:device_id])
    @data = @device.device_data.new(data_params)

    if @data.save
      redirect_to device_path(@device), notice: "Donnée ajoutée avec succès."
    else
      redirect_to device_path(@device), alert: "Erreur lors de l'ajout."
    end
  end

  def update
    if @data.update(data_params)
      redirect_to device_path(@device), notice: "Donnée modifiée."
    else
      redirect_to device_path(@device), alert: "Erreur lors de la modification."
    end
  end

  def destroy
    @data.destroy
    redirect_to device_path(@device), notice: "Donnée supprimée."
  end

  private

  def set_data
    @device = Device.find(params[:device_id])
    @data = @device.device_data.find(params[:id])
  end

  def data_params
    params.require(:device_datum).permit(:key, :value)
  end
end
