require 'rails_helper'

RSpec.describe 'Projects', type: :request do
  let(:user) { create(:user) }
  let(:tokens) { user.create_new_auth_token }

  describe 'with persisted object' do
    let(:project) { create(:project, :factory_project, user: user) }
    let(:factory_project) { factory_v1_json('factory_project') }

    it 'returns unauthorized status' do
      get api_v1_projects_path
      expect(response).to have_http_status(401)
    end

    it 'shows projects' do
      project # init
      get api_v1_projects_path, headers: tokens
      expect(response).to have_http_status(200)
      expect(json.to_json).to be_json_eql(factory_v1_json('factory_projects').to_json)
    end

    it 'shows project' do
      get api_v1_project_path(project), headers: tokens
      expect(response).to have_http_status(200)
      expect(json.to_json).to be_json_eql(factory_project.to_json)
    end

    it 'update project' do
      params = {
        data: {
          type: :projects, id: project.id, attributes: { name: 'updated name'}
        }
      }

      put api_v1_project_path(project), params: params, headers: tokens
      expect(response).to have_http_status(200)
      expect(json.to_json).to be_json_eql(factory_project
        .deep_merge({ 'data' => {
          'attributes' => {
            'name' => params[:data][:attributes][:name]
          }
        }}).to_json)
    end

    it 'destroy project' do
      delete api_v1_project_path(project), headers: tokens
      expect(response).to have_http_status(204)
    end
  end

  describe 'with new object' do
    it 'create new project' do
      project = build(:project, :factory_project, user: user)
      params = {
        data: {
          type: :projects,
          attributes: project.attributes.slice('name')
        }
      }
      post api_v1_projects_path, params: params, headers: tokens
      created_project = Project.find_by(name: project.name)

      expect(response).to have_http_status(:created)
      expect(json.to_json).to be_json_eql(factory_v1_json('factory_project')
        .deep_merge({ 'data' => {
          'id' => created_project.id.to_s,
          'links' => {
            'self' => api_v1_project_url(created_project)
          }
        }}).to_json)
    end
  end
end
