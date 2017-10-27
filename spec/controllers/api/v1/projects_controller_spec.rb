require 'rails_helper'

RSpec.describe Api::V1::ProjectsController, type: :controller do
  let(:user) { create(:user) }

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

  before {token_sign_in(user)}

  describe "GET #index" do
    it "returns a success response" do
      project = user.projects.create(valid_attributes)
      get :index, params: {}
      expect(json[:data]).to include(include(attributes: {name: project.name}))
    end
  end

  describe "GET #show" do
    let(:another_user) { create(:user) }
    let(:project) { user.projects.create(valid_attributes) }

    it "returns a success response" do
      get :show, params: {id: project.to_param}
      expect(json[:data]).to include(attributes: {name: project.name})
    end

    it "returns an error for another user" do
      token_sign_in(another_user)
      get :show, params: {id: project.to_param}
      expect(json[:errors].first[:title]).to include("Couldn't find Project")
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "renders a JSON response with the new project" do
        post :create, params: valid_params
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/vnd.api+json')
        expect(json[:data][:links][:self]).to eq(api_v1_project_url(Project.last))
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new project" do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/vnd.api+json')
        expect(json[:errors]). to include(include(title: "can't be blank"))
      end
    end
  end

  describe "PUT #update" do
    let(:project) { user.projects.create(valid_attributes) }

    context "with valid params" do
      let(:new_attributes) {
        {
          data: {
            type: :projects,
            id: project.id,
            attributes: { name: 'New Name' }
          }
        }
      }

      it "updates the requested project" do
        put :update, params: {id: project.to_param }.merge(new_attributes)
        project.reload
        expect(project.name).to eq new_attributes[:data][:attributes][:name]
        expect(json[:data][:attributes]).to include(new_attributes[:data][:attributes])
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the project" do
        put :update, params: {
          id: project.to_param
        }.merge(invalid_params.deep_merge(data: {id: project.id}))
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/vnd.api+json')
        expect(json[:errors]). to include(include(title: "can't be blank"))
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested project" do
      project = user.projects.create(valid_attributes)
      expect {
        delete :destroy, params: {id: project.to_param}
      }.to change(Project, :count).by(-1)
    end
  end

  describe 'user ability' do
    let(:project) { create(:project, user: user) }
    let(:ability) { Object.new }

    before do
      allow(Project).to receive(:find).and_return(project)
      ability.extend(CanCan::Ability)
      ability.can :manage, :all
      allow(@controller).to receive(:current_ability).and_return(ability)
    end

    it 'cancan doesnt allow :index' do
      ability.cannot :index, Project
      get :index, params: {}
      expect(json[:errors].first[:title]).to include('You are not authorized')
    end

    it 'cancan doesnt allow :show' do
      ability.cannot :show, Project
      get :show, params: { id: project.id }
      expect(json[:errors].first[:title]).to include('You are not authorized')
    end

    it 'cancan doesnt allow :create' do
      ability.cannot :create, Project
      post :create, params: valid_params
      expect(json[:errors].first[:title]).to include('You are not authorized')
    end

    it 'cancan doesnt allow :update' do
      ability.cannot :update, Project
      put :update, params: valid_params.deep_merge(id: project.id, data: {id: project.id})
      expect(json[:errors].first[:title]).to include('You are not authorized')
    end

    it 'cancan doesnt allow :destroy' do
      ability.cannot :destroy, Project
      delete :destroy, params: { id: project.id }
      expect(json[:errors].first[:title]).to include('You are not authorized')
    end
  end
end
