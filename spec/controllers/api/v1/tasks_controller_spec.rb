require 'rails_helper'

RSpec.describe Api::V1::TasksController, type: :controller do
  let(:user) { create(:user) }

  let(:project) { user.projects.create(build(:project).attributes) }

  let(:valid_attributes) {
    build(:task, name: 'new task').attributes
  }

  let(:valid_params) {
    {
      data: {
        type: :tasks,
        attributes: valid_attributes.slice('name')
      }
    }
  }

  let(:invalid_params) {
    {
      data: {
        type: :tasks,
        attributes: build(:task, name: '').attributes.slice('name')
      }
    }
  }

  before { token_sign_in(user) }

  describe "GET #index" do
    it "returns a success response" do
      task = project.tasks.create!(valid_attributes)
      get :index, params: {project_id: project.id}
      expect(json[:data].first[:attributes]).to include(name: task.name)
    end
  end

  describe "GET #show" do
    let(:task) { project.tasks.create!(valid_attributes) }

    it "returns a success response" do
      get :show, params: { project_id: project.id, id: task.to_param }
      expect(response).to be_success
      expect(json[:data][:attributes]).to include(name: task.name)
    end

    it "returns an error for another user" do
      another_user = create(:user)
      token_sign_in(another_user)
      get :show, params: { project_id: project.id, id: task.to_param }
      expect(json[:message]).to include("Couldn't find Project")
    end
  end

  describe "POST #create" do
    context "with valid params" do

      it "renders a JSON response with the new task" do
        post :create, params: { project_id: project.id}.merge(valid_params)
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/vnd.api+json')
        expect(json[:data][:links][:self]).to include(api_v1_project_task_path(project, Task.last))
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new task" do
        post :create, params: { project_id: project.id }.merge(invalid_params)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/vnd.api+json')
        expect(json[:errors]). to include(include(title: "can't be blank"))
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:task1) { project.tasks.create!(valid_attributes) }
      let(:task2) { project.tasks.create!(valid_attributes) }
      let(:task3) { project.tasks.create!(valid_attributes) }
      let(:new_attributes) {
        {
          data: {
            type: :tasks,
            id: task1.id,
            attributes: { name: 'New Name', position: 2 }
          }
        }
      }

      it "updates the requested task & checking position" do
        put :update, params: { project_id: project.id, id: task1.to_param}.merge(new_attributes)
        task1.reload
        expect(task1.name).to eq new_attributes[:data][:attributes][:name]
        expect(json[:data][:attributes]).to include(new_attributes[:data][:attributes])
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the project" do
        task = project.tasks.create!(valid_attributes)
        put :update, params: {
          project_id: project.id, id: task.to_param
        }.merge(invalid_params.deep_merge(data: {id: task.id}))

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/vnd.api+json')
        expect(json[:errors]). to include(include(title: "can't be blank"))
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested task" do
      task = project.tasks.create!(valid_attributes)
      expect {
        delete :destroy, params: { project_id: project.id, id: task.to_param }
      }.to change(Task, :count).by(-1)
    end
  end

end
