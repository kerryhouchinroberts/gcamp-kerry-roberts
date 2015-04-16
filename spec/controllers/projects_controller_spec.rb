require 'rails_helper'

describe ProjectsController, type: :controller do

  describe "#index" do
    it "allows users to see projects they are part of on the index page" do
      @project = Project.create!(name: "name")
      @user = User.create!(first_name: 'first', last_name: 'last', email: 'firstlast@email.com', password: 'pass')
      membership = Membership.create!(project_id: @project.id, user_id: @user.id)
      session[:user_id] = @user.id
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "#show" do
    it "allows project members to see projects they are part of" do
      @project = Project.create!(name: "name")
      @user = User.create!(first_name: 'first', last_name: 'last', email: 'firstlast@email.com', password: 'pass')
      membership = Membership.create!(project_id: @project.id, user_id: @user.id)
      session[:user_id] = @user.id
      get :show, id: @project.id
      expect(response).to render_template(:show)
    end
  end

  describe "#show" do
    it "denies users from seeing projects they are not part of" do
      user = User.create!(first_name: 'first', last_name: 'last', email: 'firstlast@email.com', password: 'pass')
      project = Project.create!(name: "project that the user belongs to")
      project2 = Project.create!(name: "project that the user does not belong to")
      membership = Membership.create!(project_id: project.id, user_id: user.id)
      session[:user_id] = user.id
      get :show, id: project2.id
      expect(response).to redirect_to('/projects')
    end
  end

  describe "#edit" do
    it "allows project owners to edit their projects" do
      user = User.create!(first_name: 'first', last_name: 'last', email: 'firstlast@email.com', password: 'pass')
      project = Project.create!(name: "project that the user owns")
      membership = Membership.create!(project_id: project.id, user_id: user.id, role: "owner")
      session[:user_id] = user.id
      get :edit, id: project.id
      expect(response).to render_template(:edit)
    end
  end

  describe "#edit" do
    it "denies users who do not own the project from editing it" do
      user = User.create!(first_name: 'first', last_name: 'last', email: 'firstlast@email.com', password: 'pass')
      project = Project.create!(name: "project that the user owns")
      project2 = Project.create!(name: "project that the user does not own")
      membership = Membership.create!(project_id: project.id, user_id: user.id, role: "owner")
      session[:user_id] = user.id
      get :edit, id: project2.id
      expect(response).to redirect_to("/projects")
    end
  end

  describe "#create" do
    it "allows a user to create a project" do
      user = User.create!(first_name: 'first', last_name: 'last', email: 'firstlast@email.com', password: 'pass')
      session[:user_id] = user.id
      post :create, :project => {name: "project that the user owns"}
      expect(response).to have_http_status(:found)
    end
  end

  describe "#create" do
    it "creates a membership, also, and adds the current user as an owner to any project they create" do
      user = User.create!(first_name: 'first', last_name: 'last', email: 'firstlast@email.com', password: 'pass')
      project = Project.create!(name: "project that the user owns")
      session[:user_id] = user.id
      post :create, {id: project.id, :project => {name: "project that the user owns"}}
      expect(user.memberships.last.role).to eq("owner")
    end
  end

  describe "#create" do
    it "creates a membership, also, and adds the current user as an owner to any project they create" do
      user = User.create!(first_name: 'first', last_name: 'last', email: 'firstlast@email.com', password: 'pass')
      project = Project.create!(name: "project that the user owns")
      session[:user_id] = user.id
      post :create, {id: project.id, :project => {name: "project that the user owns"}}
      expect(user.memberships.last.role).to eq("owner")
    end
  end

  describe "#update" do
    it "allows project owners to update projects" do
      user = User.create!(first_name: 'first', last_name: 'last', email: 'firstlast@email.com', password: 'pass')
      project = Project.create!(name: "project that the user owns")
      membership = Membership.create!(project_id: project.id, user_id: user.id, role: "owner")
      session[:user_id] = user.id
      put :update, {id: project.id, :project => {name: "project that the user owns is updated"}}
      project.reload
      expect(project.name).to eq("project that the user owns is updated")
    end
  end

  describe "#update" do
    it "denies non project owners from updating projects" do
      user = User.create(first_name: 'first', last_name: 'last', email: 'firstlast@email.com', password: 'pass')
      project = Project.create!(name: "project that the user owns")
      project2 = Project.create!(name: "project that the user does not own")
      membership = Membership.create!(project_id: project.id, user_id: user.id, role: "owner")
      session[:user_id] = user.id
      put :update, {id: project2.id, :project => {name: "project that the user owns is updated"}}
      project.reload
      expect(response).to redirect_to("/projects")
    end
  end

  describe "#destroy" do
    it "allows project owners to delete projects" do
      user = User.create(first_name: 'first', last_name: 'last', email: 'firstlast@email.com', password: 'pass')
      project = Project.create!(name: "project that the user owns")
      session[:user_id] = user.id
      delete :destroy, {id: project.id, :project => {name: "project that the user owns"}}
      expect(response).to redirect_to("/projects")
    end
  end

  describe "#destroy" do
    it "allows admin users to delete projects" do
      user = User.create!(first_name: 'first', last_name: 'last', email: 'firstlast@email.com', password: 'pass', admin: true)
      project = Project.create!(name: 'random project')
      session[:user_id] = user.id
      delete :destroy, {id: project.id, :project => {name: project.name}}
      expect(response).to redirect_to("/projects")
    end
  end
end
