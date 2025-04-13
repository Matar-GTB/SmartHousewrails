class AddCategoryToDevicesAndServices < ActiveRecord::Migration[8.0]
  def change
    # Pour la table devices
    unless column_exists?(:devices, :category_id)
      add_reference :devices, :category, foreign_key: true
    end

    # Pour la table smart_services (si vous utilisez bien ce nom pour le modèle)
    unless column_exists?(:smart_services, :category_id)
      add_reference :smart_services, :category, foreign_key: true
    end
  end
end
