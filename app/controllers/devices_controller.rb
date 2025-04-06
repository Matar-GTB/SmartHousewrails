class DevicesController < ApplicationController
  before_action :authenticate_user!                    # Exige que l'utilisateur soit connecté pour toutes les actions
  before_action :set_device, only: %i[ show edit update destroy ]
  before_action :require_advanced, only: %i[ new create edit update ]
  before_action :require_admin,    only: %i[ destroy ]

  # GET /devices
  def index
    @devices = Device.all.order(created_at: :desc)
  end

  # GET /devices/1
  def show
  end

  # GET /devices/new
  def new
    @device = Device.new
  end

  # GET /devices/1/edit
  def edit
  end

  # POST /devices
  def create
    @device = Device.new(device_params)
    @device.user = current_user  # Associe le device à l'utilisateur courant

    if @device.save
      # Attribuer des points à l’utilisateur pour la création d’un objet
      current_user.increment!(:points, 10)
      redirect_to @device, notice: "Objet connecté créé avec succès."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /devices/1
  def update
    if @device.update(device_params)
      # Attribuer des points pour la mise à jour (modification) d’un objet
      current_user.increment!(:points, 5)
      redirect_to @device, notice: "Objet connecté mis à jour."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /devices/1
  def destroy
    @device.destroy
    redirect_to devices_path, notice: "Objet supprimé."
  end

  private

    # Recherche l'objet connecté correspondant à l'ID (pour show/edit/update/destroy)
    def set_device
      @device = Device.find(params[:id])
    end

    # Strong parameters: limite les attributs modifiables via formulaire
    def device_params
      params.require(:device).permit(:name, :description)
    end

    # Autorise uniquement les utilisateurs avancés ou admin
    def require_advanced
      unless current_user && (current_user.admin? || current_user.advanced?)
        redirect_to devices_path, alert: "Accès réservé aux utilisateurs avancés."
      end
    end

    # Autorise uniquement l'admin
    def require_admin
      unless current_user && current_user.admin?
        redirect_to root_path, alert: "Accès non autorisé."
      end
    end
end
