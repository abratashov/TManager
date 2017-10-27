require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  let(:user) { create(:user) }
  let(:tokens) { user.create_new_auth_token }
  let(:project) { create(:project, :factory_project, user: user) }
  let(:task) { create(:task, :factory_task, project: project) }

  describe 'with persisted object' do
    let!(:comment) { create(:comment, :factory_comment, task: task) }

    it 'returns unauthorized status' do
      get api_v1_project_task_comments_path(project, task)
      expect(response).to have_http_status(401)
    end

    it 'shows comments' do
      get api_v1_project_task_comments_path(project, task), headers: tokens
      expect(response).to have_http_status(200)
      expect(json.to_json).to be_json_eql(factory_v1_json('factory_comments').to_json)
    end

    it 'destroy comment' do
      delete api_v1_project_task_comment_path(project, task, comment), headers: tokens
      expect(response).to have_http_status(204)
    end
  end

  describe 'with new object' do
    it 'create new comment' do
      comment = build(:comment, :factory_comment, task: task)
      params = {
        data: {
          type: :comments,
          attributes: comment.attributes.slice('body', 'attachment')
        }
      }
      post api_v1_project_task_comments_path(project, task), params: params, headers: tokens
      created_comment = Comment.find_by(body: comment.body, task: task)

      expect(response).to have_http_status(:created)
      expect(json.to_json).to be_json_eql(factory_v1_json('factory_comment')
        .deep_merge('data' => {
                      'id' => created_comment.id.to_s,
                      'links' => {
                        'self' => api_v1_project_task_comment_url(project, task, created_comment)
                      }
                    }).to_json)
    end
  end
end
