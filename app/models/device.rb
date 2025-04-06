class Device < ApplicationRecord
  belongs_to :user

   # Validations de base
   validates :name, presence: true  # le nom est obligatoire
   validates :description, presence: true
end
