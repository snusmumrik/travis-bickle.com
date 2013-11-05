class RideObserver < ActiveRecord::Observer
  def after_create(ride)
    @report = ride.report
    @report.riding_count = @report.rides.size
    @report.save
  end

  def after_update(ride)
    calculate(ride)
  end

  def calculate(ride)
    @report = ride.report

    passengers = @report.rides.collect(&:passengers).sum
    sales = @report.rides.collect(&:fare).sum

    @report.meter_fare_count = (sales - @report.car.base_fare * @report.riding_count) / @report.car.meter_fare unless sales.blank?
    @report.passengers = passengers
    @report.sales = sales

    credit = @report.cash + @report.ticket + @report.account_receivable + @report.fuel_cost + @report.advance
    debit = @report.sales + @report.extra_sales
    if debit - credit >= 0
      @report.deficiency_account = debit - credit
      @report.surplus_funds = 0
    elsif credit - debit > 0
      @report.surplus_funds = credit - debit
      @report.deficiency_account = 0
    end

    @report.save
  end
end
