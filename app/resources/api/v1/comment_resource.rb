module Api::V1
  class CommentResource < JSONAPI::Resource
    include Rails.application.routes.url_helpers

    attributes :id, :body, :attachment

    def custom_links(options)
      if @model.persisted?
        { self: api_v1_project_task_comment_url(@model.project.id, @model.task_id, @model) }
      end
    end
  end
end
