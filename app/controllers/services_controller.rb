class ServicesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_service, only: [:show, :edit, :update, :destroy]
    before_action :require_advanced, only: [:new, :create, :edit, :update]
    before_action :require_admin, only: [:destroy]
  
    def index
      @services = Service.all
      # Filtre par mot-clé
  if params[:query].present?
    @services = @services.where("name LIKE ? OR description LIKE ?", "%#{params[:query]}%", "%#{params[:query]}%")
  end

  # Filtre par catégorie
  if params[:category].present?
    @services = @services.where(category_id: params[:category])
  end
    end
  
    def show; end
    def new; @service = Service.new; end
    def create
      @service = Service.new(service_params)
      @service.user = current_user
      if @service.save
        current_user.increment!(:points, 10)   # éventuellement, récompense ajout service
        redirect_to @service, notice: "Service créé."
      else
        render :new, status: :unprocessable_entity
      end
    end
    # ... edit, update, destroy semblables à DevicesController ...
    private 
      def service_params
        params.require(:service).permit(:name, :description)
      end
      def set_service; @service = Service.find(params[:id]); end
      def require_advanced
        unless current_user && (current_user.admin? || current_user.advanced?)
          redirect_to services_path, alert: "Accès réservé aux utilisateurs avancés."
        end
      end
      def require_admin
        redirect_to root_path, alert: "Accès non autorisé." unless current_user&.admin?
      end
  end
  