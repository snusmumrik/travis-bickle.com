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

describe MinimumWagesController do

  # This should return the minimal set of attributes required to create a valid
  # MinimumWage. As you add validations to MinimumWage, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { "user" => "" }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # MinimumWagesController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all minimum_wages as @minimum_wages" do
      minimum_wage = MinimumWage.create! valid_attributes
      get :index, {}, valid_session
      assigns(:minimum_wages).should eq([minimum_wage])
    end
  end

  describe "GET show" do
    it "assigns the requested minimum_wage as @minimum_wage" do
      minimum_wage = MinimumWage.create! valid_attributes
      get :show, {:id => minimum_wage.to_param}, valid_session
      assigns(:minimum_wage).should eq(minimum_wage)
    end
  end

  describe "GET new" do
    it "assigns a new minimum_wage as @minimum_wage" do
      get :new, {}, valid_session
      assigns(:minimum_wage).should be_a_new(MinimumWage)
    end
  end

  describe "GET edit" do
    it "assigns the requested minimum_wage as @minimum_wage" do
      minimum_wage = MinimumWage.create! valid_attributes
      get :edit, {:id => minimum_wage.to_param}, valid_session
      assigns(:minimum_wage).should eq(minimum_wage)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new MinimumWage" do
        expect {
          post :create, {:minimum_wage => valid_attributes}, valid_session
        }.to change(MinimumWage, :count).by(1)
      end

      it "assigns a newly created minimum_wage as @minimum_wage" do
        post :create, {:minimum_wage => valid_attributes}, valid_session
        assigns(:minimum_wage).should be_a(MinimumWage)
        assigns(:minimum_wage).should be_persisted
      end

      it "redirects to the created minimum_wage" do
        post :create, {:minimum_wage => valid_attributes}, valid_session
        response.should redirect_to(MinimumWage.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved minimum_wage as @minimum_wage" do
        # Trigger the behavior that occurs when invalid params are submitted
        MinimumWage.any_instance.stub(:save).and_return(false)
        post :create, {:minimum_wage => { "user" => "invalid value" }}, valid_session
        assigns(:minimum_wage).should be_a_new(MinimumWage)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        MinimumWage.any_instance.stub(:save).and_return(false)
        post :create, {:minimum_wage => { "user" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested minimum_wage" do
        minimum_wage = MinimumWage.create! valid_attributes
        # Assuming there are no other minimum_wages in the database, this
        # specifies that the MinimumWage created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        MinimumWage.any_instance.should_receive(:update_attributes).with({ "user" => "" })
        put :update, {:id => minimum_wage.to_param, :minimum_wage => { "user" => "" }}, valid_session
      end

      it "assigns the requested minimum_wage as @minimum_wage" do
        minimum_wage = MinimumWage.create! valid_attributes
        put :update, {:id => minimum_wage.to_param, :minimum_wage => valid_attributes}, valid_session
        assigns(:minimum_wage).should eq(minimum_wage)
      end

      it "redirects to the minimum_wage" do
        minimum_wage = MinimumWage.create! valid_attributes
        put :update, {:id => minimum_wage.to_param, :minimum_wage => valid_attributes}, valid_session
        response.should redirect_to(minimum_wage)
      end
    end

    describe "with invalid params" do
      it "assigns the minimum_wage as @minimum_wage" do
        minimum_wage = MinimumWage.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        MinimumWage.any_instance.stub(:save).and_return(false)
        put :update, {:id => minimum_wage.to_param, :minimum_wage => { "user" => "invalid value" }}, valid_session
        assigns(:minimum_wage).should eq(minimum_wage)
      end

      it "re-renders the 'edit' template" do
        minimum_wage = MinimumWage.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        MinimumWage.any_instance.stub(:save).and_return(false)
        put :update, {:id => minimum_wage.to_param, :minimum_wage => { "user" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested minimum_wage" do
      minimum_wage = MinimumWage.create! valid_attributes
      expect {
        delete :destroy, {:id => minimum_wage.to_param}, valid_session
      }.to change(MinimumWage, :count).by(-1)
    end

    it "redirects to the minimum_wages list" do
      minimum_wage = MinimumWage.create! valid_attributes
      delete :destroy, {:id => minimum_wage.to_param}, valid_session
      response.should redirect_to(minimum_wages_url)
    end
  end

end