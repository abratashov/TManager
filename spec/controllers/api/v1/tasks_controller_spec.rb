require 'rails_helper'

RSpec.describe Api::V1::TasksController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

  let(:project) { create(:project, user: user) }

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

  describe 'GET #index' do
    it 'returns a success response' do
      task = project.tasks.create!(valid_attributes)
      get :index, params: { project_id: project.id }
      expect(json[:data].first[:attributes]).to include(name: task.name)
    end

    it 'allow for any user' do
      token_sign_in(another_user)
      get :index, params: { project_id: project.id }
      expect(json[:errors].first[:title]).to include("Couldn't find Project")
    end
  end

  describe 'GET #show' do
    let(:another_user) { create(:user) }
    let(:task) { project.tasks.create!(valid_attributes) }

    it 'returns a success response' do
      get :show, params: { id: task.to_param }
      expect(response).to have_http_status(:ok)
      expect(json[:data][:attributes]).to include(name: task.name)
    end

    it 'returns an error for another user' do
      token_sign_in(another_user)
      get :show, params: { id: task.to_param }
      expect(json[:errors].first[:title]).to include("Couldn't find Task")
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'renders a JSON response with the new task' do
        post :create, params: { project_id: project.id }.merge(valid_params)
        expect(response).to have_http_status(:created)
        expect(response.content_type).to include('application/vnd.api+json')
        expect(json[:data][:links][:self]).to include(api_v1_task_path(Task.last))
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new task' do
        post :create, params: { project_id: project.id }.merge(invalid_params)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/vnd.api+json')
        expect(json[:errors]). to include(name: ['must be filled'])
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
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

      it 'updates the requested task & checking position' do
        put :update, params: { id: task1.to_param }.merge(new_attributes)
        task1.reload
        expect(task1.name).to eq new_attributes[:data][:attributes][:name]
        expect(json[:data][:attributes]).to include(new_attributes[:data][:attributes])
      end

      it 'doesnt allow for another user' do
        token_sign_in(another_user)
        put :update, params: { id: task1.to_param }.merge(new_attributes)
        expect(json[:errors].first[:title]).to include("Couldn't find Task")
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the project' do
        task = project.tasks.create!(valid_attributes)
        put :update, params: {
          id: task.to_param
        }.merge(invalid_params.deep_merge(data: { id: task.id }))

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/vnd.api+json')
        expect(json[:errors]). to include(name: ['must be filled'])
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:task) { project.tasks.create!(valid_attributes) }

    it 'destroys the requested task' do
      task
      expect {
        delete :destroy, params: { id: task.to_param }
      }.to change(Task, :count).by(-1)
    end

    it 'doesnt allow for another user' do
      token_sign_in(another_user)
      delete :destroy, params: { id: task.to_param }
      expect(json[:errors].first[:title]).to include("Couldn't find Task")
    end
  end

  describe 'without user' do
    it 'fetch tasks' do
      token_sign_out
      get :index, params: { project_id: project.id }
      expect(json[:errors].first).to include('You need to sign in or sign up before continuing')
    end
  end
end
