class ReportObserver < ActiveRecord::Observer
  def after_update(report)
    if report.deleted_at
      report.meter.delete
      @next_report = Report.where("car_id = ? AND started_at > ? AND deleted_at IS NULL", report.car_id, report.started_at).first
      if @next_report
        @next_report.update_attributes({ :mileage => @next_report.mileage + report.mileage,
                                         :riding_mileage => @next_report.riding_mileage + report.riding_mileage,
                                         :riding_count => @next_report.riding_count + report.riding_count,
                                         :meter_fare_count => @next_report.meter_fare_count + report.meter_fare_count
                                       })
      end
    end
  end
end
