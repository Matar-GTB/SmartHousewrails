class Device < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true

   # Validations de base
   validates :name, presence: true  # le nom est obligatoire
   validates :description, presence: true
end
