class Device < ApplicationRecord
  belongs_to :user
  belongs_to :category, optional: true
  has_many :device_data, class_name: "DeviceDatum", dependent: :destroy

  before_create :assign_unique_id


   # Validations de base
   validates :name, presence: true  # le nom est obligatoire
   validates :description, presence: true

   def generate_daily_report
    today_data = device_data.where("created_at >= ?", Date.today)
    consommation = today_data.where(key: 'consommation').sum { |d| d.value.to_f }
  
    UsageReport.create!(
      device: self,
      period: "jour",
      generated_at: Time.now,
      data: {
        consommation: consommation,
        total_donnees: today_data.count
      }
    )
  end
  
def consumption_value
  device_data.find_by(key: "consommation")&.value.to_f
end

def assign_unique_id
  self.unique_id = "DEV#{SecureRandom.hex(4).upcase}" if self.unique_id.blank?
end

  


  
end
