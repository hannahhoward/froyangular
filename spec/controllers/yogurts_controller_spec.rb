require 'spec_helper'

describe YogurtsController do
  let :valid_attributes do
    {
      :flavor => "chocolate",
      :topping => "sprinkles",
      :quantity => 10.0
    }
  end

  describe "GET index" do
    let! :yogurt1 do
      Yogurt.create! valid_attributes
    end

    let! :yogurt2 do
      Yogurt.create! valid_attributes
    end

    before do
      get :index
    end

    it "should render the index template" do
      expect(response).to render_template :index
    end

    it "should succeed" do
      expect(response).to be_success
    end

    it "should assign yogurts to all yogurts" do
      expect(assigns(:yogurts)).to include(yogurt1)
      expect(assigns(:yogurts)).to include(yogurt2)
    end
  end

  describe "GET show" do
    before do
      @yogurt = Yogurt.create! valid_attributes
      get :show, id: @yogurt.id
    end

    it "should render the index template" do
      expect(response).to render_template :show
    end

    it "should succeed" do
      expect(response).to be_success
    end

    it "should assign yogurts to all yogurts" do
      expect(assigns(:yogurt)).to eq(@yogurt)
    end
  end

  describe "GET edit" do
    before do
      @yogurt = Yogurt.create! valid_attributes
      get :edit, id: @yogurt.id
    end

    it "should render the index template" do
      expect(response).to render_template :edit
    end

    it "should succeed" do
      expect(response).to be_success
    end

    it "should assign yogurts to all yogurts" do
      expect(assigns(:yogurt)).to eq(@yogurt)
    end
  end

  describe "GET new" do
    before do
      get :new
    end

    it "should render the new template" do
      expect(response).to render_template :new
    end

    it "should succeed" do
      expect(response).to be_success
    end

    it "should assign yogurt to be a new yogurt" do
      expect(assigns(:yogurt)).to be_a(Yogurt)
      expect(assigns(:yogurt)).to_not be_persisted
    end
  end

  describe "POST create" do
    describe "successful create" do
      it "should create a yogurt in the database" do
        expect do
          post :create, yogurt: valid_attributes
        end.to change(Yogurt, :count).by(1)
      end

      it "should redirect to the index page for yogurts" do
        post :create, yogurt: valid_attributes
        expect(response).to redirect_to yogurts_path
      end
    end

    describe "unable to save" do
      let :invalid_attributes do
        {
          :flavor => nil,
          :quantity => nil,
          :topping => nil
        }
      end

      it "should not create any new records in the database" do
        expect do
          post :create, yogurt: invalid_attributes
        end.to_not change(Yogurt, :count).by(1)
      end

      it "should rerender the new template" do
        post :create, yogurt: invalid_attributes
        expect(response).to render_template :new
      end
    end
  end

  describe "PUT update" do
    before do
      @test_yogurt = Yogurt.create! valid_attributes
    end

    describe "with successful update" do
      let :update_attributes do
        {
          :flavor => "chocolate",
          :topping => "sprinkles",
          :quantity => 6.0
        }
      end

      before do
        put :update, id: @test_yogurt.id, yogurt: update_attributes
      end

      it "should update the yogurt record in the database" do
        expect(@test_yogurt.reload.quantity).to eq(6.0)
      end

      it "should redirect to the index of all yogurts" do
        expect(response).to redirect_to yogurts_path
      end
    end

    describe "with invalid update attributes" do
      let :invalid_update_attributes do
        {
          :flavor => "chocolate",
          :topping => "sprinkles",
          :quantity => 25.0
        }
      end

      before do
        put :update, id: @test_yogurt.id, yogurt: invalid_update_attributes
      end

      it "should not update the yogurt record in the database" do
        expect(@test_yogurt.reload.quantity).to eq(10.0)
      end

      it "should rerender the edit view template" do
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE destroy" do
    before do
      @yogurt = Yogurt.create! valid_attributes
    end

    it "should delete a record from the database" do
      expect do
        delete :destroy, id: @yogurt.id
      end.to change(Yogurt, :count).by(-1)
    end

    it "should redirect to the index of all yogurts" do
      delete :destroy, id: @yogurt.id
      expect(response).to redirect_to yogurts_path
    end
  end
end