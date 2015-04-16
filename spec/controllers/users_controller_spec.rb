require 'rails_helper'

describe UsersController, type: :controller do

  describe "#index" do
    it "allows authenicated users to see all users" do
      user = User.create!(first_name: 'first', last_name: "last", email: "firstlast@email.com", password: "pass")
      session[:user_id] = user.id
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "#index" do
    it "denies non authenticated users from seeing all users" do
    get :index
    expect(response).to redirect_to("/sign-in")
    end
  end

  describe "#show" do
    it "allows authenticated users to see a user's show page" do
    user = User.create!(first_name: 'first', last_name: "last", email: "firstlast@email.com", password: "pass")
    session[:user_id] = user.id
    get :show, id: user.id
    expect(response).to render_template(:show)
    end
  end

  describe "#show" do
    it "denies non authenticated users from seeing a user's show page" do
    user = User.create!(first_name: 'first', last_name: "last", email: "firstlast@email.com", password: "pass")
    get :show, id: user.id
    expect(response).to redirect_to("/sign-in")
    end
  end

  describe "#edit" do
    it "allows the current user to see the edit page to update their user info" do
    user = User.create!(first_name: 'first', last_name: "last", email: "firstlast@email.com", password: "pass")
    session[:user_id] = user.id
    get :edit, id: user.id
    expect(response).to render_template(:edit)
    end
  end

  describe "#edit" do
    it "allows admin users to see the edit page to update anyone's user info" do
    admin_user = User.create!(first_name: 'first', last_name: "last", email: "firstlast@email.com", password: "pass", admin: true)
    non_admin_user = User.create!(first_name: 'first', last_name: "last", email: "notadmin@email.com", password: "pass", admin: false)
    session[:user_id] = admin_user.id
    get :edit, id: non_admin_user.id
    expect(response).to render_template(:edit)
    end
  end

  describe "#edit" do
    it "status is 404 if non authenticated users try to access edit page to update another user's info" do
    authenticated_user = User.create!(first_name: 'first', last_name: "last", email: "firstlast@email.com", password: "pass", admin: true)
    non_authenticated_user = User.create!(first_name: 'first', last_name: "last", email: "notadmin@email.com", password: "pass", admin: false)
    session[:user_id] = non_authenticated_user.id
    get :edit, id: authenticated_user.id
    expect(response.status).to eq(404)
    end
  end

  describe "#create" do
    it "allows a user to create another user" do
    user = User.create!(first_name: 'first', last_name: "last", email: "firstlast@email.com", password: "pass", admin: false)
    session[:user_id] = user.id
    post :create, :user => {first_name: 'f', last_name: 'l', email: 'e@e.com', password: 'pass'}
    expect(response).to have_http_status(:found)
    end
  end

  describe "#create" do
    it "allows an admin user to create another admin user" do
    user = User.create!(first_name: 'first', last_name: "last", email: "firstlast@email.com", password: "pass", admin: true)
    session[:user_id] = user.id
    post :create, :user => {first_name: 'f', last_name: 'l', email: 'e@e.com', password: 'pass', admin: false}
    expect(response).to have_http_status(:found)
    end
  end

  describe "#update" do
    it "allows a non-admin user to update their own info" do
    user = User.create!(first_name: 'first', last_name: "last", email: "firstlast@email.com", password: "pass", admin: false)
    session[:user_id] = user.id
    put :update, {id: user.id, :user => {first_name: 'f', last_name: 'l', email: 'e@e.com', password: 'pass', admin: false}}
    user.reload
    expect(user.first_name).to eq('f')
    end
  end

  describe "#update" do
    it "allows an admin user to update another user's info" do
    user = User.create!(first_name: 'first', last_name: "last", email: "firstlast@email.com", password: "pass", admin: false)
    admin_user = User.create!(first_name: 'first', last_name: "last", email: "adminuser@email.com", password: "pass", admin: true)
    session[:user_id] = admin_user.id
    put :update, {id: user.id, :user => {first_name: 'f', last_name: 'l', email: 'e@e.com', password: 'pass', admin: false}}
    user.reload
    expect(user.first_name).to eq('f')
    end
  end

  describe "#update" do
    it "denies a non authenticated user from updating another user's info" do
    non_authenticated_user = User.create!(first_name: 'first', last_name: "last", email: "firstlast@email.com", password: "pass", admin: false)
    other_user = User.create!(first_name: 'first', last_name: "last", email: "adminuser@email.com", password: "pass", admin: true)
    session[:user_id] = non_authenticated_user.id
    put :update, {id: other_user.id, :user => {first_name: 'f', last_name: 'l', email: 'e@e.com', password: 'pass', admin: false}}
    other_user.reload
    expect(response.status).to eq(404)
    end
  end

  describe "#destroy" do
    it "allows a user to delete their own record" do
    user = User.create!(first_name: 'first', last_name: "last", email: "firstlast@email.com", password: "pass", admin: false)
    session[:user_id] = user.id
    expect { delete :destroy, :id => user.id }.to change(User, :count)
    end
  end

  describe "#destroy" do
    it "allows an admin user to delete any user" do
    admin_user = User.create!(first_name: 'first', last_name: "last", email: "firstlast@email.com", password: "pass", admin: true)
    non_admin_user = User.create!(first_name: 'first', last_name: "last", email: "regularuser@email.com", password: "pass", admin: false)
    session[:user_id] = admin_user.id
    expect { delete :destroy, :id => non_admin_user.id }.to change(User, :count)
    end
  end

  describe "#destroy" do
    it "prevents a user from deleting another user" do
    user = User.create!(first_name: 'first', last_name: "last", email: "firstlast@email.com", password: "pass", admin: false)
    other_user = User.create!(first_name: 'first', last_name: "last", email: "regularuser@email.com", password: "pass", admin: false)
    session[:user_id] = user.id
    expect { delete :destroy, :id => other_user.id }.to_not change(User, :count)
    end
  end

end
