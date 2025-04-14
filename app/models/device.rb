class Device < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true
  has_many :device_data, class_name: "DeviceDatum", dependent: :destroy


   # Validations de base
   validates :name, presence: true  # le nom est obligatoire
   validates :description, presence: true
end
