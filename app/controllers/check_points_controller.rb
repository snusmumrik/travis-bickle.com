class CheckPointsController < InheritedResources::Base
  # POST /check_points
  # POST /check_points.json
  def create
    @check_point = CheckPoint.new(params[:check_point])
    @check_point.user = current_user

    respond_to do |format|
      if @check_point.save
        format.html { redirect_to @check_point, notice: 'Check Point was successfully created.' }
        format.json { render json: @check_point, status: :created, location: @check_point }
      else
        format.html { render action: "new" }
        format.json { render json: @check_point.errors, status: :unprocessable_entity }
      end
    end
  end
end
