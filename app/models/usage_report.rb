class UsageReport < ApplicationRecord
  belongs_to :device
  require 'csv'

def self.to_csv
  CSV.generate(headers: true) do |csv|
    csv << ["Objet", "Période", "Date", "Consommation", "Autres"]
    all.each do |r|
      data = r.data.is_a?(Hash) ? r.data : JSON.parse(r.data)
      csv << [r.device.name, r.period, r.generated_at, data["consommation"], data.except("consommation").to_s]
    end
  end
end

end
