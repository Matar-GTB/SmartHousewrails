module Admin
  class CategoriesController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin   # Méthode à définir pour restreindre l'accès aux admins
    before_action :set_category, only: [:show, :edit, :update, :destroy]

    def index
      @categories = Category.order(:name)
    end

    def show
    end

    def new
      @category = Category.new
    end

    def create
      @category = Category.new(category_params)
      if @category.save
        redirect_to admin_categories_path, notice: "Catégorie créée avec succès."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @category.update(category_params)
        redirect_to admin_categories_path, notice: "Catégorie mise à jour."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @category.destroy
      redirect_to admin_categories_path, notice: "Catégorie supprimée."
    end

    private
      def set_category
        @category = Category.find(params[:id])
      end

      def category_params
        params.require(:category).permit(:name)
      end

      def require_admin
        redirect_to root_path, alert: "Accès non autorisé." unless current_user.admin?
      end
  end
end
