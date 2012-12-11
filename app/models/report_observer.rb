class ReportObserver < ActiveRecord::Observer
  def after_update(report)
    @meter = Meter.where(["car_id = ? AND date = ?", report.car_id, report.date]).first
    if @meter
      @meter.update_attributes({ :meter => report.meter,
                                 :mileage => report.mileage,
                                 :riding_mileage => report.mileage,
                                 :riding_count => report.riding_count,
                                 :meter_fare_count => report.meter_fare_count
                               })
    else
      Meter.create( :car_id => report.car_id,
                    :date => report.date,
                    :meter => report.meter,
                    :mileage => report.mileage,
                    :riding_mileage => report.mileage,
                    :riding_count => report.riding_count,
                    :meter_fare_count => report.meter_fare_count
                    )
    end
  end
end
