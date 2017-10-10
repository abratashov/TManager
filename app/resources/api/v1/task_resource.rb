module Api::V1
  class TaskResource < JSONAPI::Resource
    include Rails.application.routes.url_helpers

    attributes :id, :name, :deadline, :position, :done, :comments_count

    def custom_links(options)
      if @model.persisted?
        { self: api_v1_project_task_url(@model.project_id, @model) }
      end
    end
  end
end
