class DevicesController < ApplicationController
  before_action :set_device, only: %i[show edit update destroy toggle request_deletion]
  before_action :require_advanced, only: %i[new create edit update]
  before_action :require_admin, only: %i[destroy]

  # GET /devices
  def index
    @devices = Device.all

    if params[:query].present?
      @devices = @devices.where("name LIKE ? OR description LIKE ?", 
                                "%#{params[:query]}%", "%#{params[:query]}%")
    end

    if params[:category].present?
      @devices = @devices.where(category_id: params[:category])
    end
  end

  # GET /devices/1
  def show
    if current_user&.advanced?
      current_user.increment!(:points, 2)
      current_user.update_level!
    end
  end

  # GET /devices/new
  def new
    @device = Device.new
  end

  # GET /devices/1/edit
  def edit; end

  # POST /devices
  def create
    @device = Device.new(device_params)
    @device.user = current_user

    if @device.save
      current_user.increment!(:points, 10) unless current_user.admin?
      current_user.update_level!
      redirect_to @device, notice: "Objet connecté créé avec succès."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /devices/1
  def update
    if @device.update(device_params)
      unless params[:device].keys == ["status"] || current_user.admin?
        current_user.increment!(:points, 5)
        current_user.update_level!
      end
      redirect_to devices_path, notice: "Objet connecté mis à jour."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /devices/1
  def destroy
    @device.destroy
    redirect_to devices_path, notice: "Objet supprimé."
  end

  # PATCH /devices/:id/toggle
  def toggle
    unless current_user.admin? || (current_user.advanced? && @device.user == current_user)
      redirect_to devices_path, alert: "Action non autorisée."
      return
    end

    @device.update(status: !@device.status)
    redirect_to devices_path, notice: "Statut de l'objet mis à jour."
  end

  # POST /devices/:id/request_deletion
  def request_deletion
    if current_user&.advanced? && !current_user.admin?
      @device.update(deletion_requested: true)
      redirect_to devices_path, notice: "Demande de suppression envoyée pour « #{@device.name} »."
    else
      redirect_to devices_path, alert: "Action non autorisée."
    end
  end

  def stats
    @total_devices = Device.count
    @devices_by_user = Device.group(:user_id).count
  end

  private

  def set_device
    @device = Device.find(params[:id])
  end

  def device_params
    params.require(:device).permit(:name, :description, :status, :location, :category_id, :deletion_requested)
  end

  def require_advanced
    unless current_user && (current_user.admin? || current_user.advanced?)
      redirect_to devices_path, alert: "Accès réservé aux utilisateurs avancés."
    end
  end

  def require_admin
    redirect_to root_path, alert: "Accès non autorisé." unless current_user&.admin?
  end
end
