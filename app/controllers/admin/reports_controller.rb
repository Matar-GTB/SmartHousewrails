class Admin::ReportsController < ApplicationController
    before_action :authenticate_user!
    before_action :require_admin
  
    def index
      @reports = UsageReport.order(generated_at: :desc)
      @stats = {
        total_devices: Device.count,
        total_users: User.count,
        total_data_points: DeviceDatum.count,
        most_active_device: Device.joins(:device_data).group(:id).order('count(device_data.id) DESC').first
        respond_to do |format|
            format.html
            format.csv { send_data @reports.to_csv, filename: "rapports.csv" }
          end
      }
    end
  end
  