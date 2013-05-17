class RideObserver < ActiveRecord::Observer
  def after_update(ride)
    @report = ride.report
    rides = @report.rides

    passengers = rides.collect(&:passengers).inject {|sum, n| sum + n}
    sales = rides.collect(&:fare).inject {|sum, n| sum + n}
    riding_count = rides.size || 0
    meter_fare_count = (sales - @report.car.base_fare * riding_count) / @report.car.meter_fare

    @report.update_attributes({ :riding_count => riding_count,
                                :meter_fare_count => meter_fare_count,
                                :passengers => passengers,
                                :sales => sales
                              })
  end
end
