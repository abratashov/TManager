require 'rails_helper'

RSpec.describe Api::V1::CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { user.projects.create(build(:project).attributes) }
  let(:task) { project.tasks.create(build(:task).attributes) }

  let(:valid_attributes) {
    build(:comment, body: 'new comment').attributes
  }

  let(:filename) { 'small.png' }
  let(:attachment) { fixture_file_uploader("files/#{filename}") }

  let(:valid_params) {
    {
      data: {
        type: :comments,
        attributes: valid_attributes.slice('body')
      }
    }
  }

  let(:invalid_params) {
    {
      data: {
        type: :comments,
        attributes: build(:comment, body: 'small').attributes.slice('body')
      }
    }
  }

  before { token_sign_in(user) }

  describe "GET #index" do
    it "returns a success response" do
      comment = task.comments.create!(valid_attributes)
      get :index, params: { project_id: project.id, task_id: task.id }
      expect(json[:data].first[:attributes]).to include(body: comment.body)
    end

    it "returns an error for another user" do
      another_user = create(:user)
      token_sign_in(another_user)
      get :index, params: { project_id: project.id, task_id: task.id }
      expect(json[:message]).to include("Couldn't find Project")
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "renders a JSON response with the new comment" do
        post :create, params: {
          project_id: project.id,
          task_id: task.id
        }.merge(valid_params.deep_merge({
          data: {
            attributes: { attachment: attachment }
          }
        }))

        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/vnd.api+json')
        expect(json[:data][:links][:self]).to eq(api_v1_project_task_comment_url(project, task, Comment.last))
        expect(json[:data][:attributes][:attachment][:url]).to include(filename)
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new comment" do
        post :create, params: { project_id: project.id, task_id: task.id}.merge(invalid_params)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/vnd.api+json')
        expect(json[:errors]). to include(include(title: 'is too short (minimum is 10 characters)'))
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested comment" do
      comment = task.comments.create!(valid_attributes)
      expect {
        delete :destroy, params: { project_id: project.id, task_id: task.id, id: comment.to_param }
      }.to change(Comment, :count).by(-1)
    end
  end

end
