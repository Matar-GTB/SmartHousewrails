class User < ApplicationRecord
  # modules Devise activés
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable
         
  
         LEVELS = {
          "simple" => 0,
          "avancé" => 200,
          "expert" => 600,
          "admin"  => 2200 # très haut, car il devient admin manuellement
        }
        
        def advanced?
          level == "avancé"
        end
        
        def expert?
          level == "expert"
        end
        
        # Automatiser l’évolution du niveau
        def update_level!
          return if admin? # On ne touche pas les admins
        
          new_level = case points
                      when 0...200   then "simple"
                      when 200...600  then "avancé"
                      when 600...2200 then "expert"
                      end
        
          update!(level: new_level) if new_level && level != new_level
        end
        def level_name
          return "Admin" if admin?
        
          case level
          when "expert" then "Expert"
          when "avancé" then "Avancé"
          when "simple" then "Simple"
          else "Niveau inconnu"
          end
        end
        
        
  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    approved? ? super : :unapproved_account 
  end


  require 'csv'
class User < ApplicationRecord
  # ...
  def self.to_csv
    attributes = %w{id email username points admin created_at last_sign_in_at}
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.find_each do |user|
        csv << attributes.map{|attr| user.send(attr)}
      end
    end
  end
end

end
