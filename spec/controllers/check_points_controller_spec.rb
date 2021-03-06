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

describe CheckPointsController do

  # This should return the minimal set of attributes required to create a valid
  # CheckPoint. As you add validations to CheckPoint, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    if controller.current_user
      FactoryGirl.attributes_for(:check_point, :user_id => controller.current_user.id)
    else
      FactoryGirl.attributes_for(:check_point, :user_id => 100)
    end
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CheckPointsController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  context "authenticated use" do
    signin_user

    describe "GET index" do
      it "assigns all check_points as @check_points" do
        check_points = CheckPoint.includes(:user).where(["user_id = ?", controller.current_user.id]).all
        get :index, {}
        assigns(:check_points).should eq(check_points)
      end

      it "do not assigns other user's check_points" do
        check_point = FactoryGirl.create(:check_point, :user_id => controller.current_user.id + 1)
        assigns(:check_points).should_not eq([check_point])
      end
    end

    # describe "GET show" do
    #   it "assigns the requested check_point as @check_point" do
    #     check_point = CheckPoint.create! valid_attributes
    #     get :show, {:id => check_point.to_param}
    #     assigns(:check_point).should eq(check_point)
    #   end

    #   it "redirects to index in case of unauthorized check_point as @check_point" do
    #     check_point = FactoryGirl.create(:check_point, :user_id => controller.current_user.id + 1)
    #     get :show, {:id => check_point.to_param}
    #     response.should redirect_to check_points_path
    #   end
    # end

    describe "GET new" do
      it "assigns a new check_point as @check_point" do
        get :new, {}
        assigns(:check_point).should be_a_new(CheckPoint)
      end
    end

    describe "GET edit" do
      it "assigns the requested check_point as @check_point" do
        check_point = CheckPoint.create! valid_attributes
        get :edit, {:id => check_point.to_param}
        assigns(:check_point).should eq(check_point)
      end

      it "do not assigns the requested other's check_point as @check_point" do
        check_point = FactoryGirl.create(:check_point, :user_id => controller.current_user.id + 1)
        get :edit, {:id => check_point.to_param}
        response.should redirect_to check_points_path
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new CheckPoint" do
          expect {
            post :create, {:check_point => valid_attributes}
          }.to change(CheckPoint, :count).by(1)
        end

        it "assigns a newly created check_point as @check_point" do
          post :create, {:check_point => valid_attributes}
          assigns(:check_point).should be_a(CheckPoint)
          assigns(:check_point).should be_persisted
        end

        it "redirects to the check_point index" do
          post :create, {:check_point => valid_attributes}
          response.should redirect_to(check_points_path)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved check_point as @check_point" do
          # Trigger the behavior that occurs when invalid params are submitted
          CheckPoint.any_instance.stub(:save).and_return(false)
          post :create, {:check_point => {}}
          assigns(:check_point).should be_a_new(CheckPoint)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          CheckPoint.any_instance.stub(:save).and_return(false)
          post :create, {:check_point => {}}
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "for unauthorized check_point" do
        it "redirects to index for unauthorized check_point as @check_point" do
          check_point = FactoryGirl.create(:check_point, :user_id => controller.current_user.id + 1)
          put :update, {:id => check_point.to_param, :check_point => valid_attributes}
          response.should redirect_to(check_points_path)
        end
      end

      describe "with valid params" do
        it "updates the requested check_point" do
          check_point = CheckPoint.create! valid_attributes
          # Assuming there are no other check_points in the database, this
          # specifies that the CheckPoint created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          CheckPoint.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, {:id => check_point.to_param, :check_point => {'these' => 'params'}}
        end

        it "assigns the requested check_point as @check_point" do
          check_point = CheckPoint.create! valid_attributes
          put :update, {:id => check_point.to_param, :check_point => valid_attributes}
          assigns(:check_point).should eq(check_point)
        end

        it "redirects to the check_point" do
          check_point = CheckPoint.create! valid_attributes
          put :update, {:id => check_point.to_param, :check_point => valid_attributes}
          response.should redirect_to(check_points_path)
        end
      end

      describe "with invalid params" do
        it "assigns the check_point as @check_point" do
          check_point = CheckPoint.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          CheckPoint.any_instance.stub(:save).and_return(false)
          put :update, {:id => check_point.to_param, :check_point => {}}
          assigns(:check_point).should eq(check_point)
        end

        it "re-renders the 'edit' template" do
          check_point = CheckPoint.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          CheckPoint.any_instance.stub(:save).and_return(false)
          put :update, {:id => check_point.to_param, :check_point => {}}
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested check_point" do
        check_point = CheckPoint.create! valid_attributes
        expect {
          delete :destroy, {:id => check_point.to_param}
        }.to change(CheckPoint, :count).by(-1)
      end

      it "does not destroy other's check_point" do
        check_point = FactoryGirl.create(:check_point, :user_id => controller.current_user.id + 1)
        expect {
          delete :destroy, {:id => check_point.to_param}
        }.to change(CheckPoint, :count).by(0)
        response.should redirect_to check_points_path
      end

      it "redirects to the check_points list" do
        check_point = CheckPoint.create! valid_attributes
        delete :destroy, {:id => check_point.to_param}
        response.should redirect_to(check_points_url)
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
        check_point = CheckPoint.create! valid_attributes
        get :show, {:id => check_point.to_param}
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
        check_point = CheckPoint.create! valid_attributes
        get :edit, {:id => check_point.to_param}
        response.should redirect_to "/users/sign_in"
      end
    end

    describe "POST create" do
      it "redirect to signin" do
        expect {
          post :create, {:check_point => valid_attributes}
        }.to change(CheckPoint, :count).by(0)
        response.should redirect_to "/users/sign_in"
      end
    end

    describe "PUT update" do
      it "redirect to signin" do
        # check_point = FactoryGirl.build(:check_point)
        # put :update, {:id => check_point.to_param, :check_point => {'these' => 'params'}}
        put :update, {:id => 1, :check_point => {'these' => 'params'}}
        response.should redirect_to "/users/sign_in"
      end
    end

    describe "DELETE destroy" do
      it "redirects to signin" do
        # check_point = FactoryGirl.build(:check_point)
        # delete :destroy, {:id => check_point.to_param}
        delete :destroy, {:id => 1}
        response.should redirect_to "/users/sign_in"
      end
    end
  end
end
