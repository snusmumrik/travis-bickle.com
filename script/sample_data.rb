# -*- coding: utf-8 -*-
# use under rails console

@check_point_count = 10
@driver_count = 20
@car_count = 20

@user = User.new(:username => "ユーザー#{User.count + 1}", :email => "test@test.com", :password => "password", :password_confirmation => "password")
@user.save

for i in 1..@check_point_count
  CheckPoint.new(:user_id => @user.id, :name => "点検項目#{i}").save
end

for i in 1..@driver_count
  Driver.new(:user_id => @user.id, :name => "運転手#{format('%02d', i)}", :email => "driver#{i}@example.com", :password => "password").save
end

for i in 1..@car_count
  Car.new(:user_id => @user.id, :name => "#{format('%02d', i)}号車", :base_fare => 430, :meter_fare => 60).save
end

def create_records(year, month, day)
  for i in 1..@driver_count
    report = Report.new(:driver_id => i, :car_id => rand(@car_count - 1) + 1, :date => Date.new(year, month, day), :started_at => DateTime.new(year, month, day, i, rand(59), rand(59)))
    report.save

    for j in 1..rand(19)+1
      ride = Ride.new(:report_id => report.id, :ride_address => "乗車地#{j}", :leave_address => "降車地#{j}", :passengers => rand(4) + 1, :fare => report.car.base_fare + report.car.meter_fare*(rand(9) + 1), :ended_at => DateTime.now)
      ride.save
      report.update_attributes(:riding_count => report.riding_count + 1,
                               :meter_fare_count => (ride.fare - report.car.base_fare) / report.car.meter_fare,
                               :passengers => report.passengers + ride.passengers,
                               :sales => report.sales + ride.fare)
    end

    for k in 1..rand(4)+1
      Rest.new(:report_id => report.id, :location => "休憩地点#{k}", :address => "adddress#{k}", :started_at => Time.now - 30*i*j*k, :ended_at => Time.now).save
    end

    last_meter = Meter.includes(:report).where(["reports.car_id = ?", report.car_id]).last
    mileage  = rand(100)
    if last_meter
      Meter.create(:report_id => report.id,
                   :meter => last_meter.meter + mileage,
                   :mileage => last_meter.mileage + (mileage * 0.95).ceil,
                   :riding_mileage => last_meter.riding_mileage + (mileage * 0.3).ceil,
                   :riding_count => last_meter.riding_count + report.riding_count,
                   :meter_fare_count => last_meter.meter_fare_count + report.meter_fare_count)
    else
      Meter.create(:report_id => report.id,
                   :meter => mileage,
                   :mileage => (mileage * 0.95).ceil,
                   :riding_mileage => (mileage * 0.3).ceil,
                   :riding_count => report.riding_count,
                   :meter_fare_count => report.meter_fare_count)
    end

    report.mileage = (mileage * 0.95).ceil
    report.riding_mileage = (mileage * 0.3).ceil
    report.account_receivable += 1/(rand(1000)+1)*100
    report.ticket = 1/(rand(1000)+1)*500
    report.fuel_cost = (report.sales*rand(5)/10.0).ceil
    report.cash = report.sales - report.fuel_cost - report.ticket - report.account_receivable
    report.finished_at = report.started_at + rand(60) + 60*rand(60) + 60*60*rand(12)
    report.save
  end
end

last_month = Date.new(Date.today.year, Date.today.month, 1) - 1

for day in 1..last_month.day
  create_records(last_month.year, last_month.month, day)
end

for day in 1..Date.today.day
  create_records(Date.today.year, Date.today.month, day)
end
