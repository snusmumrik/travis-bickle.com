class MinimumWagesController < InheritedResources::Base
  before_filter :authenticate_user!
  before_filter :authenticate_owner, :only => [:show, :edit, :update, :destroy]

  # POST /minimum_wages
  # POST /minimum_wages.json
  def create
    @minimum_wage = MinimumWage.new(params[:minimum_wage])
    @minimum_wage.user = current_user

    respond_to do |format|
      if @minimum_wage.save
        format.html { redirect_to minimum_wages_path, notice: t("activerecord.models.minimum_wage") + t("message.created") }
        format.json { render json: @minimum_wage, status: :created, location: minimum_wages_path }
      else
        format.html { render action: "new" }
        format.json { render json: @minimum_wage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /minimum_wages/1
  # PUT /minimum_wages/1.json
  def update
    @minimum_wage = MinimumWage.find(params[:id])

    respond_to do |format|
      if @minimum_wage.update_attributes(params[:minimum_wage])
      format.html { redirect_to minimum_wages_path, notice: t("activerecord.models.minimum_wage") + t("message.updated") }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @minimum_wage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /minimum_wages/1
  # DELETE /minimum_wages/1.json
  def destroy
    @minimum_wage.update_attribute("deleted_at", DateTime.now)

    respond_to do |format|
      format.html { redirect_to minimum_wages_path, notice: t("activerecord.models.minimum_wage") + t("message.destroy") }
      format.json { head :ok }
    end
  end

  private
  def authenticate_owner
    @minimum_wage = MinimumWage.find(params[:id])
    redirect_to minimum_wages_path if @minimum_wage.user_id != current_user.id
  end
end
