require 'rails_helper'

RSpec.describe Api::V1::CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { user.projects.create(build(:project).attributes) }
  let(:task) { project.tasks.create(build(:task).attributes) }

  let(:valid_attributes) {
    build(:comment, body: 'new comment').attributes
  }

  let(:filename) { 'small.png' }
  let(:attachment) { fixuter_file_uploader("files/#{filename}") }

  let(:invalid_attributes) {
    build(:comment, body: 'small').attributes
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
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "renders a JSON response with the new comment" do
        post :create, params: { project_id: project.id, task_id: task.id, comment: valid_attributes.merge({attachment: attachment}) }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/vnd.api+json')
        expect(response.location).to eq(project_task_comment_url(project, task, Comment.last))
        expect(json[:data][:attributes][:attachment][:url]).to include(filename)
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new comment" do
        post :create, params: { project_id: project.id, task_id: task.id, comment: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/vnd.api+json')
        expect(json[:body]).to include(include('is too short'))
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
