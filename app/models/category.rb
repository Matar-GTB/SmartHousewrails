class Category < ApplicationRecord
    has_many :devices, dependent: :nullify   # Les objets peuvent rester même si leur catégorie est supprimée
    has_many :services, dependent: :nullify   # Pareil pour les services
    validates :name, presence: true, uniqueness: true
  end
  