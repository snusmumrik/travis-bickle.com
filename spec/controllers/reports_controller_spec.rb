require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe ReportsController do

  # This should return the minimal set of attributes required to create a valid
  # Report. As you add validations to Report, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    if controller.current_user
      car = controller.current_user.cars.last
      driver = controller.current_user.drivers.last
      FactoryGirl.attributes_for(:report, :car_id => car.id, :driver_id => driver.id)
    else
      FactoryGirl.attributes_for(:report, :car_id => 100, :driver_id => 100)
    end
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ReportsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  context "authenticated user" do
    signin_user

    describe "GET index" do
      it "assigns all reports as @reports without params" do
        reports = Report.includes(:car, :driver, :rests).where(["cars.user_id = ? AND reports.started_at BETWEEN ? AND ?",
                                                                controller.current_user.id,
                                                                Date.new(Date.today.year.to_i, Date.today.month.to_i, 1),
                                                                Date.new(Date.today.year.to_i, Date.today.month.to_i, -1)]).order("cars.name").all
        get :index, {}
        assigns(:reports).should eq(reports)
      end

      it "assigns all reports as @reports with params" do
        year = Date.today.year
        month = Date.today.month
        day = Date.today.day
        reports = Report.includes(:car, :driver, :rests).where(["cars.user_id = ? AND reports.started_at BETWEEN ? AND ?",
                                                                controller.current_user.id,
                                                                Date.new(year, month, 1),
                                                                Date.new(year, month, -1)]).order("cars.name").all
        get :index, {:year => year, :month => month, :day => day}
        assigns(:reports).should eq(reports)
      end

      it "do not assigns other's reports" do
        car = FactoryGirl.create(:car, :user_id => controller.current_user.id + 1)
        driver = FactoryGirl.create(:driver, :user_id => controller.current_user.id + 1)
        report = FactoryGirl.create(:report, :car_id => car.id, :driver_id => driver.id)
        assigns(:reports).should_not eq(report)
      end
    end

    describe "GET show" do
      it "assigns the requested report as @report" do
        report = Report.create! valid_attributes
        get :show, {:id => report.to_param}
        assigns(:report).should eq(report)
      end

      it "redirects to index in case of unauthorized report as @report" do
        car = FactoryGirl.create(:car, :user_id => controller.current_user.id + 1)
        driver = FactoryGirl.create(:driver, :user_id => controller.current_user.id + 1)
        report = FactoryGirl.create(:report, :car_id => car.id, :driver_id => driver.id)
        get :show, {:id => report.to_param}
        response.should redirect_to reports_path
      end
    end

    describe "GET new" do
      it "assigns a new report as @report" do
        get :new, {}
        assigns(:report).should be_a_new(Report)
      end
    end

    describe "GET edit" do
      it "assigns the requested report as @report" do
        report = Report.create! valid_attributes
        get :edit, {:id => report.to_param}
        assigns(:report).should eq(report)
      end

      it "do not assigns the requested other's report as @report" do
        car = FactoryGirl.create(:car, :user_id => controller.current_user.id + 1)
        driver = FactoryGirl.create(:driver , :user_id => controller.current_user.id + 1)
        report = FactoryGirl.create(:report, :car_id => car.id, :driver_id => driver.id)
        get :edit, {:id => report.to_param}
        response.should redirect_to reports_path
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Report" do
          expect {
            post :create, {:report => valid_attributes}
          }.to change(Report, :count).by(1)
        end

        it "assigns a newly created report as @report" do
          post :create, {:report => valid_attributes}
          assigns(:report).should be_a(Report)
          assigns(:report).should be_persisted
        end

        it "redirects to the created report" do
          post :create, {:report => valid_attributes}
          response.should redirect_to(Report.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved report as @report" do
          # Trigger the behavior that occurs when invalid params are submitted
          Report.any_instance.stub(:save).and_return(false)
          post :create, {:report => {}}
          assigns(:report).should be_a_new(Report)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Report.any_instance.stub(:save).and_return(false)
          post :create, {:report => {}}
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "for unauthorized report" do
        it "redirects to index for unauthorized report as @report" do
          car = FactoryGirl.create(:car, :user_id => controller.current_user.id + 1)
          driver = FactoryGirl.create(:driver , :user_id => controller.current_user.id + 1)
          report = FactoryGirl.create(:report, :car_id => car.id, :driver_id => driver.id)
          put :update, {:id => report.to_param, :report => valid_attributes}
          response.should redirect_to(reports_path)
        end
      end

      describe "with valid params" do
        it "updates the requested report" do
          report = Report.create! valid_attributes
          # Assuming there are no other reports in the database, this
          # specifies that the Report created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Report.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, {:id => report.to_param, :report => {'these' => 'params'}}
        end

        it "assigns the requested report as @report" do
          report = FactoryGirl.create(:report_with_ride_and_meter)
          put :update, {:id => report.to_param, :report => {:mileage => report.mileage + 1}}
          assigns(:report).should eq(report)
        end

        it "redirects to the report" do
          report = FactoryGirl.create(:report_with_ride_and_meter)
          put :update, {:id => report.to_param, :report => {:mileage => report.mileage + 1}}
          response.should redirect_to(report)
        end
      end

      describe "with invalid params" do
        it "assigns the report as @report" do
          report = Report.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Report.any_instance.stub(:save).and_return(false)
          put :update, {:id => report.to_param, :report => {}}
          assigns(:report).should eq(report)
        end

        it "re-renders the 'edit' template" do
          report = Report.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Report.any_instance.stub(:save).and_return(false)
          put :update, {:id => report.to_param, :report => {}}
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested report" do
        report = Report.create! valid_attributes
        expect {
          delete :destroy, {:id => report.to_param}
        }.to change(Report, :count).by(-1)
        Report.last.deleted_at.should_not nil
      end

      it "does not destroy other's report" do
        car = FactoryGirl.create(:car, :user_id => controller.current_user.id + 1)
        driver = FactoryGirl.create(:driver , :user_id => controller.current_user.id + 1)
        report = FactoryGirl.create(:report, :car_id => car.id, :driver_id => driver.id)
        expect {
          delete :destroy, {:id => report.to_param}
        }.to change(Report, :count).by(0)
        response.should redirect_to reports_path
      end

      it "redirects to the reports list" do
        report = Report.create! valid_attributes
        delete :destroy, {:id => report.to_param}
        response.should redirect_to(reports_url + "/#{Date.today.year}/#{Date.today.month}/#{Date.today.day}")
      end
    end
  end
  
  context "unauthenticated user" do
    describe "GET index" do
      it "redirects to signin" do
        get :index, {}
        response.should redirect_to "/users/sign_in"
      end
    end

    describe "GET show" do
      it "redirect to signin" do
        report = Report.create! valid_attributes
        get :show, {:id => report.to_param}
        response.should redirect_to "/users/sign_in"
      end
    end

    describe "GET new" do
      it "redirect to signin" do
        get :new, {}
        response.should redirect_to "/users/sign_in"
      end
    end

    describe "GET edit" do
      it "redirect to signin" do
        report = Report.create! valid_attributes
        get :edit, {:id => report.to_param}
        response.should redirect_to "/users/sign_in"
      end
    end

    describe "POST create" do
      it "redirect to signin" do
        expect {
          post :create, {:report => valid_attributes}
        }.to change(Report, :count).by(0)
        response.should redirect_to "/users/sign_in"
      end
    end

    describe "PUT update" do
      it "redirect to signin" do
        # report = FactoryGirl.build(:report)
        # put :update, {:id => report.to_param, :report => {'these' => 'params'}}
        put :update, {:id => 1, :report => {'these' => 'params'}}
        response.should redirect_to "/users/sign_in"
      end
    end

    describe "DELETE destroy" do
      it "redirects to signin" do
        # report = FactoryGirl.build(:report)
        # delete :destroy, {:id => report.to_param}
        delete :destroy, {:id => 1}
        response.should redirect_to "/users/sign_in"
      end
    end
  end
end
