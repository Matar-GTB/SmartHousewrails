class DevicesController < ApplicationController
                      
  before_action :set_device, only: %i[ show edit update destroy ]
  before_action :require_advanced, only: %i[ new create edit update ]
  before_action :require_admin,    only: %i[ destroy ]

  # GET /devices
  # app/controllers/devices_controller.rb
def index
  # ... (pour visiteurs, pas de before_action :authenticate_user!)
  @devices = Device.all
  if params[:query].present?
    # Filtre par nom ou description contenant le mot-clé
    @devices = @devices.where("name LIKE ? OR description LIKE ?", 
                              "%#{params[:query]}%", "%#{params[:query]}%")
  end
  if params[:category].present?
    @devices = @devices.where(category: params[:category])
  end
end


  # GET /devices/1
  def show
    # ... @device est déjà chargé
    if current_user && !current_user.admin?
      current_user.increment!(:points, 1)  # +1 point par consultation
    end
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
    # app/controllers/devices_controller.rb


  def request_deletion
    @device = Device.find(params[:id])
    if current_user.admin? || current_user.advanced?
      @device.update(deletion_requested: true)
      redirect_to devices_path, notice: "Demande de suppression envoyée pour « #{@device.name} »."
    else
      redirect_to devices_path, alert: "Action non autorisée."
    end
  end
  # app/controllers/devices_controller.rb
def toggle_active
  @device = Device.find(params[:id])
  if current_user.admin? || current_user.advanced?
    new_state = !@device.active?
    @device.update(active: new_state)
    notice_msg = new_state ? "activé" : "désactivé"
    redirect_to @device, notice: "L’objet « #{@device.name} » a été #{notice_msg}."
  else
    redirect_to devices_path, alert: "Accès non autorisé."
  end
end

def toggle
  @device = Device.find(params[:id])
  # Autoriser uniquement admin ou propriétaire avancé à toggler
  if current_user.admin? || (current_user.advanced? && @device.user == current_user)
    @device.update(status: !@device.status)
    redirect_to devices_path, notice: (@device.status ? "Objet activé" : "Objet désactivé")
  else
    redirect_to devices_path, alert: "Action non autorisée."
  end
end

def stats
  @total_devices = Device.count
  @devices_by_user = Device.group(:user_id).count
  # etc. toute stat calculable via ActiveRecord
end







end
