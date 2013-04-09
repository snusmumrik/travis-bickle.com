class ReportObserver < ActiveRecord::Observer
  def after_update(report)
    @meter = Meter.where(["report_id = ?", report.id]).first
    if @meter
      @meter.update_attributes({ :meter => report.meter,
                                 :mileage => report.mileage,
                                 :riding_mileage => report.mileage,
                                 :riding_count => report.riding_count,
                                 :meter_fare_count => report.meter_fare_count
                               })
    else
      Meter.create( :report_id => report.id,
                    :meter => report.meter,
                    :mileage => report.mileage,
                    :riding_mileage => report.mileage,
                    :riding_count => report.riding_count,
                    :meter_fare_count => report.meter_fare_count
                    )
    end
  end
end
