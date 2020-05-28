require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe "#new" do

    before do
      get :new
    end

    it "instantiates a new user object" do
      expect(assigns(:user)).to be_a_new(User)
    end

    it "renders the new template" do
      expect(response).to render_template(:new)
    end
  end

  describe "#create" do

    def valid_request
      post :create, params: {
        user: FactoryBot.attributes_for(:user)
      }
    end

    context "with valid params" do
      it "creates a user in the database" do
        before_count = User.count
        valid_request
        after_count = User.count
        expect(after_count - before_count).to eq(1)
      end

      it "redirects to home page" do
        valid_request
        expect(response).to redirect_to(root_path)
      end

      it "signs the user in" do
        valid_request
        # expect(session[:user_id]).to be
        expect(session[:user_id]).to eq(User.last.id)
      end
    end

    context "without valid params" do

      def invalid_request
        post :create, params: {
          user: FactoryBot.attributes_for(:user, first_name: nil)
        }
      end

      it "renders the new template" do
        invalid_request
        expect(response).to render_template(:new)
      end

      it "doesn't create a user in the database" do
        before_count = User.count
        invalid_request
        after_count = User.count
        expect(after_count).to eq(before_count)
      end
    end
  end
end