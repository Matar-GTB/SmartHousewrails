class User < ApplicationRecord
  # Modules Devise activés
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable

  has_many :devices

  # Définition des niveaux avec les seuils de points
  LEVELS = {
    "simple" => 0,
    "avancé" => 200,
    "expert" => 600,
    "admin"  => 2200  # Dès 2200 points, l'utilisateur devient admin automatiquement.
  }

  # Méthodes d'interrogation pour les niveaux
  def advanced?
    level == "avancé"
  end

  def expert?
    level == "expert"
  end

  # Automatisation de l'évolution du niveau et la promotion en admin
  def update_level!
    # Si l'utilisateur atteint ou dépasse 2200 points, il est promu admin
    if points >= LEVELS["admin"]
      update!(level: "admin", admin: true) unless admin?
      return
    end

    # Si l'utilisateur est déjà admin, aucune modification n'est nécessaire
    return if admin?

    # Détermine le nouveau niveau en fonction des points
    new_level = case points
                when 0...LEVELS["avancé"] then "simple"
                when LEVELS["avancé"]...LEVELS["expert"] then "avancé"
                when LEVELS["expert"]...LEVELS["admin"] then "expert"
                end

    update!(level: new_level) if new_level && level != new_level
  end

  # Retourne une chaîne représentant le niveau en texte
  def level_name
    return "Admin" if admin?

    case level
    when "expert" then "Expert"
    when "avancé" then "Avancé"
    when "simple" then "Simple"
    else "Niveau inconnu"
    end
  end

  # Override des méthodes Devise pour l'activation de l'utilisateur
  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    approved? ? super : :unapproved_account 
  end

  # Export CSV des utilisateurs
  require 'csv'
  def self.to_csv
    attributes = %w{id email username points admin created_at last_sign_in_at}
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.find_each do |user|
        csv << attributes.map { |attr| user.send(attr) }
      end
    end
  end
end
