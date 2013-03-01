class RideObserver < ActiveRecord::Observer
  def after_create(ride)
    @report = ride.report
    passengers = 0
    sales = 0
    rides = @report.rides
    rides.each do |ride|
      passengers += ride.passengers
      sales += ride.fare
    end

    riding_count = rides.size || 0
    meter_fare_count = (sales-@report.car.base_fare*riding_count)/@report.car.meter_fare

    @report.update_attributes({ :riding_count => riding_count,
                                :meter_fare_count => meter_fare_count,
                                :passengers => passengers,
                                :sales => sales
                              })
  end
end
