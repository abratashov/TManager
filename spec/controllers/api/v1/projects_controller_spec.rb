require 'rails_helper'

RSpec.describe Api::V1::ProjectsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:content_type) { 'application/vnd.api+json; charset=utf-8' }
  let(:valid_attributes) {
    build(:project, name: 'new project').attributes
  }

  let(:valid_params) {
    {
      data: {
        type: :projects,
        attributes: valid_attributes.slice('name')
      }
    }
  }

  let(:invalid_params) {
    {
      data: {
        type: :projects,
        attributes: build(:project, name: '').attributes.slice('name')
      }
    }
  }

  before { token_sign_in(user) }

  describe 'GET #index' do
    let(:project) { user.projects.create(valid_attributes) }

    before { project }

    it 'returns a success response' do
      get :index, params: {}
      expect(json[:data]).to include(include(attributes: { name: project.name }))
    end

    it 'allow for any user' do
      token_sign_in(another_user)
      get :index, params: {}
      expect(json[:data]).to eq []
    end
  end

  describe 'GET #show' do
    let(:another_user) { create(:user) }
    let(:project) { user.projects.create(valid_attributes) }

    it 'returns a success response' do
      get :show, params: { id: project.to_param }
      expect(json[:data]).to include(attributes: { name: project.name })
    end

    it 'returns an error for another user' do
      token_sign_in(another_user)
      get :show, params: { id: project.to_param }
      expect(json[:errors].first[:title]).to include("Couldn't find Project")
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'renders a JSON response with the new project' do
        post :create, params: valid_params
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq content_type
        expect(json[:data][:links][:self]).to eq(api_v1_project_url(Project.last))
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new project' do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq content_type
        expect(json[:errors]). to include(name: ["must be filled"])
      end
    end
  end

  describe 'PUT #update' do
    let(:project) { user.projects.create(valid_attributes) }

    context 'with valid params' do
      let(:new_attributes) {
        {
          data: {
            type: :projects,
            id: project.id,
            attributes: { name: 'New Name' }
          }
        }
      }

      it 'updates the requested project' do
        put :update, params: { id: project.to_param }.merge(new_attributes)
        project.reload
        expect(project.name).to eq new_attributes[:data][:attributes][:name]
        expect(json[:data][:attributes]).to include(new_attributes[:data][:attributes])
      end

      it 'doesnt allow for another user' do
        token_sign_in(another_user)
        put :update, params: { id: project.to_param }.merge(new_attributes)
        expect(json[:errors].first[:title]).to include("Couldn't find Project")
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the project' do
        put :update, params: {
          id: project.to_param
        }.merge(invalid_params.deep_merge(data: { id: project.id }))
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq content_type
        expect(json[:errors]). to include(name: ["must be filled"])
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:project) { user.projects.create(valid_attributes) }

    before { project }

    it 'destroys the requested project' do
      expect {
        delete :destroy, params: { id: project.to_param }
      }.to change(Project, :count).by(-1)
    end

    it 'doesnt allow for another user' do
      token_sign_in(another_user)
      delete :destroy, params: { id: project.to_param }
      expect(json[:errors].first[:title]).to include("Couldn't find Project")
    end
  end

  describe 'without user' do
    before { token_sign_out }

    it 'fetch projects' do
      get :index, params: {}
      expect(json[:errors].first).to include('You need to sign in or sign up before continuing')
    end
  end
end
