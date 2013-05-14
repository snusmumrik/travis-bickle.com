@driver_count = 20
@car_count = 20

for i in 1..@driver_count
  Driver.new(:user_id => 1, :name => "driver#{i}", :email => "driver#{i}@example.com", :password => "password").save
end

for i in 1..@car_count
  Car.new(:user_id => 1, :name => "car#{i}", :base_fare => 430, :meter_fare => 60).save
end

def create_records(day, month)
  for i in 1..@driver_count
    report = Report.new(:driver_id => i, :car_id => rand(@car_count - 1) + 1, :date => Date.new(Date.today.year, month, day))
    report.save

    for j in 1..rand(19)+1
      Ride.new(:report_id => report.id, :ride_address => "ride#{j}", :leave_address => "leave#{j}", :passengers => rand(4) + 1, :fare => report.car.base_fare + report.car.meter_fare*(rand(9) + 1)).save
    end

    for k in 1..rand(4)+1
      Rest.new(:report_id => report.id, :location => "location#{k}", :address => "adddress#{k}", :started_at => Time.now - 10*i*j*k, :ended_at => Time.now).save
    end

    report.rides.each do |ride|
      report.sales += ride.fare
      report.passengers += ride.passengers
      report.fuel_cost = ride.fare*0.3.ceil
      report.save
    end
  end
end

last_month = Date.new(Date.today.year, Date.today.month, 1) - 1
for day in 1..last_month.day
  create_records(day, last_month.month)
end

for day in 1..Date.today.day
  create_records(day, Date.today.month)
end









