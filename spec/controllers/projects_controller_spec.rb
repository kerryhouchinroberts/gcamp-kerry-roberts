require 'rails_helper'

describe ProjectsController, type: :controller do

  describe "#show" do
    it "allows project members to see projects they are part of" do
      @project = Project.create(name: "name")
      @user = User.create(first_name: 'first', last_name: 'last', email: 'firstlast@email.com', password: 'pass')
      membership = Membership.create(project_id: @project.id, user_id: @user.id)
      session[:user_id] = @user.id
      get :show, id: @project.id
      expect(response).to render_template(:show)
    end
  end
end
