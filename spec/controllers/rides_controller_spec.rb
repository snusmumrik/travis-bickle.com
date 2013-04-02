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

describe RidesController do

  # This should return the minimal set of attributes required to create a valid
  # Ride. As you add validations to Ride, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    if controller.current_user
      # user = controller.current_user.cars.last
      # driver = controller.current_user.drivers.last
      # report = FactoryGirl.create(:report, :car_id => car.id, :driver_id => driver.id)
      drivers = Driver.where(["user_id = ?", controller.current_user.id]).all
      driver = drivers[rand(drivers.size)]
      FactoryGirl.attributes_for(:ride, :report_id => driver.reports.last.id)
    else
      car = FactoryGirl.create(:car, :user_id => 100)
      driver = FactoryGirl.create(:driver, :user_id => 100)
      report = FactoryGirl.create(:report, :car_id => car.id, :driver_id => driver.id)
      FactoryGirl.attributes_for(:ride, :report_id => report.id)
    end
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # RidesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  context "authenticated user" do
    signin_user

    describe "GET index" do
      it "assigns all rides as @rides" do
        rides = Ride.includes(:report => {:driver => :user}).where(["users.id = ?", controller.current_user.id]).all
        get :index, {}
        assigns(:rides).should eq(rides)
      end
    end

    describe "GET show" do
      it "assigns the requested ride as @ride" do
        ride = Ride.create! valid_attributes
        get :show, {:id => ride.to_param}
        assigns(:ride).should eq(ride)
      end
    end

    describe "GET new" do
      it "assigns a new ride as @ride" do
        get :new, {:report_id => 1}
        assigns(:ride).should be_a_new(Ride)
      end
    end

    describe "GET edit" do
      it "assigns the requested ride as @ride" do
        ride = Ride.create! valid_attributes
        get :edit, {:id => ride.to_param}
        assigns(:ride).should eq(ride)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Ride" do
          expect {
            post :create, {:ride => valid_attributes}
          }.to change(Ride, :count).by(1)
        end

        it "assigns a newly created ride as @ride" do
          post :create, {:ride => valid_attributes}
          assigns(:ride).should be_a(Ride)
          assigns(:ride).should be_persisted
        end

        it "redirects to the report" do
          post :create, {:ride => valid_attributes}
          response.should redirect_to(Ride.last.report)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved ride as @ride" do
          # Trigger the behavior that occurs when invalid params are submitted
          Ride.any_instance.stub(:save).and_return(false)
          post :create, {:ride => {}}
          assigns(:ride).should be_a_new(Ride)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Ride.any_instance.stub(:save).and_return(false)
          post :create, {:ride => {}}
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested ride" do
          ride = Ride.create! valid_attributes
          # Assuming there are no other rides in the database, this
          # specifies that the Ride created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Ride.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, {:id => ride.to_param, :ride => {'these' => 'params'}}
        end

        it "assigns the requested ride as @ride" do
          ride = Ride.create! valid_attributes
          put :update, {:id => ride.to_param, :ride => valid_attributes}
          assigns(:ride).should eq(ride)
        end

        it "redirects to the ride" do
          ride = Ride.create! valid_attributes
          put :update, {:id => ride.to_param, :ride => valid_attributes}
          response.should redirect_to(report_path(ride.report))
        end
      end

      describe "with invalid params" do
        it "assigns the ride as @ride" do
          ride = Ride.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Ride.any_instance.stub(:save).and_return(false)
          put :update, {:id => ride.to_param, :ride => {}}
          assigns(:ride).should eq(ride)
        end

        it "re-renders the 'edit' template" do
          ride = Ride.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Ride.any_instance.stub(:save).and_return(false)
          put :update, {:id => ride.to_param, :ride => {}}
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested ride" do
        ride = Ride.create! valid_attributes
        expect {
          delete :destroy, {:id => ride.to_param}
        }.to change(Ride, :count).by(-1)
      end

      it "redirects to the rides list" do
        ride = Ride.create! valid_attributes
        delete :destroy, {:id => ride.to_param}
        response.should redirect_to(report_path(ride.report))
      end
    end
  end

  context "unauthenticated usef" do
    describe "GET index" do
      it "redirects to signin" do
        get :index, {}
        response.should redirect_to "/users/sign_in"
      end
    end

    describe "GET show" do
      it "redirect to signin" do
        ride = Ride.create! valid_attributes
        get :show, {:id => ride.to_param}
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
        ride = Ride.create! valid_attributes
        get :edit, {:id => ride.to_param}
        response.should redirect_to "/users/sign_in"
      end
    end

    describe "POST create" do
      it "redirect to signin" do
        expect {
          post :create, {:ride => valid_attributes}
        }.to change(Ride, :count).by(0)
        response.should redirect_to "/users/sign_in"
      end
    end

    describe "PUT update" do
      it "redirect to signin" do
        # ride = FactoryGirl.build(:ride)
        # put :update, {:id => ride.to_param, :ride => {'these' => 'params'}}
        put :update, {:id => 1, :ride => {'these' => 'params'}}
        response.should redirect_to "/users/sign_in"
      end
    end

    describe "DELETE destroy" do
      it "redirects to signin" do
        # ride = FactoryGirl.build(:ride)
        # delete :destroy, {:id => ride.to_param}
        delete :destroy, {:id => 1}
        response.should redirect_to "/users/sign_in"
      end
    end
  end
end
