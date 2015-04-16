require 'rails_helper'

describe MembershipsController, type: :controller do

  describe "#index" do
    it "redirects non-signed-in users to sign-in page when they try to access index" do
      @project = Project.create(name: "name")
      @user = User.create(first_name: 'first', last_name: 'last', email: 'firstlast@email.com', password: 'pass')
      @membership = Membership.create(project_id: @project.id)
      get :index, :project_id => @project.id
      expect(response).to redirect_to('/sign-in')
    end
  end

  describe "#index" do
    it "allows signed-in users to access sign-in page" do
      @project = Project.create(name: "name")
      @user = User.create(first_name: 'first', last_name: 'last', email: 'firstlast@email.com', password: 'pass')
      @membership = Membership.create(project_id: @project.id)
      get :index, :project_id => @project.id
      expect(response).to redirect_to('/sign-in')
    end
  end

  describe "#index" do
    it "redirects non project-members to the projects index when trying to access memberships" do
      @project = Project.create(name: "name")
      @user = User.create(first_name: 'first', last_name: 'last', email: 'firstlast@email.com', password: 'pass')
      @membership = Membership.create(project_id: @project.id)
      session[:user_id]= @user.id
      get :index, :project_id => @project.id
      expect(response).to redirect_to('/projects')
    end
  end

  describe "#index" do
    it "allows project members to view the memberships index" do
      @project = Project.create(name: "name")
      @user = User.create(first_name: 'first', last_name: 'last', email: 'firstlast@email.com', password: 'pass')
      @membership = Membership.create(user_id: @user.id, project_id: @project.id)
      session[:user_id]= @user.id
      get :index, :project_id => @project.id
      expect(response).to render_template(:index)
    end
  end

  describe "#index" do
    it "allows admins to view the memberships index" do
      @project = Project.create(name: "name")
      @user = User.create(first_name: 'first', last_name: 'last', email: 'firstlast@email.com', password: 'pass', admin: true)
      session[:user_id] = @user.id
      get :index, :project_id => @project.id
      expect(response).to render_template(:index)
    end
  end

  describe "#update" do
    it "redirects non project-owners to the projects index when trying to update memberships" do
      @project = Project.create(name: "name")
      @user = User.create(first_name: 'first', last_name: 'last', email: 'firstlast@email.com', password: 'pass', admin: false)
      @membership = Membership.create(user_id: @user.id, project_id: @project.id, role: "member")
      session[:user_id] = @user.id
      patch :update, id: @membership.id, project_id: @project.id, membership: {role: "owner"}
      expect(response).to redirect_to('/projects')
    end
  end

  describe "#update" do
    it "allows project owners to update memberships" do
      @project = Project.create(name: "name")
      @user = User.create(first_name: 'first', last_name: 'last', email: 'firstlast@email.com', password: 'pass', admin: false)
      @membership = Membership.create(user_id: @user.id, project_id: @project.id, role: "owner")
      session[:user_id] = @user.id
      patch :update, id: @membership.id, project_id: @project.id, membership: {role: "member"}
      expect(response.request.path).to eq("/projects/#{@project.id}/memberships/#{@membership.id}")
      expect(response.location).to eq("http://test.host/projects/#{@project.id}/memberships")
    end
  end

  describe "#update" do
    it "allows admin users to update memberships" do
      @project = Project.create(name: "name")
      @user = User.create(first_name: 'first', last_name: 'last', email: 'firstlast@email.com', password: 'pass', admin: true)
      @user2 = User.create(first_name: 'first', last_name: 'last', email:'user2@user.com', password: 'pass', admin: false)
      membership = Membership.create!(
        project_id: @project.id,
        role: "member",
        user_id: @user2.id
      )

      session[:user_id] = @user.id

      put :update,
        {:id => membership.id,
          project_id: @project.id,

        :membership => {
          project_id: @project.id,
          role: "owner",
          user_id: @user2.id
          }
        }

      membership.reload
      expect(membership.role).to eq("owner")
    end
  end

  describe "#destroy" do
    it "allows admin users to destroy memberships" do
      @project = Project.create(name: "name")
      @user = User.create(first_name: 'first', last_name: 'last', email: 'firstlast@email.com', password: 'pass', admin: true)
      membership = Membership.create!(
        project_id: @project.id,
        role: "member",
        user_id: @user.id
      )

      session[:user_id] = @user.id

      delete :destroy,
        {:id => membership.id,
          project_id: @project.id,

        :membership => {
          project_id: @project.id,
          role: "owner",
          user_id: @user.id
          }
        }

      expect(response).to redirect_to('/projects')
    end
  end
end
