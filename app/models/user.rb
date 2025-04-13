class User < ApplicationRecord
  # modules Devise activés
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable
         
  
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
