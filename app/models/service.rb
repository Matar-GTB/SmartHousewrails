
class Service < ApplicationRecord
    belongs_to :user   # utilisateur qui l’a ajouté/configuré
    # attributs : name (string), description (text), etc.
    validates :name, presence: true
  end
  