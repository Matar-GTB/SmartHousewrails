class User < ApplicationRecord
  # modules Devise activés
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  # ta méthode personnalisée pour afficher le niveau
  def level_name
    return "Admin" if admin?
    case points
    when 0...50   then "Débutant"
    when 50...200 then "Intermédiaire"
    else "Avancé"
    end
  end

  def admin?
    self.admin
  end

  def advanced?
    self.points >= 200
  end
end
