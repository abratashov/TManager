require 'rails_helper'

RSpec.describe Api::V1::CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:project) { create(:project, user: user) }
  let(:task) { create(:task, project: project) }

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
  let(:another_user) { create(:user) }

  before { token_sign_in(user) }

  describe 'GET #index' do
    it 'returns a success response' do
      comment = task.comments.create!(valid_attributes)
      get :index, params: { project_id: project.id, task_id: task.id }
      expect(json[:data].first[:attributes]).to include(body: comment.body)
    end

    it 'returns an error for another user' do
      token_sign_in(another_user)
      get :index, params: { project_id: project.id, task_id: task.id }
      expect(json[:errors].first[:title]).to include("Couldn't find Task")
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:params) {
        {
          project_id: project.id,
          task_id: task.id
        }.merge(valid_params.deep_merge(
          data: {
            attributes: { attachment: attachment }
          }
        ))
      }

      it 'renders a JSON response with the new comment' do
        post :create, params: params
        expect(response).to have_http_status(:created)
        expect(response.content_type).to include('application/vnd.api+json')
        expect(json[:data][:links][:self]).to include(api_v1_comment_path(Comment.last))
        expect(json[:data][:attributes][:attachment][:url]).to include(filename)
      end

      it 'returns an error for another user' do
        token_sign_in(another_user)
        post :create, params: valid_params.merge(project_id: project.id, task_id: task.id)
        expect(json[:errors].first[:title]).to include("Couldn't find Task")
      end
    end

    context 'with invalid params' do
      it 'renders a JSON response with errors for the new comment' do
        post :create, params: { project_id: project.id, task_id: task.id }.merge(invalid_params)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/vnd.api+json')
        expect(json[:errors]). to include(body: ['size cannot be less than 10',
                                                 'size cannot be greater than 256'])
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:comment) { task.comments.create!(valid_attributes) }

    before { comment }

    it 'destroys the requested comment' do
      expect {
        delete :destroy, params: { project_id: project.id, task_id: task.id, id: comment.to_param }
      }.to change(Comment, :count).by(-1)
    end

    it 'returns an error for another user' do
      token_sign_in(another_user)
      delete :destroy, params: { project_id: project.id, task_id: task.id, id: comment.id }
      expect(json[:errors].first[:title]).to include("Couldn't find Comment")
    end
  end
end
