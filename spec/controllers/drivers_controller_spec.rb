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

describe DriversController do

  # This should return the minimal set of attributes required to create a valid
  # Driver. As you add validations to Driver, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    if controller.current_user
      FactoryGirl.attributes_for(:driver, :user_id => controller.current_user.id)
    else
      FactoryGirl.attributes_for(:driver, :user_id => 100)
    end
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # DriversController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  context "authenticated user" do
    signin_user

    describe "GET index" do
      it "assigns all drivers as @drivers" do
        drivers = Driver.includes(:user).where(["user_id = ?", controller.current_user.id]).all
        get :index, {}
        assigns(:drivers).should eq(drivers)
      end

      it "do not assigns other's drivers" do
        driver = FactoryGirl.create(:driver, :user_id => controller.current_user.id + 1)
        assigns(:drivers).should_not eq([driver])
      end
    end

    describe "GET show" do
      it "assigns the requested driver as @driver" do
        driver = Driver.create! valid_attributes
        get :show, {:id => driver.to_param}
        assigns(:driver).should eq(driver)
      end

      it "redirects to index in case of unauthorized driver as @driver" do
        driver = FactoryGirl.create(:driver, :user_id => controller.current_user.id + 1)
        get :show, {:id => driver.to_param}
        response.should redirect_to drivers_path
      end
    end

    describe "GET new" do
      it "assigns a new driver as @driver" do
        get :new, {}
        assigns(:driver).should be_a_new(Driver)
      end
    end

    describe "GET edit" do
      it "assigns the requested driver as @driver" do
        driver = Driver.create! valid_attributes
        get :edit, {:id => driver.to_param}
        assigns(:driver).should eq(driver)
      end

      it "do not assigns the requested other's driver as @driver" do
        driver = FactoryGirl.create(:driver, :user_id => controller.current_user.id + 1)
        get :edit, {:id => driver.to_param}
        response.should redirect_to drivers_path
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Driver" do
          expect {
            post :create, {:driver => valid_attributes}
          }.to change(Driver, :count).by(1)
        end

        it "assigns a newly created driver as @driver" do
          post :create, {:driver => valid_attributes}
          assigns(:driver).should be_a(Driver)
          assigns(:driver).should be_persisted
        end

        it "redirects to the driver index" do
          post :create, {:driver => valid_attributes}
          response.should redirect_to(drivers_path)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved driver as @driver" do
          # Trigger the behavior that occurs when invalid params are submitted
          Driver.any_instance.stub(:save).and_return(false)
          post :create, {:driver => {}}
          assigns(:driver).should be_a_new(Driver)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Driver.any_instance.stub(:save).and_return(false)
          post :create, {:driver => {}}
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "for unauthorized driver" do
        it "redirects to index for unauthorized driver as @driver" do
          driver = FactoryGirl.create(:driver, :user_id => controller.current_user.id + 1)
          put :update, {:id => driver.to_param, :driver => valid_attributes}
          response.should redirect_to(drivers_path)
        end
      end

      describe "with valid params" do
        it "updates the requested driver" do
          driver = Driver.create! valid_attributes
          # Assuming there are no other drivers in the database, this
          # specifies that the Driver created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Driver.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, {:id => driver.to_param, :driver => {'these' => 'params'}}
        end

        it "assigns the requested driver as @driver" do
          driver = Driver.create! valid_attributes
          put :update, {:id => driver.to_param, :driver => valid_attributes}
          assigns(:driver).should eq(driver)
        end

        it "redirects to the driver" do
          driver = Driver.create! valid_attributes
          put :update, {:id => driver.to_param, :driver => valid_attributes}
          response.should redirect_to(drivers_path)
        end
      end

      describe "with invalid params" do
        it "assigns the driver as @driver" do
          driver = Driver.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Driver.any_instance.stub(:save).and_return(false)
          put :update, {:id => driver.to_param, :driver => {}}
          assigns(:driver).should eq(driver)
        end

        it "re-renders the 'edit' template" do
          driver = Driver.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Driver.any_instance.stub(:save).and_return(false)
          put :update, {:id => driver.to_param, :driver => {}}
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested driver" do
        driver = Driver.create! valid_attributes
        expect {
          delete :destroy, {:id => driver.to_param}
        }.to change(Driver, :count).by(0)
        Driver.last.deleted_at.should_not nil
      end

      it "does not destroy other's driver" do
        driver = FactoryGirl.create(:driver, :user_id => controller.current_user.id + 1)
        expect {
          delete :destroy, {:id => driver.to_param}
        }.to change(Driver, :count).by(0)
        response.should redirect_to drivers_path
      end

      it "redirects to the drivers list" do
        driver = Driver.create! valid_attributes
        delete :destroy, {:id => driver.to_param}
        response.should redirect_to(drivers_url)
      end
    end
  end

  context "unauthenticated use" do
    describe "GET index" do
      it "redirects to signin" do
        get :index, {}
        response.should redirect_to "/users/sign_in"
      end
    end

    describe "GET show" do
      it "redirect to signin" do
        driver = Driver.create! valid_attributes
        get :show, {:id => driver.to_param}
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
        driver = Driver.create! valid_attributes
        get :edit, {:id => driver.to_param}
        response.should redirect_to "/users/sign_in"
      end
    end

    describe "POST create" do
      it "redirect to signin" do
        expect {
          post :create, {:driver => valid_attributes}
        }.to change(Driver, :count).by(0)
        response.should redirect_to "/users/sign_in"
      end
    end

    describe "PUT update" do
      it "redirect to signin" do
        # driver = FactoryGirl.build(:driver)
        # put :update, {:id => driver.to_param, :driver => {'these' => 'params'}}
        put :update, {:id => 1, :driver => {'these' => 'params'}}
        response.should redirect_to "/users/sign_in"
      end
    end

    describe "DELETE destroy" do
      it "redirects to signin" do
        # driver = FactoryGirl.build(:driver)
        # delete :destroy, {:id => driver.to_param}
        delete :destroy, {:id => 1}
        response.should redirect_to "/users/sign_in"
      end
    end
  end
end
