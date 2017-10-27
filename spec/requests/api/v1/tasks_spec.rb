require 'rails_helper'

RSpec.describe 'Tasks', type: :request do
  let(:user) { create(:user) }
  let(:tokens) { user.create_new_auth_token }
  let(:project) { create(:project, :factory_project, user: user) }

  describe 'with persisted object' do
    let!(:task) { create(:task, :factory_task, project: project) }
    let(:factory_task) { factory_v1_json('factory_task') }

    it 'returns unauthorized status' do
      get api_v1_project_tasks_path(project)
      expect(response).to have_http_status(401)
    end

    it 'shows tasks' do
      get api_v1_project_tasks_path(project), headers: tokens
      expect(response).to have_http_status(200)
      expect(json.to_json).to be_json_eql(factory_v1_json('factory_tasks').to_json)
    end

    it 'shows task' do
      get api_v1_project_task_path(project, task), headers: tokens
      expect(response).to have_http_status(200)
      expect(json.to_json).to be_json_eql(factory_task.to_json)
    end

    it 'update task' do
      params = {
        data: {
          type: :tasks, id: task.id, attributes: { name: 'updated name'}
        }
      }

      put api_v1_project_task_path(project, task), params: params, headers: tokens
      expect(response).to have_http_status(200)
      expect(json.to_json).to be_json_eql(factory_task
        .deep_merge({ 'data' => {
          'attributes' => {
            'name' => params[:data][:attributes][:name]
          }
        }}).to_json)
    end

    it 'destroy task' do
      delete api_v1_project_task_path(project, task), headers: tokens
      expect(response).to have_http_status(204)
    end
  end

  describe 'with new object' do

    it 'create new task' do
      task = build(:task, :factory_task, project: project)
      params = {
        data: {
          type: :tasks,
          attributes: task.attributes.slice('name', 'deadline', 'position', 'done')
        }
      }
      post api_v1_project_tasks_path(project), params: params, headers: tokens
      created_task = Task.find_by(name: task.name, project: project)

      expect(response).to have_http_status(:created)
      expect(json.to_json).to be_json_eql(factory_v1_json('factory_task')
        .deep_merge({ 'data' => {
          'id' => created_task.id.to_s,
          'links' => {
            'self' => api_v1_project_task_url(project, created_task)
          }
        }}).to_json)
    end
  end
end
